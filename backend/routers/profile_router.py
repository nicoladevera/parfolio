from fastapi import APIRouter, Depends, HTTPException, status
from firebase_admin import firestore
from models.profile_models import ProfileUpdateRequest, ProfileResponse
from dependencies.auth_dependencies import get_current_user

router = APIRouter(prefix="/profile", tags=["profile"])
db = firestore.client()

@router.get("", response_model=ProfileResponse)
async def get_profile(decoded_token: dict = Depends(get_current_user)):
    """Get current user's full profile."""
    uid = decoded_token["uid"]
    user_doc = db.collection("users").document(uid).get()
    
    if not user_doc.exists:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User profile not found"
        )
    
    data = user_doc.to_dict()
    return ProfileResponse(
        user_id=uid,
        email=data.get("email", ""),
        first_name=data.get("first_name"),
        last_name=data.get("last_name"),
        display_name=data.get("display_name"),
        current_role=data.get("current_role"),
        target_role=data.get("target_role"),
        current_industry=data.get("current_industry"),
        target_industry=data.get("target_industry"),
        career_stage=data.get("career_stage"),
        transition_types=data.get("transition_types"),
        profile_photo_url=data.get("profile_photo_url"),
        current_company=data.get("current_company"),
        target_companies=data.get("target_companies"),
        current_company_size=data.get("current_company_size"),
        target_company_size=data.get("target_company_size")
    )

@router.put("", response_model=ProfileResponse)
async def update_profile(
    request: ProfileUpdateRequest,
    decoded_token: dict = Depends(get_current_user)
):
    """Update current user's optional profile fields."""
    uid = decoded_token["uid"]
    
    # Filter out None values to avoid overwriting existing data with nulls 
    # if they weren't provided in the request (partial update)
    update_data = {k: v for k, v in request.model_dump().items() if v is not None}
    
    if not update_data:
        # If no data provided, just return current profile
        return await get_profile(decoded_token)
        
    update_data["updated_at"] = firestore.SERVER_TIMESTAMP
    
    db.collection("users").document(uid).update(update_data)
    
    # Return the updated profile
    return await get_profile(decoded_token)
