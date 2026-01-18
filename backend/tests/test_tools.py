"""
Unit tests for AI coaching agent tools.

These tests verify the tool implementations in isolation,
mocking external dependencies (Firestore, Tavily, ChromaDB).
"""
import pytest
from unittest.mock import patch, MagicMock

# Import internal functions for direct testing
from ai.tools import (
    _detect_weak_storytelling_patterns,
    _analyze_story_structure_quality,
    _validate_career_stage_alignment,
    _get_competency_coverage_internal,
    _search_similar_stories_internal,
    _calculate_similarity,
    create_user_tools,
)
from ai.tool_cache import (
    cache_get,
    cache_set,
    cache_clear,
    _generate_cache_key,
)


# =============================================================================
# TEST DATA
# =============================================================================

SAMPLE_PROBLEM = """Our e-commerce platform was experiencing a 40% cart abandonment rate,
significantly higher than the industry average of 25%. This was costing us an estimated
$2M in lost revenue per quarter."""

SAMPLE_ACTION = """I led a cross-functional team of 5 engineers and 2 designers to
diagnose the issue. I conducted user research with 50 customers, analyzed funnel data,
and identified that the checkout process had 7 unnecessary steps. I then designed and
implemented a streamlined 3-step checkout flow, personally writing the frontend React
components and coordinating backend API changes."""

SAMPLE_RESULT = """The new checkout flow reduced cart abandonment from 40% to 22%,
below industry average. This translated to $1.2M in recovered revenue per quarter.
The project was completed 2 weeks ahead of schedule and received recognition from the CEO."""

WEAK_PROBLEM = "There was a problem with the system."

WEAK_ACTION = """We worked on fixing it. The team was assigned to improve things.
We were able to complete the work. Our team did a lot of work together."""

WEAK_RESULT = """Things improved significantly. We helped a lot.
The results were positive and made things better."""


# =============================================================================
# TOOL CACHE TESTS
# =============================================================================

class TestToolCache:
    """Tests for the in-memory cache module."""

    def setup_method(self):
        """Clear cache before each test."""
        cache_clear()

    def test_cache_key_generation(self):
        """Test that cache keys are generated consistently."""
        key1 = _generate_cache_key("prefix", query="test", param="value")
        key2 = _generate_cache_key("prefix", param="value", query="test")
        # Keys should be identical regardless of kwarg order
        assert key1 == key2

    def test_cache_key_different_prefix(self):
        """Test that different prefixes generate different keys."""
        key1 = _generate_cache_key("prefix1", query="test")
        key2 = _generate_cache_key("prefix2", query="test")
        assert key1 != key2

    def test_cache_set_and_get(self):
        """Test basic cache set and get operations."""
        cache_set("test_key", "test_value", ttl=3600)
        result = cache_get("test_key")
        assert result == "test_value"

    def test_cache_miss(self):
        """Test that cache returns None for missing keys."""
        result = cache_get("nonexistent_key")
        assert result is None

    def test_cache_expiry(self):
        """Test that expired entries return None."""
        cache_set("expiring_key", "value", ttl=0)  # Immediately expired
        result = cache_get("expiring_key")
        assert result is None

    def test_cache_clear(self):
        """Test that cache clear removes all entries."""
        cache_set("key1", "value1")
        cache_set("key2", "value2")
        cache_clear()
        assert cache_get("key1") is None
        assert cache_get("key2") is None


# =============================================================================
# STORY QUALITY TOOLS TESTS
# =============================================================================

class TestDetectWeakStorytellingPatterns:
    """Tests for the weak storytelling pattern detection tool."""

    def test_no_issues_detected(self):
        """Test that well-written story has no issues."""
        result = _detect_weak_storytelling_patterns(
            SAMPLE_PROBLEM, SAMPLE_ACTION, SAMPLE_RESULT
        )
        # Should have quantified results
        assert result["has_quantified_results"] is True
        # Quality score should be high
        assert result["quality_score"] >= 0.75

    def test_we_instead_of_i_detected(self):
        """Test detection of 'we' language in action section."""
        result = _detect_weak_storytelling_patterns(
            WEAK_PROBLEM, WEAK_ACTION, WEAK_RESULT
        )
        issue_types = [issue["type"] for issue in result["issues"]]
        assert "we_instead_of_i" in issue_types

    def test_vague_results_detected(self):
        """Test detection of vague results without metrics."""
        result = _detect_weak_storytelling_patterns(
            WEAK_PROBLEM, WEAK_ACTION, WEAK_RESULT
        )
        issue_types = [issue["type"] for issue in result["issues"]]
        assert "vague_results" in issue_types

    def test_no_quantified_results(self):
        """Test detection of missing quantified results."""
        result = _detect_weak_storytelling_patterns(
            WEAK_PROBLEM, WEAK_ACTION, WEAK_RESULT
        )
        assert result["has_quantified_results"] is False

    def test_quality_score_decreases_with_issues(self):
        """Test that quality score decreases with more issues."""
        good_result = _detect_weak_storytelling_patterns(
            SAMPLE_PROBLEM, SAMPLE_ACTION, SAMPLE_RESULT
        )
        bad_result = _detect_weak_storytelling_patterns(
            WEAK_PROBLEM, WEAK_ACTION, WEAK_RESULT
        )
        assert good_result["quality_score"] > bad_result["quality_score"]


