import uuid
from datetime import datetime
from ai.chains import get_memory_summarization_chain
from memory.client import get_user_collection

class MemorySummarizer:
    def __init__(self):
        self.chain = get_memory_summarization_chain()

    async def process_chunks(self, chunks: list[str], user_id: str, source_type: str, filename: str):
        """Process multiple text chunks, summarize them, and store in ChromaDB."""
        collection = get_user_collection(user_id)
        print(f"Summarizing {len(chunks)} chunks for user {user_id}...")
        
        for i, chunk in enumerate(chunks):
            try:
                # Get structured summary from AI
                res = await self.chain.ainvoke({"text_chunk": chunk})
                
                # Generate a unique ID for the memory entry
                entry_id = str(uuid.uuid4())
                
                # Store in ChromaDB
                # ChromaDB handle embeddings automatically with default model if not provided
                collection.add(
                    documents=[res.summary],
                    metadatas=[{
                        "source_type": source_type,
                        "source_filename": filename,
                        "category": res.category,
                        "context": ", ".join(res.context) if isinstance(res.context, list) else res.context,
                        "created_at": datetime.now().isoformat()
                    }],
                    ids=[entry_id]
                )
            except Exception as e:
                # In production, we'd log this properly
                print(f"Error summarizing chunk {i}: {e}")
                continue
