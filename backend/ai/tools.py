"""
AI Coaching Agent Tools

This module provides tools for the coaching agent to analyze stories,
access user portfolio data, and gather market intelligence.
"""
import re
import os
from typing import List, Optional
from difflib import SequenceMatcher
from langchain_core.tools import tool, BaseTool
from memory.client import get_user_collection
from firebase_admin import firestore
from google.cloud.firestore_v1.base_query import FieldFilter

from ai.tool_cache import cached_tavily_search


# =============================================================================
# EXISTING TOOL: Personal Memory Search
# =============================================================================

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


# =============================================================================
# STORY QUALITY TOOLS (No External Dependencies)
# =============================================================================

# Common weak patterns for storytelling analysis
PASSIVE_VOICE_PATTERNS = [
    r"\bwas\s+\w+ed\b",
    r"\bwere\s+\w+ed\b",
    r"\bbeen\s+\w+ed\b",
    r"\bwas\s+being\s+\w+ed\b",
    r"\bis\s+\w+ed\b",
    r"\bare\s+\w+ed\b",
]

WE_INSTEAD_OF_I_PATTERNS = [
    r"\bwe\s+(?:did|made|created|built|developed|launched|delivered|achieved|completed|implemented)\b",
    r"\bour\s+team\s+(?:did|made|created|built|developed|launched|delivered|achieved|completed|implemented)\b",
    r"\bwe\s+were\s+able\s+to\b",
]

VAGUE_RESULTS_PATTERNS = [
    r"\bimproved\s+(?:things|it|the\s+situation)\b",
    r"\bmade\s+(?:things|it)\s+better\b",
    r"\bhelped\s+(?:a\s+lot|significantly|greatly)\b",
    r"\bincreased\s+(?:efficiency|productivity)\b(?!\s*by\s*\d)",  # Without quantification
    r"\breduced\s+(?:costs?|time)\b(?!\s*by\s*\d)",  # Without quantification
    r"\bsaved\s+(?:time|money)\b(?!\s*by\s*\d)",  # Without quantification
    r"\bgood\s+results\b",
    r"\bpositive\s+(?:impact|outcome|feedback)\b",
]

# Career stage scope keywords
CAREER_STAGE_KEYWORDS = {
    "early_career": {
        "appropriate": ["learned", "assisted", "supported", "contributed", "helped", "participated"],
        "flags": ["led the organization", "company-wide", "enterprise", "transformed the company", "P&L responsibility"],
    },
    "mid_career": {
        "appropriate": ["led", "managed", "drove", "owned", "spearheaded", "delivered", "team of"],
        "flags": ["just helped", "assisted my manager", "observed"],
    },
    "senior_leadership": {
        "appropriate": ["transformed", "built the organization", "P&L", "company-wide", "executive", "board", "C-suite", "multi-million", "strategic vision"],
        "flags": ["small task", "individual contributor", "my first project"],
    },
}


def _detect_weak_storytelling_patterns(problem: str, action: str, result: str) -> dict:
    """Internal implementation for detecting weak storytelling patterns."""
    full_text = f"{problem} {action} {result}".lower()
    issues = []

    # Check for passive voice
    passive_count = 0
    for pattern in PASSIVE_VOICE_PATTERNS:
        matches = re.findall(pattern, full_text, re.IGNORECASE)
        passive_count += len(matches)
    if passive_count > 2:
        issues.append({
            "type": "passive_voice",
            "severity": "medium" if passive_count <= 4 else "high",
            "message": f"Found {passive_count} instances of passive voice. Use active voice to emphasize your agency.",
            "suggestion": "Rewrite sentences to start with 'I' and use active verbs."
        })

    # Check for "we" instead of "I" in action section
    we_count = 0
    action_lower = action.lower()
    for pattern in WE_INSTEAD_OF_I_PATTERNS:
        matches = re.findall(pattern, action_lower, re.IGNORECASE)
        we_count += len(matches)
    if we_count > 0:
        issues.append({
            "type": "we_instead_of_i",
            "severity": "high",
            "message": f"Found {we_count} instances of 'we' language in your action section.",
            "suggestion": "Interviewers want to know YOUR specific contribution. Replace 'we' with 'I' and clarify your individual role."
        })

    # Check for vague results
    result_lower = result.lower()
    vague_count = 0
    for pattern in VAGUE_RESULTS_PATTERNS:
        matches = re.findall(pattern, result_lower, re.IGNORECASE)
        vague_count += len(matches)
    if vague_count > 0:
        issues.append({
            "type": "vague_results",
            "severity": "high",
            "message": "Your results section contains vague language without specific metrics.",
            "suggestion": "Add specific numbers: percentages, dollar amounts, time saved, or user counts."
        })

    # Check for quantified results (positive signal)
    has_numbers = bool(re.search(r"\b\d+[%$KkMm]?\b|\$\d+|\d+\s*(?:percent|%)", result))

    return {
        "issues": issues,
        "issue_count": len(issues),
        "has_quantified_results": has_numbers,
        "quality_score": max(0, 1.0 - (len(issues) * 0.25))  # Deduct 0.25 per issue
    }


