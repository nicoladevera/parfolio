import uuid
from datetime import datetime
from ai.chains import get_memory_summarization_chain
from memory.client import get_user_collection

class MemorySummarizer:
    def __init__(self):
        self.chain = get_memory_summarization_chain()

    async def process_document(self, full_text: str, user_id: str, source_type: str, filename: str):
        """Process an entire document, create a comprehensive summary, and store as ONE memory entry in ChromaDB."""
        collection = get_user_collection(user_id)
        print(f"Summarizing document '{filename}' for user {user_id}...")
        
        try:
            # Get comprehensive structured summary from AI for the entire document
            res = await self.chain.ainvoke({"text_chunk": full_text})
            
            # Generate a unique ID for the memory entry
            entry_id = str(uuid.uuid4())
            
            # Store in ChromaDB as a single entry
            # ChromaDB handles embeddings automatically with default model if not provided
            collection.add(
                documents=[res.summary],
                metadatas=[{
                    "source_type": res.detected_source_type if res.detected_source_type else source_type,
                    "source_filename": filename,
                    "category": res.category,
                    "context": ", ".join(res.context) if isinstance(res.context, list) else res.context,
                    "created_at": datetime.now().isoformat()
                }],
                ids=[entry_id]
            )
            print(f"Successfully created memory entry {entry_id} for '{filename}'")
            return entry_id
        except Exception as e:
            # In production, we'd log this properly
            print(f"Error summarizing document '{filename}': {e}")
            raise