class TestAnalyzeStoryStructureQuality:
    """Tests for the story structure analysis tool."""

    def test_word_counts_calculated(self):
        """Test that word counts are calculated correctly."""
        # Each repetition has 3 words: "word word word"
        result = _analyze_story_structure_quality(
            "one two three " * 2,  # 6 words
            "one two three " * 5,  # 15 words
            "one two three " * 3   # 9 words
        )
        assert result["word_counts"]["problem"] == 6
        assert result["word_counts"]["action"] == 15
        assert result["word_counts"]["result"] == 9
        assert result["word_counts"]["total"] == 30

    def test_percentages_calculated(self):
        """Test that percentages sum to 100%."""
        result = _analyze_story_structure_quality(
            SAMPLE_PROBLEM, SAMPLE_ACTION, SAMPLE_RESULT
        )
        total_pct = (
            result["percentages"]["problem"] +
            result["percentages"]["action"] +
            result["percentages"]["result"]
        )
        assert abs(total_pct - 100) < 0.1  # Allow small floating point error

    def test_too_short_story_flagged(self):
        """Test that very short stories are flagged."""
        result = _analyze_story_structure_quality(
            "Short problem.",
            "Short action.",
            "Short result."
        )
        issue_types = [issue["type"] for issue in result["issues"]]
        assert "too_short" in issue_types

    def test_balanced_story_has_high_score(self):
        """Test that well-balanced story has high balance score."""
        result = _analyze_story_structure_quality(
            SAMPLE_PROBLEM, SAMPLE_ACTION, SAMPLE_RESULT
        )
        assert result["balance_score"] >= 0.5


class TestValidateCareerStageAlignment:
    """Tests for career stage alignment validation."""

    def test_early_career_appropriate_signals(self):
        """Test detection of early career appropriate language."""
        early_career_story = """
        I learned a lot about project management in this role.
        I assisted my manager with the quarterly planning process.
        I contributed to the team's success by supporting documentation efforts.
        """
        result = _validate_career_stage_alignment(
            early_career_story, early_career_story, early_career_story,
            "early_career"
        )
        assert len(result["positive_signals"]) > 0
        assert "learned" in result["positive_signals"] or "assisted" in result["positive_signals"]

    def test_early_career_flags_overreach(self):
        """Test that early career flags inappropriate scope claims."""
        overreach_story = """
        I transformed the company's entire go-to-market strategy.
        I had full P&L responsibility for a $50M business unit.
        """
        result = _validate_career_stage_alignment(
            overreach_story, overreach_story, overreach_story,
            "early_career"
        )
        assert result["aligned"] is False
        assert len(result["flags"]) > 0

    def test_mid_career_appropriate_signals(self):
        """Test detection of mid career appropriate language."""
        mid_career_story = """
        I led a team of 8 engineers to deliver the new platform.
        I drove the technical architecture decisions.
        I owned the product roadmap for Q3.
        """
        result = _validate_career_stage_alignment(
            mid_career_story, mid_career_story, mid_career_story,
            "mid_career"
        )
        assert len(result["positive_signals"]) > 0

    def test_unknown_career_stage_passes(self):
        """Test that unknown career stage doesn't cause issues."""
        result = _validate_career_stage_alignment(
            SAMPLE_PROBLEM, SAMPLE_ACTION, SAMPLE_RESULT,
            "unknown_stage"
        )
        assert result["aligned"] is True


# =============================================================================
# PORTFOLIO TOOLS TESTS
# =============================================================================

class TestGetCompetencyCoverage:
    """Tests for competency coverage analysis."""

    @patch('ai.tools._get_user_stories')
    def test_calculates_tag_counts(self, mock_get_stories):
        """Test that tag counts are calculated correctly."""
        mock_get_stories.return_value = [
            {"story_id": "1", "tags": ["Leadership", "Impact"]},
            {"story_id": "2", "tags": ["Leadership", "Communication"]},
            {"story_id": "3", "tags": ["Impact"]},
        ]
        result = _get_competency_coverage_internal("test_user")
        assert result["tag_counts"]["Leadership"] == 2
        assert result["tag_counts"]["Impact"] == 2
        assert result["tag_counts"]["Communication"] == 1

    @patch('ai.tools._get_user_stories')
    def test_identifies_gaps(self, mock_get_stories):
        """Test that gaps are identified correctly."""
        mock_get_stories.return_value = [
            {"story_id": "1", "tags": ["Leadership"]},
        ]
        result = _get_competency_coverage_internal("test_user")
        # Should have 9 gaps (10 tags - 1 covered)
        assert len(result["gaps"]) == 9
        assert "Leadership" not in result["gaps"]

    @patch('ai.tools._get_user_stories')
    def test_coverage_score_calculation(self, mock_get_stories):
        """Test that coverage score is calculated correctly."""
        mock_get_stories.return_value = [
            {"story_id": "1", "tags": ["Leadership", "Impact", "Communication", "Execution", "Ownership"]},
        ]
        result = _get_competency_coverage_internal("test_user")
        # 5 out of 10 tags covered = 50%
        assert result["coverage_score"] == 0.5