@tool
def detect_weak_storytelling_patterns(problem: str, action: str, result: str) -> str:
    """
    Analyze a PAR story for common weak storytelling patterns.

    Use this tool to identify:
    - Passive voice usage that diminishes impact
    - "We" language instead of "I" that obscures individual contribution
    - Vague results without quantification

    Args:
        problem: The Problem section of the PAR story
        action: The Action section of the PAR story
        result: The Result section of the PAR story

    Returns:
        Analysis of weak patterns found with severity and suggestions
    """
    analysis = _detect_weak_storytelling_patterns(problem, action, result)

    if not analysis["issues"]:
        return "No major weak storytelling patterns detected. The story uses active voice and clear language."

    output_lines = [f"Found {analysis['issue_count']} storytelling issues (Quality Score: {analysis['quality_score']:.2f}):\n"]

    for issue in analysis["issues"]:
        output_lines.append(f"[{issue['severity'].upper()}] {issue['type']}")
        output_lines.append(f"  Issue: {issue['message']}")
        output_lines.append(f"  Fix: {issue['suggestion']}\n")

    if analysis["has_quantified_results"]:
        output_lines.append("✓ Good: Results section contains quantified metrics.")
    else:
        output_lines.append("⚠ Missing: No quantified metrics found in results.")

    return "\n".join(output_lines)


def _analyze_story_structure_quality(problem: str, action: str, result: str) -> dict:
    """Internal implementation for story structure analysis."""
    # Word counts
    problem_words = len(problem.split())
    action_words = len(action.split())
    result_words = len(result.split())
    total_words = problem_words + action_words + result_words

    # Calculate percentages
    problem_pct = (problem_words / total_words * 100) if total_words > 0 else 0
    action_pct = (action_words / total_words * 100) if total_words > 0 else 0
    result_pct = (result_words / total_words * 100) if total_words > 0 else 0

    # Ideal PAR balance: Problem ~20-25%, Action ~50-60%, Result ~20-25%
    issues = []

    # Check total length
    if total_words < 100:
        issues.append({
            "type": "too_short",
            "message": f"Story is only {total_words} words. Aim for 150-300 words for interview responses."
        })
    elif total_words > 400:
        issues.append({
            "type": "too_long",
            "message": f"Story is {total_words} words. Consider trimming to under 300 words for conciseness."
        })

    # Check Problem section
    if problem_pct < 10:
        issues.append({
            "type": "problem_too_short",
            "message": f"Problem is only {problem_pct:.0f}% of the story. Add more context about the challenge."
        })
    elif problem_pct > 40:
        issues.append({
            "type": "problem_too_long",
            "message": f"Problem is {problem_pct:.0f}% of the story. Trim context and focus on the core challenge."
        })

    # Check Action section
    if action_pct < 40:
        issues.append({
            "type": "action_too_short",
            "message": f"Action is only {action_pct:.0f}% of the story. This should be the longest section showing YOUR specific steps."
        })
    elif action_pct > 75:
        issues.append({
            "type": "action_too_long",
            "message": f"Action is {action_pct:.0f}% of the story. Ensure results get sufficient attention."
        })

    # Check Result section
    if result_pct < 15:
        issues.append({
            "type": "result_too_short",
            "message": f"Result is only {result_pct:.0f}% of the story. Expand on impact and outcomes."
        })

    # Calculate balance score (how close to ideal distribution)
    ideal_problem, ideal_action, ideal_result = 20, 55, 25
    balance_deviation = (
        abs(problem_pct - ideal_problem) +
        abs(action_pct - ideal_action) +
        abs(result_pct - ideal_result)
    ) / 3
    balance_score = max(0, 1.0 - (balance_deviation / 50))  # Normalize to 0-1

    return {
        "word_counts": {
            "problem": problem_words,
            "action": action_words,
            "result": result_words,
            "total": total_words
        },
        "percentages": {
            "problem": problem_pct,
            "action": action_pct,
            "result": result_pct
        },
        "issues": issues,
        "balance_score": balance_score
    }


