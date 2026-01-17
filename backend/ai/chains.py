import os
from langchain_google_genai import ChatGoogleGenerativeAI
from ai.schemas import PARStructure, TagResponse
from ai.prompts import PAR_STRUCTURING_PROMPT, TAGGING_PROMPT

def get_structure_chain():
    """
    Creates and returns the LangChain runnable for PAR structuring.
    Expects 'raw_transcript' as input.
    Returns PARStructure object.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Initialize Gemini 2.0 Flash (high-performance, cost-effective default)
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.7 # Slight creativity for titles/phrasing, but grounded
    )

    # Bind the structured output schema
    start_chain = PAR_STRUCTURING_PROMPT | llm.with_structured_output(PARStructure)
    
    return start_chain

def get_tagging_chain():
    """
    Creates and returns the LangChain runnable for behavioral tagging.
    Expects 'problem', 'action', 'result' as input.
    Returns TagResponse object with 1-3 tags.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Use same Gemini model as structuring for consistency
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.3  # Lower temperature for classification (more deterministic)
    )

    # Bind structured output schema
    tagging_chain = TAGGING_PROMPT | llm.with_structured_output(TagResponse)
    
    return tagging_chain
