import os
from langchain_google_genai import ChatGoogleGenerativeAI
from ai.schemas import PARStructure, TagResponse, CoachingResult, MemoryEntryStructure
from ai.prompts import (
    PAR_STRUCTURING_PROMPT, TAGGING_PROMPT, COACHING_PROMPT, 
    MEMORY_SUMMARIZATION_PROMPT, COACHING_AGENT_PROMPT
)
from langchain.agents import create_tool_calling_agent, AgentExecutor
from ai.tools import create_user_tools

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
        temperature=0.7, # Slight creativity for titles/phrasing, but grounded
        verbose=True
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
        temperature=0.3, # Lower temperature for classification (more deterministic)
        verbose=True
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
        temperature=0.7,
        verbose=True
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
        temperature=0.0, # Cold for factual extraction
        verbose=True
    )

    # Bind structured output schema
    summarization_chain = MEMORY_SUMMARIZATION_PROMPT | llm.with_structured_output(MemoryEntryStructure)
    
    return summarization_chain

def get_coaching_agent(user_id: str):
    """
    Creates and returns a tool-calling AgentExecutor for coaching.

    The agent has access to 10 tools:
    - search_memory: Search user's personal memory database
    - analyze_storytelling: Detect weak patterns (passive voice, "we" language, vague results)
    - analyze_structure: Check word counts and PAR balance
    - check_career_alignment: Validate story scope matches career stage
    - get_portfolio_coverage: Analyze competency tag coverage
    - find_similar_stories: Find related stories in portfolio
    - get_company_insights: Get company interview culture info (Tavily)
    - get_role_trends: Get role interview trends (Tavily)
    - get_industry_info: Get industry context (Tavily)
    - get_metric_benchmarks: Get benchmark data for metrics (Tavily)

    Returns AgentExecutor that behaves like a chain (invoke returns dict).
    """
    from langchain.callbacks.base import BaseCallbackHandler
    from typing import Any, Dict, List
    
    class AgentThoughtLogger(BaseCallbackHandler):
        """Lightweight callback handler that logs tool usage without overwhelming output."""
        
        def on_tool_start(self, serialized: Dict[str, Any], input_str: str, **kwargs) -> None:
            tool_name = serialized.get("name", "unknown")
            print(f"\n🔧 TOOL CALL: {tool_name}")
            input_preview = input_str[:150] + "..." if len(str(input_str)) > 150 else input_str
            print(f"   Input: {input_preview}")
        
        def on_tool_end(self, output: str, **kwargs) -> None:
            output_preview = output[:200] + "..." if len(output) > 200 else output
            print(f"   ✅ Result: {output_preview}")
        
        def on_tool_error(self, error: Exception, **kwargs) -> None:
            print(f"   ❌ Error: {str(error)}")
        
        def on_agent_finish(self, finish, **kwargs) -> None:
            print("\n✅ Agent finished generating coaching insights")
    
    api_key = os.getenv("GOOGLE_API_KEY")
    if not api_key:
        raise ValueError("GOOGLE_API_KEY environment variable not set")

    llm = ChatGoogleGenerativeAI(
        model="gemini-2.0-flash",
        google_api_key=api_key,
        temperature=0.5,
        verbose=False  # Cleaner logs
    )

    tools = create_user_tools(user_id)

    agent = create_tool_calling_agent(llm, tools, COACHING_AGENT_PROMPT)

    thought_logger = AgentThoughtLogger()

    return AgentExecutor(
        agent=agent,
        tools=tools,
        verbose=False,  # Disable default verbose output
        callbacks=[thought_logger]
    )
