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


class TagRequest(BaseModel):
    """Request model for /ai/tag endpoint"""
    problem: str
    action: str
    result: str

class TagAssignmentResponse(BaseModel):
    """Individual tag assignment in API response"""
    tag: str
    confidence: float
    reasoning: str

class TagResponseModel(BaseModel):
    """Response model for /ai/tag endpoint"""
    tags: List[TagAssignmentResponse]

class UserProfileContext(BaseModel):
    """Optional user context for personalized coaching"""
    current_role: Optional[str] = None
    target_role: Optional[str] = None
    career_stage: Optional[str] = None  # "early_career", "mid_career", "senior_leadership"
    current_company: Optional[str] = None
    target_companies: Optional[List[str]] = None
    current_company_size: Optional[str] = None  # "startup", "small", "medium", "enterprise"
    target_company_size: Optional[str] = None  # "startup", "small", "medium", "enterprise"

class CoachRequest(BaseModel):
    """Request model for /ai/coach endpoint"""
    first_name: str  # Required for personalized coaching
    problem: str
    action: str
    result: str
    tags: Optional[List[str]] = None  # Optional: assigned tags
    user_profile: Optional[UserProfileContext] = None  # Optional: career context

class CoachingInsight(BaseModel):
    """Single coaching insight with overview + detail"""
    overview: str  # 1-2 sentence summary
    detail: str    # Detailed paragraph with examples

class CoachResponse(BaseModel):
    """Response model for /ai/coach endpoint"""
    strength: CoachingInsight
    gap: CoachingInsight
    suggestion: CoachingInsight

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

class ProcessRequest(BaseModel):
    """Request model for /ai/process (all-in-one)"""
    audio_url: Optional[str] = None      # Firebase Storage URL
    raw_transcript: Optional[str] = None # Skip transcription if provided
    story_id: str                         # For transcript storage path
    user_id: str                          # For storage path + profile fetch

class ProcessResponse(BaseModel):
    """Complete story payload from /ai/process"""
    title: str
    raw_transcript: str
    raw_transcript_url: Optional[str] = None  # Only set if transcribed
    problem: str
    action: str
    result: str
    tags: List[TagAssignmentResponse]
    coaching: CoachResponse
    confidence_score: float
    warnings: List[str]  # Accumulates warnings from all steps
