from fastapi import APIRouter, HTTPException, Depends
from models.ai_models import (
    StructureRequest, StructureResponse,
    TranscribeRequest, TranscribeResponse,
    TagRequest, TagResponseModel,
    CoachRequest, CoachResponse,
    ProcessRequest, ProcessResponse
)
from ai.chains import get_structure_chain, get_tagging_chain, get_coaching_chain, get_coaching_agent
import json
from ai.transcriber import transcribe_audio_file
from firebase_storage import download_audio_from_storage, upload_transcript_to_storage
from firebase_config import get_user_profile
import os

router = APIRouter(
    prefix="/ai",
    tags=["AI Processing"]
)

def parse_agent_json(output: str):
    """Helper to extract and parse JSON from agent output string."""
    clean_json = output.strip()
    if "```json" in clean_json:
        clean_json = clean_json.split("```json")[-1].split("```")[0].strip()
    elif "```" in clean_json:
        clean_json = clean_json.split("```")[-1].split("```")[0].strip()
    return json.loads(clean_json)

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


@router.post("/tag", response_model=TagResponseModel)
async def tag_story(request: TagRequest):
    """
    Auto-assign 1-3 behavioral competency tags to a PAR story.
    
    Analyzes the Problem-Action-Result narrative and identifies
    the most relevant competency tags with confidence scores and reasoning.
    """
    try:
        chain = get_tagging_chain()
        
        # Invoke the chain with PAR components
        result = chain.invoke({
            "problem": request.problem,
            "action": request.action,
            "result": request.result
        })
        
        # Convert to API response format
        tag_assignments = [
            {"tag": ta.tag, "confidence": ta.confidence, "reasoning": ta.reasoning}
            for ta in result.tags
        ]
        
        return TagResponseModel(tags=tag_assignments)
        
    except Exception as e:
        print(f"Error in /ai/tag: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Tagging failed: {str(e)}"
        )

@router.post("/coach", response_model=CoachResponse)
async def coach_story(request: CoachRequest):
    """
    Generate coaching insights for a PAR story.
    
    Provides:
    - Strength: What the user did well
    - Gap: What's missing or could be stronger
    - Suggestion: Actionable improvement tip
    
    Personalized with first name and optional career context.
    """
    # Prepare optional inputs
    tags_str = ", ".join(request.tags) if request.tags else "None provided"
    # UserProfileContext is converted to dict for the prompt
    profile_dict = request.user_profile.model_dump(exclude_none=True) if request.user_profile else {}
    profile_str = str(profile_dict) if profile_dict else "None provided"

    # Try tool-calling agent first
    try:
        agent_executor = get_coaching_agent(request.user_id)
        agent_result = agent_executor.invoke({
            "first_name": request.first_name,
            "problem": request.problem,
            "action": request.action,
            "result": request.result,
            "tags": tags_str,
            "user_profile": profile_str
        })
        
        parsed = parse_agent_json(agent_result["output"])
        return CoachResponse(
            strength=parsed["strength"],
            gap=parsed["gap"],
            suggestion=parsed["suggestion"]
        )
    except Exception as agent_err:
        print(f"Agent coaching failed: {str(agent_err)}. Falling back to basic chain.")
        # Fallback to basic chain (Phase 4 logic)
        try:
            chain = get_coaching_chain()
            result = chain.invoke({
                "first_name": request.first_name,
                "problem": request.problem,
                "action": request.action,
                "result": request.result,
                "tags": tags_str,
                "user_profile": profile_str
            })
            
            return CoachResponse(
                strength=result.strength.model_dump(),
                gap=result.gap.model_dump(),
                suggestion=result.suggestion.model_dump()
            )
        except Exception as e:
            print(f"Coaching fallback failed: {str(e)}")
            raise HTTPException(
                status_code=500,
                detail=f"Coaching failed: {str(e)}"
            )
        
    except Exception as e:
        print(f"Error in /ai/coach: {str(e)}")
        raise HTTPException(
            status_code=500,
            detail=f"Coaching failed: {str(e)}"
        )

