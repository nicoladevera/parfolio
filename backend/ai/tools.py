from langchain_core.tools import tool
from memory.client import get_user_collection
import os

@tool
def search_personal_memory(query: str, user_id: str, top_k: int = 3) -> str:
    """
    Search the user's personal memory database for relevant professional context.
    
    Use this tool when you need to:
    - Recall specific skills, projects, or achievements the user has mentioned in uploaded documents.
    - Find context about the user's past experience to personalize coaching feedback.
    - Look up details like job titles, company names, or technologies the user is familiar with.
    
    Args:
        query: A natural language search query or key terms to look for.
        user_id: The unique identifier for the user (required).
        top_k: Number of relevant results to return (default: 3).
    
    Returns:
        A formatted string containing the most relevant memory entries found, or a message if none are found.
    """
    try:
        collection = get_user_collection(user_id)
        results = collection.query(
            query_texts=[query],
            n_results=top_k
        )
        
        if not results["documents"] or not results["documents"][0]:
            return f"No relevant personal memories found for query: {query}"
        
        formatted_results = []
        for doc, metadata in zip(results["documents"][0], results["metadatas"][0]):
            category = metadata.get("category", "info")
            formatted_results.append(f"[{category.upper()}] {doc}")
            
        return "\n".join(formatted_results)
    except Exception as e:
        return f"Error searching personal memory: {str(e)}"
