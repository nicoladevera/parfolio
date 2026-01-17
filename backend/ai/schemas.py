from typing import List
from pydantic import BaseModel, Field

class PARStructure(BaseModel):
    """
    Structured output for the PAR (Problem-Action-Result) story format.
    """
    title: str = Field(
        ..., 
        description="A concise, descriptive title for the story (max 10 words)."
    )
    problem: str = Field(
        ..., 
        description="The 'Problem' section: What was the situation, challenge, or context? Be specific about the difficulty."
    )
    action: str = Field(
        ..., 
        description="The 'Action' section: What specific steps did the speaker take? Focus on 'I' statements and ownership."
    )
    result: str = Field(
        ..., 
        description="The 'Result' section: What was the outcome? Include quantitative metrics or qualitative impact if available."
    )
    confidence_score: float = Field(
        ..., 
        description="Self-assessed confidence score (0.0 to 1.0) based on how clearly the PAR elements were present in the transcript."
    )
    warnings: List[str] = Field(
        default_factory=list,
        description="List of specific warnings or suggestions for improvement (e.g., 'Result lacks metrics', 'Problem context is vague')."
    )

class TagAssignment(BaseModel):
    """
    Individual tag assignment with confidence and reasoning.
    """
    tag: str = Field(
        ...,
        description="The assigned competency tag (must be one of the 10 predefined tags)."
    )
    confidence: float = Field(
        ...,
        ge=0.0,
        le=1.0,
        description="Confidence score for this tag assignment (0.0 to 1.0)."
    )
    reasoning: str = Field(
        ...,
        description="Brief explanation (1-2 sentences) of why this tag was assigned based on the PAR story."
    )

class TagResponse(BaseModel):
    """
    Structured output for behavioral tagging.
    Returns 1-3 tags with confidence and reasoning.
    """
    tags: List[TagAssignment] = Field(
        ...,
        min_length=1,
        max_length=3,
        description="List of 1-3 assigned competency tags with metadata."
    )