@tool
def analyze_story_structure_quality(problem: str, action: str, result: str) -> str:
    """
    Analyze the structural quality and balance of a PAR story.

    Use this tool to evaluate:
    - Total story length (ideal: 150-300 words)
    - PAR section balance (ideal: Problem ~20%, Action ~55%, Result ~25%)
    - Section-specific length issues

    Args:
        problem: The Problem section of the PAR story
        action: The Action section of the PAR story
        result: The Result section of the PAR story

    Returns:
        Structural analysis with word counts, percentages, and balance recommendations
    """
    analysis = _analyze_story_structure_quality(problem, action, result)

    output_lines = [
        "=== Story Structure Analysis ===\n",
        f"Total Words: {analysis['word_counts']['total']}",
        f"Balance Score: {analysis['balance_score']:.2f}/1.00\n",
        "Section Breakdown:",
        f"  Problem: {analysis['word_counts']['problem']} words ({analysis['percentages']['problem']:.0f}%)",
        f"  Action:  {analysis['word_counts']['action']} words ({analysis['percentages']['action']:.0f}%)",
        f"  Result:  {analysis['word_counts']['result']} words ({analysis['percentages']['result']:.0f}%)\n",
    ]

    if analysis["issues"]:
        output_lines.append("Issues Found:")
        for issue in analysis["issues"]:
            output_lines.append(f"  • {issue['message']}")
    else:
        output_lines.append("✓ Story structure is well-balanced.")

    return "\n".join(output_lines)


def _validate_career_stage_alignment(problem: str, action: str, result: str, career_stage: str) -> dict:
    """Internal implementation for career stage alignment validation."""
    full_text = f"{problem} {action} {result}".lower()

    if career_stage not in CAREER_STAGE_KEYWORDS:
        return {
            "aligned": True,
            "career_stage": career_stage,
            "message": "Career stage not specified or unknown. Skipping alignment check.",
            "flags": [],
            "positive_signals": []
        }

    stage_config = CAREER_STAGE_KEYWORDS[career_stage]

    # Check for flags (inappropriate scope)
    flags = []
    for flag_phrase in stage_config["flags"]:
        if flag_phrase.lower() in full_text:
            flags.append(flag_phrase)

    # Check for positive signals (appropriate scope)
    positive_signals = []
    for appropriate_phrase in stage_config["appropriate"]:
        if appropriate_phrase.lower() in full_text:
            positive_signals.append(appropriate_phrase)

    aligned = len(flags) == 0

    return {
        "aligned": aligned,
        "career_stage": career_stage,
        "flags": flags,
        "positive_signals": positive_signals,
        "alignment_score": 1.0 if aligned else max(0, 1.0 - (len(flags) * 0.3))
    }