class TestSearchSimilarStories:
    """Tests for similar story search."""

    def test_calculate_similarity(self):
        """Test text similarity calculation."""
        # Identical strings should have similarity of 1.0
        sim = _calculate_similarity("hello world", "hello world")
        assert sim == 1.0

        # Different strings should have lower similarity
        sim = _calculate_similarity("hello world", "goodbye moon")
        assert sim < 0.5

    @patch('ai.tools._get_user_stories')
    def test_tag_overlap_scoring(self, mock_get_stories):
        """Test that tag overlap affects similarity score."""
        mock_get_stories.return_value = [
            {"story_id": "1", "title": "Story A", "tags": ["Leadership", "Impact"],
             "problem": "", "action": "", "result": "", "status": "complete"},
            {"story_id": "2", "title": "Story B", "tags": ["Communication"],
             "problem": "", "action": "", "result": "", "status": "complete"},
        ]
        results = _search_similar_stories_internal(
            "test_user", tags=["Leadership", "Impact"]
        )
        # Story with matching tags should score higher
        assert results[0]["story_id"] == "1"

    @patch('ai.tools._get_user_stories')
    def test_returns_top_k_results(self, mock_get_stories):
        """Test that only top_k results are returned."""
        mock_get_stories.return_value = [
            {"story_id": str(i), "title": f"Story {i}", "tags": ["Leadership"],
             "problem": "", "action": "", "result": "", "status": "complete"}
            for i in range(10)
        ]
        results = _search_similar_stories_internal(
            "test_user", tags=["Leadership"], top_k=3
        )
        assert len(results) == 3


# =============================================================================
# FACTORY FUNCTION TESTS
# =============================================================================

class TestCreateUserTools:
    """Tests for the tool factory function."""

    def test_returns_ten_tools(self):
        """Test that factory returns all 10 tools."""
        tools = create_user_tools("test_user_id")
        assert len(tools) == 10

    def test_tool_names(self):
        """Test that all expected tools are present."""
        tools = create_user_tools("test_user_id")
        tool_names = [tool.name for tool in tools]

        expected_names = [
            "search_memory",
            "analyze_storytelling",
            "analyze_structure",
            "check_career_alignment",
            "get_portfolio_coverage",
            "find_similar_stories",
            "get_company_insights",
            "get_role_trends",
            "get_industry_info",
            "get_metric_benchmarks",
        ]

        for name in expected_names:
            assert name in tool_names, f"Missing tool: {name}"

    def test_tools_have_descriptions(self):
        """Test that all tools have descriptions."""
        tools = create_user_tools("test_user_id")
        for tool in tools:
            assert tool.description, f"Tool {tool.name} has no description"
            assert len(tool.description) > 10, f"Tool {tool.name} has too short description"


# =============================================================================
# MARKET INTELLIGENCE TOOLS TESTS (with mocked Tavily)
# =============================================================================

class TestMarketIntelligenceTools:
    """Tests for Tavily-based market intelligence tools."""

    @patch('ai.tools._get_tavily_tool')
    def test_company_insights_no_api_key(self, mock_get_tavily):
        """Test graceful handling when Tavily API not configured."""
        mock_get_tavily.return_value = None

        from ai.tools import get_company_interview_insights
        result = get_company_interview_insights.invoke({"company_name": "Google"})

        assert "not configured" in result.lower()

    @patch('ai.tools._get_tavily_tool')
    def test_role_trends_no_api_key(self, mock_get_tavily):
        """Test graceful handling when Tavily API not configured."""
        mock_get_tavily.return_value = None

        from ai.tools import get_role_interview_trends
        result = get_role_interview_trends.invoke({"role_title": "Product Manager"})

        assert "not configured" in result.lower()

    @patch('ai.tools.cached_tavily_search')
    @patch('ai.tools._get_tavily_tool')
    def test_company_insights_with_results(self, mock_get_tavily, mock_search):
        """Test company insights with mocked Tavily results."""
        mock_tavily = MagicMock()
        mock_get_tavily.return_value = mock_tavily
        mock_search.return_value = [
            {"title": "Google Interview Guide", "content": "Google values...", "url": "https://example.com"}
        ]

        from ai.tools import get_company_interview_insights
        result = get_company_interview_insights.invoke({"company_name": "Google"})

        assert "Google" in result
        assert "Interview Insights" in result


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
