
import os
import sys
from dotenv import load_dotenv

# Load environment variables from .env
# Explicitly finding the .env file in the same directory as this script
current_dir = os.path.dirname(os.path.abspath(__file__))
env_path = os.path.join(current_dir, ".env")
load_dotenv(dotenv_path=env_path)
# Verify API keys
google_api_key = os.getenv("GOOGLE_API_KEY")
tavily_api_key = os.getenv("TAVILY_API_KEY")

if not google_api_key:
    print("Error: GOOGLE_API_KEY not found in environment.")
    sys.exit(1)

if not tavily_api_key:
    print("Error: TAVILY_API_KEY not found in environment.")
    sys.exit(1)

try:
    from langchain_google_genai import ChatGoogleGenerativeAI
    from langchain_community.tools.tavily_search import TavilySearchResults
    from langchain.agents import create_tool_calling_agent
    from langchain.agents import AgentExecutor
    from langchain_core.prompts import ChatPromptTemplate
except ImportError as e:
    print(f"Error importing libraries: {e}")
    print("Please run: pip install -r requirements.txt")
    sys.exit(1)

def run_test():
    print("Initializing components...")
    
    # Initialize Tavily Search Tool
    tool = TavilySearchResults(max_results=2)
    tools = [tool]
    
    # Initialize Gemini 3.0 Pro
    # Note: Using 'gemini-pro' as a stable identifier, but attempting 'gemini-1.5-pro' or requested 'gemini-3.0-pro'
    # If standard 'gemini-pro' points to the latest, that's safest. 
    # For now, I will try the specific request 'gemini-3.0-pro' but fallback might be needed if it doesn't exist yet.
    # Given the date is 2026, 'gemini-3.0-pro' is likely valid.
    # Initialize Gemini 2.5 Pro
    # User requested Gemini 2.5 Pro for higher performance.
    llm = ChatGoogleGenerativeAI(
        model="gemini-2.5-pro",
        google_api_key=google_api_key
    )

    # Prompt Template
    prompt = ChatPromptTemplate.from_messages([
        ("system", "You are an NBA expert. ALWAYS use the search tool to find current trade details. "
                   "Your final response MUST be a clear, detailed summary and include the requested analysis. "
                   "Do not return an empty response."),
        ("placeholder", "{chat_history}"),
        ("human", "{input}"),
        ("placeholder", "{agent_scratchpad}"),
    ])
    
    # Create the Agent
    agent = create_tool_calling_agent(llm, tools, prompt)
    agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)
    
    print("Agent initialized. Running query...")
    query = (
        "Look up the recently completed Trae Young trade in the NBA. "
        "Provide the details: which teams were involved and which players were traded. "
        "Then, provide a nuanced two-paragraph perspective on the pros and cons of this trade for the teams involved."
    )
    
    try:
        response = agent_executor.invoke({"input": query})
        print("\n--- Response ---")
        print(response["output"])
        print("----------------")
    except Exception as e:
        print(f"Error running agent: {e}")

if __name__ == "__main__":
    run_test()