@tool
def validate_career_stage_alignment(problem: str, action: str, result: str, career_stage: str) -> str:
    """
    Validate that a story's scope aligns with the user's career stage.

    Use this tool to check:
    - Early career: Stories should focus on learning, assisting, and growing
    - Mid career: Stories should show leadership, ownership, and team impact
    - Senior leadership: Stories should demonstrate strategic, organization-wide impact

    Args:
        problem: The Problem section of the PAR story
        action: The Action section of the PAR story
        result: The Result section of the PAR story
        career_stage: The user's career stage (early_career, mid_career, senior_leadership)

    Returns:
        Assessment of whether story scope matches career stage expectations
    """
    analysis = _validate_career_stage_alignment(problem, action, result, career_stage)

    stage_display = career_stage.replace("_", " ").title()
    output_lines = [f"=== Career Stage Alignment Check ({stage_display}) ===\n"]

    if analysis["aligned"]:
        output_lines.append(f"✓ Story scope aligns well with {stage_display} expectations.")
    else:
        output_lines.append(f"⚠ Story scope may not align with {stage_display} expectations.\n")
        output_lines.append("Flagged phrases (may indicate misaligned scope):")
        for flag in analysis["flags"]:
            output_lines.append(f"  • '{flag}'")

    if analysis["positive_signals"]:
        output_lines.append(f"\nPositive signals for {stage_display}:")
        for signal in analysis["positive_signals"][:5]:  # Limit to 5
            output_lines.append(f"  ✓ '{signal}'")

    output_lines.append(f"\nAlignment Score: {analysis['alignment_score']:.2f}/1.00")

    return "\n".join(output_lines)


# =============================================================================
# INTERNAL PORTFOLIO TOOLS (Firestore Only)
# =============================================================================

def _get_user_stories(user_id: str) -> List[dict]:
    """Fetch all stories for a user from Firestore."""
    try:
        db = firestore.client()
        query = db.collection("stories").where(filter=FieldFilter("user_id", "==", user_id))
        docs = query.stream()

        stories = []
        for doc in docs:
            data = doc.to_dict()
            stories.append({
                "story_id": data.get("story_id"),
                "title": data.get("title", "Untitled"),
                "problem": data.get("problem", ""),
                "action": data.get("action", ""),
                "result": data.get("result", ""),
                "tags": data.get("tags", []),
                "status": data.get("status", "draft")
            })
        return stories
    except Exception as e:
        return []


def _get_competency_coverage_internal(user_id: str) -> dict:
    """Internal implementation for competency coverage analysis."""
    stories = _get_user_stories(user_id)

    # All available competency tags
    all_tags = [
        "Leadership", "Ownership", "Impact", "Communication", "Conflict",
        "Strategic Thinking", "Execution", "Adaptability", "Failure", "Innovation"
    ]

    # Count stories per tag
    tag_counts = {tag: 0 for tag in all_tags}
    for story in stories:
        for tag in story.get("tags", []):
            if tag in tag_counts:
                tag_counts[tag] += 1

    # Identify gaps (0 stories) and weak areas (1 story)
    gaps = [tag for tag, count in tag_counts.items() if count == 0]
    weak = [tag for tag, count in tag_counts.items() if count == 1]
    strong = [tag for tag, count in tag_counts.items() if count >= 3]

    return {
        "total_stories": len(stories),
        "tag_counts": tag_counts,
        "gaps": gaps,
        "weak_coverage": weak,
        "strong_coverage": strong,
        "coverage_score": (len(all_tags) - len(gaps)) / len(all_tags)
    }


@tool
def get_competency_coverage(user_id: str) -> str:
    """
    Analyze the user's portfolio for competency tag coverage.

    Use this tool to identify:
    - Which competencies have strong coverage (3+ stories)
    - Which competencies are weak (only 1 story)
    - Which competencies have no coverage (gaps to fill)

    Args:
        user_id: The unique identifier for the user

    Returns:
        Coverage analysis showing story counts per competency tag
    """
    analysis = _get_competency_coverage_internal(user_id)

    output_lines = [
        "=== Competency Coverage Analysis ===\n",
        f"Total Stories: {analysis['total_stories']}",
        f"Coverage Score: {analysis['coverage_score']:.0%}\n",
        "Stories per Competency:"
    ]

    # Sort by count descending
    sorted_tags = sorted(analysis["tag_counts"].items(), key=lambda x: x[1], reverse=True)
    for tag, count in sorted_tags:
        indicator = "✓" if count >= 2 else "○" if count == 1 else "✗"
        output_lines.append(f"  {indicator} {tag}: {count} stories")

    if analysis["gaps"]:
        output_lines.append(f"\n⚠ Coverage Gaps ({len(analysis['gaps'])} competencies with no stories):")
        for gap in analysis["gaps"]:
            output_lines.append(f"  • {gap}")

    if analysis["strong_coverage"]:
        output_lines.append(f"\n✓ Strong Coverage ({len(analysis['strong_coverage'])} competencies with 3+ stories):")
        for strong in analysis["strong_coverage"]:
            output_lines.append(f"  • {strong}")

    return "\n".join(output_lines)


