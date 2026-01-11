from fastapi import APIRouter, Depends, HTTPException, status
from firebase_admin import auth, firestore
from firebase_config import firebase_app
from models.auth_models import UserRegisterRequest, UserLoginRequest, UserResponse, TokenResponse
from dependencies.auth_dependencies import get_current_user
import httpx
import os
from datetime import datetime

router = APIRouter(prefix="/auth", tags=["auth"])
db = firestore.client()

@router.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def register(request: UserRegisterRequest):
    try:
        # Construct display name
        display_name = f"{request.first_name} {request.last_name}".strip()
        
        # Create user in Firebase Auth
        user_record = auth.create_user(
            email=request.email,
            password=request.password,
            display_name=display_name
        )
        
        # Create user document in Firestore
        user_data = {
            "email": request.email,
            "first_name": request.first_name,
            "last_name": request.last_name,
            "display_name": display_name,
            "created_at": firestore.SERVER_TIMESTAMP,
            "updated_at": firestore.SERVER_TIMESTAMP
        }
        
        db.collection("users").document(user_record.uid).set(user_data)
        
        return UserResponse(
            user_id=user_record.uid,
            email=request.email,
            display_name=display_name,
            created_at=datetime.utcnow() # Approximate for response
        )
        
    except auth.EmailAlreadyExistsError:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email already registered"
        )
    except Exception as e:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )

@router.post("/login", response_model=TokenResponse)
async def login(request: UserLoginRequest):
    api_key = os.getenv("FIREBASE_API_KEY", "").strip()
    if not api_key:
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR, 
            detail="Firebase API Key not configured"
        )
        
    # Verify password using Firebase REST API
    verify_url = f"https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key={api_key}"
    
    async with httpx.AsyncClient() as client:
        response = await client.post(verify_url, json={
            "email": request.email,
            "password": request.password,
            "returnSecureToken": True
        })
        
        if response.status_code != 200:
            error_data = response.json()
            error_message = error_data.get("error", {}).get("message", "Invalid email or password")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail=error_message
            )
            
        data = response.json()
        uid = data["localId"]
        
        # Create a custom token for the client
        # Note: In a real app, Client SDK handles login. 
        # Here we generate a custom token to return to our client 
        # if they need to sign in to Firebase Client SDK.
        custom_token = auth.create_custom_token(uid)
        
        # Fetch user data
        user_doc = db.collection("users").document(uid).get()
        if not user_doc.exists:
             # Should ideally exist if registered via our endpoint, but handle edge case
            user_data = {"email": request.email, "created_at": datetime.utcnow()}
        else:
            user_data = user_doc.to_dict()
            # Handle Firestore timestamp conversion if needed for Pydantic
            if "created_at" in user_data and user_data["created_at"]:
                 # Firestore Timestamp to datetime
                 pass 

        return TokenResponse(
            token=custom_token.decode("utf-8"),
            user=UserResponse(
                user_id=uid,
                email=request.email,
                display_name=user_data.get("display_name"),
                created_at=datetime.utcnow() # Placeholder
            )
        )

@router.get("/me", response_model=UserResponse)
async def get_current_user_profile(decoded_token: dict = Depends(get_current_user)):
    uid = decoded_token["uid"]
    user_doc = db.collection("users").document(uid).get()
    
    if not user_doc.exists:
        # JIT Provisioning for Social Auth (Google, etc.)
        user_data = {
            "email": decoded_token.get("email"),
            "display_name": decoded_token.get("name"),
            "created_at": firestore.SERVER_TIMESTAMP,
            "updated_at": firestore.SERVER_TIMESTAMP
        }
        db.collection("users").document(uid).set(user_data)
        data = user_data
        # For response, use current time as approx created_at if using server timestamp
        data["created_at"] = datetime.utcnow()
    else:
        data = user_doc.to_dict()
    
    return UserResponse(
        user_id=uid,
        email=data.get("email"),
        display_name=data.get("display_name"),
        first_name=data.get("first_name"),
        last_name=data.get("last_name"),
        current_role=data.get("current_role"),
        target_role=data.get("target_role"),
        current_industry=data.get("current_industry"),
        target_industry=data.get("target_industry"),
        career_stage=data.get("career_stage"),
        transition_types=data.get("transition_types"),
        profile_photo_url=data.get("profile_photo_url"),
        created_at=datetime.utcnow() # Placeholder
    )
