from fastapi import APIRouter
from typing import List
from models.tag_models import CompetencyTag

router = APIRouter(prefix="/tags", tags=["tags"])

@router.get("", response_model=List[str])
async def get_tags():
    """Get all available competency tags."""
    return CompetencyTag.list_values()