@router.post("/process", response_model=ProcessResponse)
async def process_story(request: ProcessRequest):
    """
    All-in-one: transcribe → structure → tag → coach.
    Returns complete story payload ready for frontend display/save.
    """
    warnings = []
    temp_audio_path = None
    
    # 1. Input validation
    if not request.audio_url and not request.raw_transcript:
        raise HTTPException(status_code=400, detail="Either audio_url or raw_transcript must be provided")

    try:
        # 2. Transcription (if needed)
        transcript_text = request.raw_transcript
        raw_transcript_url = None
        
        if request.audio_url and not request.raw_transcript:
            try:
                # Reuse logic from /ai/transcribe
                temp_audio_path = download_audio_from_storage(request.audio_url)
                transcript_text = transcribe_audio_file(temp_audio_path)
                raw_transcript_url = upload_transcript_to_storage(
                    user_id=request.user_id,
                    story_id=request.story_id,
                    transcript_text=transcript_text
                )
            except Exception as e:
                print(f"Transcription failed in /ai/process: {str(e)}")
                raise HTTPException(status_code=500, detail=f"Transcription failed: {str(e)}")

        # 2.5 Validation: Ensure transcript is not empty
        if not transcript_text or not transcript_text.strip():
            raise HTTPException(
                status_code=400, 
                detail="Transcription failed or audio was empty. Please try recording again."
            )

        # 3. Structure
        try:
            structure_chain = get_structure_chain()
            structure_result = structure_chain.invoke({"raw_transcript": transcript_text})
            warnings.extend(structure_result.warnings)
        except Exception as e:
            print(f"Structuring failed in /ai/process: {str(e)}")
            raise HTTPException(status_code=500, detail=f"Structuring failed: {str(e)}")

        # 4. Tagging (Graceful Failure)
        tags = []
        try:
            tagging_chain = get_tagging_chain()
            tag_result = tagging_chain.invoke({
                "problem": structure_result.problem,
                "action": structure_result.action,
                "result": structure_result.result
            })
            tags = [{"tag": ta.tag, "confidence": ta.confidence, "reasoning": ta.reasoning} for ta in tag_result.tags]
        except Exception as e:
            print(f"Tagging failed in /ai/process (graceful): {str(e)}")
            warnings.append(f"Behavioral tagging failed: {str(e)}")

        # 5. Coaching (Graceful Failure - with Tool Agent)
        coaching = None
        try:
            # Fetch user profile for context
            profile_data = get_user_profile(request.user_id)
            first_name = profile_data.get("first_name", "User")
            
            # Prepare optional profile context
            profile_context_str = "None provided"
            if profile_data:
                context_dict = {
                    "current_role": profile_data.get("current_role"),
                    "target_role": profile_data.get("target_role"),
                    "career_stage": profile_data.get("career_stage")
                }
                # Filter out None values
                context_dict = {k: v for k, v in context_dict.items() if v is not None}
                if context_dict:
                    profile_context_str = str(context_dict)

            tags_list = [t["tag"] for t in tags] if tags else []
            
            # Use Tool Agent
            try:
                agent_executor = get_coaching_agent(request.user_id)
                agent_result = agent_executor.invoke({
                    "first_name": first_name,
                    "problem": structure_result.problem,
                    "action": structure_result.action,
                    "result": structure_result.result,
                    "tags": ", ".join(tags_list) if tags_list else "None provided",
                    "user_profile": profile_context_str
                })
                coaching = parse_agent_json(agent_result["output"])
            except Exception as e:
                print(f"Agent failed in /ai/process fallback to chain: {str(e)}")
                # Fallback to chain
                coaching_chain = get_coaching_chain()
                coach_result = coaching_chain.invoke({
                    "first_name": first_name,
                    "problem": structure_result.problem,
                    "action": structure_result.action,
                    "result": structure_result.result,
                    "tags": ", ".join(tags_list) if tags_list else "None provided",
                    "user_profile": profile_context_str
                })
                coaching = coach_result.model_dump()
        except Exception as e:
            print(f"Coaching failed in /ai/process (graceful): {str(e)}")
            warnings.append(f"Coaching insights failed: {str(e)}")
            # Provide empty coaching object if it failed
            from models.ai_models import CoachingInsight, CoachResponse
            empty_insight = CoachingInsight(overview="Unavailable", detail="Coaching generation failed or was skipped.")
            coaching = CoachResponse(strength=empty_insight, gap=empty_insight, suggestion=empty_insight).model_dump()

        # 6. Final Response
        return ProcessResponse(
            title=structure_result.title,
            raw_transcript=transcript_text,
            raw_transcript_url=raw_transcript_url,
            problem=structure_result.problem,
            action=structure_result.action,
            result=structure_result.result,
            tags=tags,
            coaching=coaching,
            confidence_score=structure_result.confidence_score,
            warnings=warnings
        )

    finally:
        # Cleanup temp file if it exists
        if temp_audio_path and os.path.exists(temp_audio_path):
            try:
                os.remove(temp_audio_path)
            except:
                pass