def _calculate_similarity(text1: str, text2: str) -> float:
    """Calculate text similarity using SequenceMatcher."""
    return SequenceMatcher(None, text1.lower(), text2.lower()).ratio()


def _search_similar_stories_internal(
    user_id: str,
    title: Optional[str] = None,
    tags: Optional[List[str]] = None,
    content: Optional[str] = None,
    top_k: int = 3
) -> List[dict]:
    """Internal implementation for similar story search."""
    stories = _get_user_stories(user_id)

    if not stories:
        return []

    scored_stories = []

    for story in stories:
        score = 0.0

        # Tag overlap (40% weight)
        if tags:
            story_tags = set(story.get("tags", []))
            query_tags = set(tags)
            if story_tags and query_tags:
                overlap = len(story_tags & query_tags) / len(query_tags)
                score += overlap * 0.4

        # Title similarity (20% weight)
        if title and story.get("title"):
            title_sim = _calculate_similarity(title, story["title"])
            score += title_sim * 0.2

        # Content similarity (40% weight)
        if content:
            story_content = f"{story.get('problem', '')} {story.get('action', '')} {story.get('result', '')}"
            if story_content.strip():
                content_sim = _calculate_similarity(content, story_content)
                score += content_sim * 0.4

        if score > 0:
            scored_stories.append({
                **story,
                "similarity_score": score
            })

    # Sort by score and return top_k
    scored_stories.sort(key=lambda x: x["similarity_score"], reverse=True)
    return scored_stories[:top_k]


@tool
def search_similar_stories(
    user_id: str,
    title: Optional[str] = None,
    tags: Optional[str] = None,
    content: Optional[str] = None,
    top_k: int = 3
) -> str:
    """
    Search for similar stories in the user's portfolio.

    Use this tool to find:
    - Stories with overlapping competency tags
    - Stories with similar titles or content
    - Related experiences for comparison or pattern identification

    Args:
        user_id: The unique identifier for the user
        title: Optional title to match against (partial match)
        tags: Optional comma-separated tags to match (e.g., "Leadership,Impact")
        content: Optional content to match against (problem/action/result text)
        top_k: Number of results to return (default: 3)

    Returns:
        List of similar stories with similarity scores
    """
    # Parse tags string to list
    tags_list = [t.strip() for t in tags.split(",")] if tags else None

    results = _search_similar_stories_internal(
        user_id=user_id,
        title=title,
        tags=tags_list,
        content=content,
        top_k=top_k
    )

    if not results:
        return "No similar stories found in the portfolio."

    output_lines = [f"=== Found {len(results)} Similar Stories ===\n"]

    for i, story in enumerate(results, 1):
        output_lines.append(f"{i}. {story['title']} (Score: {story['similarity_score']:.2f})")
        output_lines.append(f"   Tags: {', '.join(story['tags']) if story['tags'] else 'None'}")
        output_lines.append(f"   Status: {story['status']}")
        # Truncate problem for preview
        problem_preview = story['problem'][:100] + "..." if len(story['problem']) > 100 else story['problem']
        output_lines.append(f"   Problem: {problem_preview}\n")

    return "\n".join(output_lines)


# =============================================================================
# MARKET INTELLIGENCE TOOLS (Tavily)
# =============================================================================

def _get_tavily_tool():
    """Get Tavily search tool instance."""
    try:
        from langchain_community.tools.tavily_search import TavilySearchResults
        api_key = os.getenv("TAVILY_API_KEY")
        if not api_key:
            return None
        return TavilySearchResults(max_results=3)
    except Exception:
        return None


def _format_tavily_results(results) -> str:
    """Format Tavily results into readable string."""
    if not results:
        return "No results found."

    output_lines = []
    for i, result in enumerate(results, 1):
        if isinstance(result, dict):
            title = result.get("title", "Untitled")
            content = result.get("content", "No content")
            url = result.get("url", "")
            output_lines.append(f"{i}. {title}")
            output_lines.append(f"   {content[:300]}...")
            if url:
                output_lines.append(f"   Source: {url}\n")
        else:
            output_lines.append(f"{i}. {str(result)[:300]}\n")

    return "\n".join(output_lines)


