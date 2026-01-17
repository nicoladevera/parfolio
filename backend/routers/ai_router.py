from fastapi import APIRouter, HTTPException, Depends
from models.ai_models import StructureRequest, StructureResponse, TranscribeRequest, TranscribeResponse
from ai.chains import get_structure_chain
from ai.transcriber import transcribe_audio_file
from firebase_storage import download_audio_from_storage, upload_transcript_to_storage
import os

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

@router.post("/transcribe", response_model=TranscribeResponse)
async def transcribe_audio(request: TranscribeRequest):
    """
    Transcribes audio from Firebase Storage URL using Whisper.
    Saves transcript to Firebase Storage and returns text + URL.
    """
    temp_audio_path = None
    try:
        # 1. Download audio from Firebase Storage to temp file
        temp_audio_path = download_audio_from_storage(request.audio_url)
        
        # 2. Run Whisper transcription
        transcript_text = transcribe_audio_file(temp_audio_path)
        
        # 3. Upload transcript text to Firebase Storage
        transcript_url = upload_transcript_to_storage(
            user_id=request.user_id,
            story_id=request.story_id,
            transcript_text=transcript_text
        )
        
        # 4. Return response
        return TranscribeResponse(
            audio_url=request.audio_url,
            raw_transcript=transcript_text,
            raw_transcript_url=transcript_url
        )
        
    except Exception as e:
        print(f"Error in /ai/transcribe: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Failed to transcribe audio: {str(e)}"
        )
    finally:
        # Cleanup temp file
        if temp_audio_path and os.path.exists(temp_audio_path):
            try:
                os.remove(temp_audio_path)
            except:
                pass
