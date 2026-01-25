import chromadb
import os
from chromadb.config import Settings
from pathlib import Path

def get_chroma_client():
    """
    Get or create the ChromaDB persistent client.

    Environment-aware configuration:
    - Production (ENVIRONMENT=production): Uses backend/data/chromadb
    - Local development (default): Uses backend/data/chromadb_local

    This ensures local testing doesn't interfere with production data.
    """
    # Base path for backend
    backend_dir = Path(__file__).parent.parent

    # Use separate databases for production vs development
    if os.getenv("ENVIRONMENT") == "production":
        persist_dir = backend_dir / "data" / "chromadb"
    else:
        # Local development uses separate database
        persist_dir = backend_dir / "data" / "chromadb_local"

    # Ensure directory exists
    persist_dir.mkdir(parents=True, exist_ok=True)

    return chromadb.PersistentClient(path=str(persist_dir))

def get_user_collection(user_id: str):
    """Get or create a collection scoped to a specific user."""
    client = get_chroma_client()
    # Scoping collection names to user IDs ensures data isolation
    collection_name = f"user_memory_{user_id}"
    return client.get_or_create_collection(name=collection_name)
