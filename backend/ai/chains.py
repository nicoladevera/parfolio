import os
from langchain_google_genai import ChatGoogleGenerativeAI
from ai.schemas import PARStructure, TagResponse, CoachingResult, MemoryEntryStructure
from ai.prompts import (
    PAR_STRUCTURING_PROMPT, TAGGING_PROMPT, COACHING_PROMPT, 
    MEMORY_SUMMARIZATION_PROMPT, COACHING_AGENT_PROMPT
)
from langchain.agents import create_tool_calling_agent, AgentExecutor
from ai.tools import search_personal_memory
from langchain_core.tools import tool

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

def get_coaching_chain():
    """
    Creates and returns the LangChain runnable for coaching insights.
    Expects 'first_name', 'problem', 'action', 'result', 'tags', 'user_profile' as input.
    Returns CoachingResult object.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Higher temperature for coaching for slightly more diverse feedback
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.7
    )

    # Bind structured output schema
    coaching_chain = COACHING_PROMPT | llm.with_structured_output(CoachingResult)
    
    return coaching_chain

def get_memory_summarization_chain():
    """
    Creates and returns the LangChain runnable for memory entry summarization.
    Expects 'text_chunk' as input.
    Returns MemoryEntryStructure object.
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Use Gemini 2.0 Flash for speed and extraction quality
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.0  # Cold for factual extraction
    )

    # Bind structured output schema
    summarization_chain = MEMORY_SUMMARIZATION_PROMPT | llm.with_structured_output(MemoryEntryStructure)
    
    return summarization_chain

def get_coaching_agent(user_id: str):
    """
    Creates and returns a tool-calling AgentExecutor for coaching.
    The agent can decide whether to use search_personal_memory tool.
    Returns AgentExecutor that behaves like a chain (invoke returns dict).
    """
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    # Use Gemini 2.0 Flash
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.7
    )

    # Create a wrapper tool with user_id pre-filled so the agent only passes the query
    @tool
    def search_memory(query: str, top_k: int = 3) -> str:
        """
        Search the user's personal memory database for relevant professional context.
        Use this when you need to recall specific skills, projects, or background.
        """
        # Call the original tool with the fixed user_id
        return search_personal_memory.invoke({
            "query": query, 
            "user_id": user_id, 
            "top_k": top_k
        })

    tools = [search_memory]

    # Initialize the tool-calling agent
    agent = create_tool_calling_agent(llm, tools, COACHING_AGENT_PROMPT)
    
    # Return as an Executor
    return AgentExecutor(
        agent=agent, 
        tools=tools, 
        verbose=True
    )
