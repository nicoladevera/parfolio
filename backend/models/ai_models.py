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
