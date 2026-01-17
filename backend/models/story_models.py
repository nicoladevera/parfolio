from pydantic import BaseModel, Field
from typing import List, Optional
from datetime import datetime

class CoachingInsightModel(BaseModel):
    overview: str
    detail: str

class CoachingModel(BaseModel):
    strength: CoachingInsightModel
    gap: CoachingInsightModel
    suggestion: CoachingInsightModel

class StoryBase(BaseModel):
    title: str
    problem: str
    action: str
    result: str
    tags: List[str]  # List of competency tags as strings
    raw_transcript: str
    raw_transcript_url: Optional[str] = None
    audio_url: Optional[str] = None
    status: str = "draft"  # "draft" | "complete"
    warnings: List[str] = []

class StoryCreate(StoryBase):
    coaching: Optional[CoachingModel] = None

class StoryUpdate(BaseModel):
    title: Optional[str] = None
    problem: Optional[str] = None
    action: Optional[str] = None
    result: Optional[str] = None
    tags: Optional[List[str]] = None
    status: Optional[str] = None
    coaching: Optional[CoachingModel] = None

class StoryResponse(StoryBase):
    story_id: str
    user_id: str
    coaching: Optional[CoachingModel] = None
    created_at: datetime
    updated_at: datetime
