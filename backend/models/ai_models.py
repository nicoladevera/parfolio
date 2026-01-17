from typing import List, Optional
from pydantic import BaseModel

class StructureRequest(BaseModel):
    """
    Request model for the /ai/structure endpoint.
    """
    raw_transcript: str

class StructureResponse(BaseModel):
    """
    Response model for the /ai/structure endpoint.
    """
    title: str
    problem: str
    action: str
    result: str
    confidence_score: float
    warnings: List[str]

class TranscribeRequest(BaseModel):
    """Request model for /ai/transcribe"""
    audio_url: str  # Firebase Storage URL (gs:// or https://)
    story_id: str   # Used for naming the transcript file
    user_id: str    # Used for storage path (GDPR-friendly)

class TranscribeResponse(BaseModel):
    """Response model for /ai/transcribe"""
    audio_url: str           # Echo back for reference
    raw_transcript: str      # The transcribed text
    raw_transcript_url: str  # Firebase Storage URL to saved .txt file
