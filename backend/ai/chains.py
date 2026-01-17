import os
from langchain_google_genai import ChatGoogleGenerativeAI
from ai.schemas import PARStructure
from ai.prompts import PAR_STRUCTURING_PROMPT

def get_structure_chain():
    """
    Creates and returns the LangChain runnable for PAR structuring.
    Expects 'raw_transcript' as input.
    Returns PARStructure object.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Initialize Gemini 2.5 Pro (or fallback to user's config)
    # Using 'gemini-2.0-flash' as a high-performance, cost-effective default for structured tasks
    # or specific requested model.
    # Note: 'gemini-1.5-pro' is also excellent for instruction following.
    # We'll stick to a robust model.
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash", # efficient and smart enough for this task
        google_api_key=api_key,
        temperature=0.7 # Slight creativity for titles/phrasing, but grounded
    )

    # Bind the structured output schema
    start_chain = PAR_STRUCTURING_PROMPT | llm.with_structured_output(PARStructure)
    
    return start_chain
