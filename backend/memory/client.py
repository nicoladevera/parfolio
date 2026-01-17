import chromadb
from chromadb.config import Settings
from pathlib import Path

def get_chroma_client():
    """Get or create the ChromaDB persistent client."""
    # Base path for backend
    backend_dir = Path(__file__).parent.parent
    persist_dir = backend_dir / "data" / "chromadb"
    
    # Ensure directory exists
    persist_dir.mkdir(parents=True, exist_ok=True)
    
    return chromadb.PersistentClient(path=str(persist_dir))

def get_user_collection(user_id: str):
    """Get or create a collection scoped to a specific user."""
    client = get_chroma_client()
    # Scoping collection names to user IDs ensures data isolation
    collection_name = f"user_memory_{user_id}"
    return client.get_or_create_collection(name=collection_name)