@tool
def get_company_interview_insights(company_name: str) -> str:
    """
    Get insights about a company's interview culture and process.

    Use this tool to find:
    - Company-specific interview format and stages
    - Common interview questions and focus areas
    - Company culture and values emphasized in hiring

    Args:
        company_name: Name of the target company (e.g., "Google", "Meta", "Stripe")

    Returns:
        Insights about the company's interview process and culture
    """
    tavily = _get_tavily_tool()
    if not tavily:
        return f"Unable to search for {company_name} interview insights. Tavily API not configured."

    query = f"{company_name} interview process culture behavioral questions what interviewers look for"

    def search_func(q):
        return tavily.invoke(q)

    try:
        results = cached_tavily_search(query, search_func)
        formatted = _format_tavily_results(results)
        return f"=== Interview Insights for {company_name} ===\n\n{formatted}"
    except Exception as e:
        return f"Error searching for {company_name} insights: {str(e)}"


@tool
def get_role_interview_trends(role_title: str) -> str:
    """
    Get current interview trends and expectations for a specific role.

    Use this tool to understand:
    - Key competencies expected for the role
    - Common behavioral interview questions
    - Technical vs behavioral interview balance
    - What top candidates demonstrate

    Args:
        role_title: The target role (e.g., "Product Manager", "Software Engineer", "Data Scientist")

    Returns:
        Current trends and expectations for interviewing for this role
    """
    tavily = _get_tavily_tool()
    if not tavily:
        return f"Unable to search for {role_title} interview trends. Tavily API not configured."

    query = f"{role_title} behavioral interview questions 2024 2025 what interviewers look for competencies"

    def search_func(q):
        return tavily.invoke(q)

    try:
        results = cached_tavily_search(query, search_func)
        formatted = _format_tavily_results(results)
        return f"=== Interview Trends for {role_title} ===\n\n{formatted}"
    except Exception as e:
        return f"Error searching for {role_title} trends: {str(e)}"


@tool
def get_industry_context(industry: str) -> str:
    """
    Get current context and trends for a specific industry.

    Use this tool to understand:
    - Current challenges and opportunities in the industry
    - Key skills and competencies valued in the industry
    - Industry-specific terminology and priorities

    Args:
        industry: The target industry (e.g., "fintech", "healthcare tech", "e-commerce")

    Returns:
        Current context and trends for the industry
    """
    tavily = _get_tavily_tool()
    if not tavily:
        return f"Unable to search for {industry} context. Tavily API not configured."

    query = f"{industry} industry trends 2024 2025 hiring priorities key skills challenges"

    def search_func(q):
        return tavily.invoke(q)

    try:
        results = cached_tavily_search(query, search_func)
        formatted = _format_tavily_results(results)
        return f"=== Industry Context for {industry} ===\n\n{formatted}"
    except Exception as e:
        return f"Error searching for {industry} context: {str(e)}"


@tool
def benchmark_impact_metrics(metric_type: str, industry: Optional[str] = None, role: Optional[str] = None) -> str:
    """
    Get benchmark data for impact metrics to help quantify results.

    Use this tool to find:
    - Industry benchmarks for specific metrics (revenue, conversion, efficiency)
    - What "good" looks like for different types of improvements
    - Context to help users quantify vague results

    Args:
        metric_type: The type of metric to benchmark (e.g., "conversion rate", "revenue growth", "cost reduction", "user engagement")
        industry: Optional industry context for more relevant benchmarks
        role: Optional role context for more relevant benchmarks

    Returns:
        Benchmark data and context for the specified metric
    """
    tavily = _get_tavily_tool()
    if not tavily:
        return f"Unable to search for {metric_type} benchmarks. Tavily API not configured."

    # Build search query
    query_parts = [metric_type, "benchmark", "industry average", "what is good"]
    if industry:
        query_parts.append(industry)
    if role:
        query_parts.append(role)
    query = " ".join(query_parts)

    def search_func(q):
        return tavily.invoke(q)

    try:
        results = cached_tavily_search(query, search_func)
        formatted = _format_tavily_results(results)

        context = f"for {industry}" if industry else ""
        if role:
            context = f"{context} ({role})" if context else f"for {role}"

        return f"=== Benchmarks for {metric_type} {context} ===\n\n{formatted}"
    except Exception as e:
        return f"Error searching for {metric_type} benchmarks: {str(e)}"


