from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Depends
from typing import List
import asyncio
from models.memory_models import MemoryUploadRequest, MemorySearchRequest, MemorySearchResponse, MemoryEntry
from memory.parser import FileParser
from memory.chunker import MemoryChunker
from memory.summarizer import MemorySummarizer
from memory.client import get_user_collection
from datetime import datetime
from dependencies.auth_dependencies import get_current_user

router = APIRouter()
chunker = MemoryChunker()
summarizer = MemorySummarizer()

@router.post("/upload")
async def upload_context_file(
    source_type: str = Form("resume"),
    file: UploadFile = File(...),
    decoded_token: dict = Depends(get_current_user)
):
    """
    Upload a context file (PDF, DOCX, TXT), parse it,
    create ONE comprehensive memory entry, and store in ChromaDB.
    """
    user_id = decoded_token["uid"]

    content = await file.read()
    text = FileParser.extract_text(content, file.filename)

    if not text:
        raise HTTPException(status_code=400, detail=f"Unsupported or unreadable file type: {file.filename}")

    # Process the entire document as one unit (no chunking)
    # Run as background task to not block the response
    asyncio.create_task(summarizer.process_document(text, user_id, source_type, file.filename))

    return {
        "message": f"Successfully started processing {file.filename}",
        "status": "processing"
    }

@router.get("/entries", response_model=List[MemoryEntry])
async def list_memory_entries(decoded_token: dict = Depends(get_current_user)):
    """List all memory entries for the authenticated user."""
    user_id = decoded_token["uid"]
    collection = get_user_collection(user_id)
    results = collection.get()

    entries = []
    if results["ids"]:
        for i in range(len(results["ids"])):
            entries.append(MemoryEntry(
                id=results["ids"][i],
                content=results["documents"][i],
                source_type=results["metadatas"][i]["source_type"],
                source_filename=results["metadatas"][i]["source_filename"],
                category=results["metadatas"][i]["category"],
                created_at=datetime.fromisoformat(results["metadatas"][i]["created_at"])
            ))

    return entries

@router.delete("/entries/{entry_id}")
async def delete_memory_entry(entry_id: str, decoded_token: dict = Depends(get_current_user)):
    """Delete a specific memory entry for the authenticated user."""
    user_id = decoded_token["uid"]
    collection = get_user_collection(user_id)
    collection.delete(ids=[entry_id])
    return {"message": f"Deleted entry {entry_id}"}

@router.post("/search", response_model=MemorySearchResponse)
async def search_memory(request: MemorySearchRequest, decoded_token: dict = Depends(get_current_user)):
    """
    Search across the authenticated user's memory entries using semantic similarity.
    Returns the top K most relevant entries.
    """
    # Override request.user_id with authenticated user
    user_id = decoded_token["uid"]
    collection = get_user_collection(user_id)

    # Query ChromaDB
    results = collection.query(
        query_texts=[request.query],
        n_results=request.top_k
    )

    entries = []
    if results["ids"] and results["ids"][0]:
        for i in range(len(results["ids"][0])):
            entries.append(MemoryEntry(
                id=results["ids"][0][i],
                content=results["documents"][0][i],
                source_type=results["metadatas"][0][i]["source_type"],
                source_filename=results["metadatas"][0][i]["source_filename"],
                category=results["metadatas"][0][i]["category"],
                created_at=datetime.fromisoformat(results["metadatas"][0][i]["created_at"])
            ))

    return MemorySearchResponse(entries=entries, query=request.query)
