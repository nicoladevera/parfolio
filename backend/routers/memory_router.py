from fastapi import APIRouter, UploadFile, File, Form, HTTPException
from typing import List
import asyncio
from models.memory_models import MemoryUploadRequest, MemorySearchRequest, MemorySearchResponse, MemoryEntry
from memory.parser import FileParser
from memory.chunker import MemoryChunker
from memory.summarizer import MemorySummarizer
from memory.client import get_user_collection
from datetime import datetime

router = APIRouter()
chunker = MemoryChunker()
summarizer = MemorySummarizer()

@router.post("/upload")
async def upload_context_file(
    user_id: str = Form(...),
    source_type: str = Form("resume"),
    file: UploadFile = File(...)
):
    """
    Upload a context file (PDF, DOCX, TXT), parse it, chunk it, 
    summarize it into memory entries, and store in ChromaDB.
    """
    content = await file.read()
    text = FileParser.extract_text(content, file.filename)
    
    if not text:
        raise HTTPException(status_code=400, detail=f"Unsupported or unreadable file type: {file.filename}")

    # Chunk the text
    chunks = chunker.chunk_text(text)
    
    # Process chunks in background (summarize and store)
    # Note: For long files, this might take a while. In production, use a task queue.
    # For now, we'll run it and return when done or run as background task.
    # We'll run it as a task to not block the response if there are many chunks.
    asyncio.create_task(summarizer.process_chunks(chunks, user_id, source_type, file.filename))
    
    return {
        "message": f"Successfully started processing {file.filename}",
        "chunks_count": len(chunks),
        "status": "processing"
    }

@router.get("/entries/{user_id}", response_model=List[MemoryEntry])
async def list_memory_entries(user_id: str):
    """List all memory entries for a specific user."""
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

@router.delete("/entries/{user_id}/{entry_id}")
async def delete_memory_entry(user_id: str, entry_id: str):
    """Delete a specific memory entry."""
    collection = get_user_collection(user_id)
    collection.delete(ids=[entry_id])
    return {"message": f"Deleted entry {entry_id}"}

@router.post("/search", response_model=MemorySearchResponse)
async def search_memory(request: MemorySearchRequest):
    """
    Search across a user's memory entries using semantic similarity.
    Returns the top K most relevant entries.
    """
    collection = get_user_collection(request.user_id)
    
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
