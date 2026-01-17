from pydantic import BaseModel, Field
from datetime import datetime
from typing import List, Optional

class MemoryUploadRequest(BaseModel):
    user_id: str
    source_type: str = Field(..., description="Type of source file, e.g., 'resume', 'linkedin', 'freeform'")

class MemoryEntry(BaseModel):
    id: str
    content: str
    source_type: str
    source_filename: str
    category: str = Field(..., description="Categorized type: experience, skill, education, etc.")
    created_at: datetime

class MemorySearchRequest(BaseModel):
    user_id: str
    query: str
    top_k: int = 5

class MemorySearchResponse(BaseModel):
    entries: List[MemoryEntry]
    query: str
