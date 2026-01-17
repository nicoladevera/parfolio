from fastapi import APIRouter, Depends, HTTPException, status, Query
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter
from typing import List, Optional
from models.story_models import StoryCreate, StoryUpdate, StoryResponse
from dependencies.auth_dependencies import get_current_user
from datetime import datetime
import uuid

router = APIRouter(prefix="/stories", tags=["stories"])
db = firestore.client()

@router.post("", response_model=StoryResponse, status_code=status.HTTP_201_CREATED)
async def create_story(
    request: StoryCreate,
    decoded_token: dict = Depends(get_current_user)
):
    """Create a new story for the authenticated user."""
    uid = decoded_token["uid"]
    story_id = str(uuid.uuid4())
    
    story_data = request.model_dump()
    story_data.update({
        "story_id": story_id,
        "user_id": uid,
        "created_at": firestore.SERVER_TIMESTAMP,
        "updated_at": firestore.SERVER_TIMESTAMP
    })
    
    stories_ref = db.collection("stories").document(story_id)
    stories_ref.set(story_data)
    
    # Fetch back to get the server timestamps
    doc = stories_ref.get()
    return _format_story_doc(doc)

@router.get("", response_model=List[StoryResponse])
async def list_stories(
    status: Optional[str] = Query(None, description="Filter by status (draft/complete)"),
    tag: Optional[str] = Query(None, description="Filter by competency tag"),
    decoded_token: dict = Depends(get_current_user)
):
    """List stories for the authenticated user with optional filtering."""
    uid = decoded_token["uid"]
    query = db.collection("stories").where(filter=FieldFilter("user_id", "==", uid))

    
    if status:
        query = query.where(filter=FieldFilter("status", "==", status))

    
    if tag:
        # Note: If tags is an array, we use 'array_contains'
        query = query.where(filter=FieldFilter("tags", "array_contains", tag))

    
    # Order by creation date descending
    # Note: In production, create a composite index for 'user_id' and 'created_at'.
    # To avoid 'FailedPrecondition' errors during initial setup, we'll sort in memory.
    docs = query.stream()
    stories = [_format_story_doc(doc) for doc in docs]
    stories.sort(key=lambda x: x.created_at, reverse=True)
    
    return stories

@router.get("/{story_id}", response_model=StoryResponse)
async def get_story(
    story_id: str,
    decoded_token: dict = Depends(get_current_user)
):
    """Get a specific story by ID."""
    uid = decoded_token["uid"]
    doc_ref = db.collection("stories").document(story_id)
    doc = doc_ref.get()
    
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Story not found")
    
    data = doc.to_dict()
    if data.get("user_id") != uid:
        raise HTTPException(status_code=403, detail="Not authorized to access this story")
    
    return _format_story_doc(doc)

@router.put("/{story_id}", response_model=StoryResponse)
async def update_story(
    story_id: str,
    request: StoryUpdate,
    decoded_token: dict = Depends(get_current_user)
):
    """Update an existing story."""
    uid = decoded_token["uid"]
    doc_ref = db.collection("stories").document(story_id)
    doc = doc_ref.get()
    
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Story not found")
    
    data = doc.to_dict()
    if data.get("user_id") != uid:
        raise HTTPException(status_code=403, detail="Not authorized to update this story")
    
    update_data = {k: v for k, v in request.model_dump().items() if v is not None}
    if not update_data:
        return _format_story_doc(doc)
        
    update_data["updated_at"] = firestore.SERVER_TIMESTAMP
    doc_ref.update(update_data)
    
    # Return updated doc
    return _format_story_doc(doc_ref.get())

@router.delete("/{story_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_story(
    story_id: str,
    decoded_token: dict = Depends(get_current_user)
):
    """Delete a story."""
    uid = decoded_token["uid"]
    doc_ref = db.collection("stories").document(story_id)
    doc = doc_ref.get()
    
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Story not found")
    
    data = doc.to_dict()
    if data.get("user_id") != uid:
        raise HTTPException(status_code=403, detail="Not authorized to delete this story")
    
    doc_ref.delete()
    return None

def _format_story_doc(doc):
    """Helper to format Firestore doc into StoryResponse model."""
    data = doc.to_dict()
    
    # Handle Firestore timestamps
    created_at = data.get("created_at")
    updated_at = data.get("updated_at")
    
    # If using SERVER_TIMESTAMP, it might be a datetime or a Sentinel/Placeholder
    # Locally/Emulator it might already be a datetime
    if hasattr(created_at, "to_datetime"):
        created_at = created_at.to_datetime()
    if hasattr(updated_at, "to_datetime"):
        updated_at = updated_at.to_datetime()
        
    # Ensure they are ISO strings for pydantic if needed, but StoryResponse expects datetime
    # Firestore returns datetime objects usually
    
    return StoryResponse(
        story_id=data.get("story_id"),
        user_id=data.get("user_id"),
        title=data.get("title"),
        problem=data.get("problem"),
        action=data.get("action"),
        result=data.get("result"),
        tags=data.get("tags", []),
        raw_transcript=data.get("raw_transcript"),
        raw_transcript_url=data.get("raw_transcript_url"),
        audio_url=data.get("audio_url"),
        status=data.get("status", "draft"),
        coaching=data.get("coaching"),
        created_at=created_at or datetime.now(),
        updated_at=updated_at or datetime.now()
    )
