from fastapi import APIRouter, HTTPException, Depends
from models.ai_models import StructureRequest, StructureResponse
from ai.chains import get_structure_chain

router = APIRouter(
    prefix="/ai",
    tags=["AI Processing"]
)

@router.post("/structure", response_model=StructureResponse)
async def structure_transcript(request: StructureRequest):
    """
    Transforms a raw speech transcript into a structured PAR (Problem-Action-Result) story.
    """
    try:
        # Get the chain
        chain = get_structure_chain()
        
        # Invoke the chain
        # The chain returns a PARStructure Pydantic object
        result = chain.invoke({"raw_transcript": request.raw_transcript})
        
        # Convert to API response model (they share the same structure)
        return StructureResponse(
            title=result.title,
            problem=result.problem,
            action=result.action,
            result=result.result,
            confidence_score=result.confidence_score,
            warnings=result.warnings
        )
        
    except Exception as e:
        # In production, log the full error
        print(f"Error in /ai/structure: {str(e)}")
        raise HTTPException(
            status_code=500, 
            detail=f"Failed to process transcript: {str(e)}"
        )