# =============================================================================
# TOOL FACTORY FUNCTION
# =============================================================================

def create_user_tools(user_id: str) -> List[BaseTool]:
    """
    Create all coaching tools with user_id pre-filled via closures.

    This factory function returns tools that the coaching agent can use
    without needing to pass user_id as a parameter each time.

    Args:
        user_id: The unique identifier for the user

    Returns:
        List of tools ready to be used by the coaching agent
    """

    @tool
    def search_memory(query: str, top_k: int = 3) -> str:
        """
        Search the user's personal memory database for relevant professional context.
        Use this when you need to recall specific skills, projects, or background.
        """
        return search_personal_memory.invoke({
            "query": query,
            "user_id": user_id,
            "top_k": top_k
        })

    @tool
    def analyze_storytelling(problem: str, action: str, result: str) -> str:
        """
        Analyze a PAR story for weak storytelling patterns like passive voice,
        'we' instead of 'I', and vague results without metrics.
        """
        return detect_weak_storytelling_patterns.invoke({
            "problem": problem,
            "action": action,
            "result": result
        })

    @tool
    def analyze_structure(problem: str, action: str, result: str) -> str:
        """
        Analyze the structural quality and balance of a PAR story.
        Checks word counts, section percentages, and optimal PAR balance.
        """
        return analyze_story_structure_quality.invoke({
            "problem": problem,
            "action": action,
            "result": result
        })

    @tool
    def check_career_alignment(problem: str, action: str, result: str, career_stage: str) -> str:
        """
        Validate that a story's scope aligns with the user's career stage.
        Career stages: early_career, mid_career, senior_leadership.
        """
        return validate_career_stage_alignment.invoke({
            "problem": problem,
            "action": action,
            "result": result,
            "career_stage": career_stage
        })

    @tool
    def get_portfolio_coverage() -> str:
        """
        Analyze competency tag coverage across the user's story portfolio.
        Shows which competencies have strong coverage vs gaps.
        """
        return get_competency_coverage.invoke({"user_id": user_id})

    @tool
    def find_similar_stories(
        title: Optional[str] = None,
        tags: Optional[str] = None,
        content: Optional[str] = None,
        top_k: int = 3
    ) -> str:
        """
        Search for similar stories in the user's portfolio.
        Use to find related experiences or identify patterns.
        Tags should be comma-separated (e.g., "Leadership,Impact").
        """
        return search_similar_stories.invoke({
            "user_id": user_id,
            "title": title,
            "tags": tags,
            "content": content,
            "top_k": top_k
        })

    @tool
    def get_company_insights(company_name: str) -> str:
        """
        Get insights about a company's interview culture and process.
        Use when the user is targeting a specific company.
        """
        return get_company_interview_insights.invoke({"company_name": company_name})

    @tool
    def get_role_trends(role_title: str) -> str:
        """
        Get current interview trends and expectations for a specific role.
        Use to understand what competencies are valued for the target role.
        """
        return get_role_interview_trends.invoke({"role_title": role_title})

    @tool
    def get_industry_info(industry: str) -> str:
        """
        Get current context and trends for a specific industry.
        Use to understand industry-specific terminology and priorities.
        """
        return get_industry_context.invoke({"industry": industry})

    @tool
    def get_metric_benchmarks(
        metric_type: str,
        industry: Optional[str] = None,
        role: Optional[str] = None
    ) -> str:
        """
        Get benchmark data for impact metrics to help quantify results.
        Useful for helping users add specific numbers to vague results.
        """
        return benchmark_impact_metrics.invoke({
            "metric_type": metric_type,
            "industry": industry,
            "role": role
        })

    return [
        search_memory,
        analyze_storytelling,
        analyze_structure,
        check_career_alignment,
        get_portfolio_coverage,
        find_similar_stories,
        get_company_insights,
        get_role_trends,
        get_industry_info,
        get_metric_benchmarks,
    ]
