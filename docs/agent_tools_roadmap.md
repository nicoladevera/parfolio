# Agent Tools Roadmap

> **Purpose**: Documentation for new LangChain tools to enhance the coaching agent's capabilities.
>
> **Status**: Planning phase - Not yet implemented
>
> **Last Updated**: 2026-01-17

---

## Overview

This document outlines nine new tools that will be added to the coaching agent to provide more intelligent, context-aware feedback. These tools fall into three categories:

1. **Internal Portfolio Tools**: Analyze the user's existing stories and competency coverage
2. **External Market Intelligence Tools**: Use Tavily web search to provide real-time, dynamic coaching insights
3. **Story Quality & Craft Tools**: Detect storytelling weaknesses, ensure PAR structure quality, and validate career stage alignment

---

## Internal Portfolio Tools

### Tool 1: `search_similar_stories`

**Purpose**: Find similar PAR stories the user has already created to prevent portfolio duplication and encourage diversity.

**Function Signature**:
```python
@tool
def search_similar_stories(query: str, user_id: str, top_k: int = 3) -> str:
    """
    Search for similar stories the user has already created.

    Use this when you suspect a new story might be duplicative or want to
    identify patterns in the user's portfolio.

    Args:
        query: Search terms describing the story topic (e.g., "database migration leadership")
        user_id: The user's unique identifier
        top_k: Number of similar stories to return (default: 3)

    Returns:
        Formatted list of similar stories with titles, tags, and key details
    """
```

**When Agent Calls This**:
- During coaching, if the new story feels generic or potentially duplicative
- To identify patterns in user's storytelling (e.g., "you have 3 migration stories")
- To suggest reframing to emphasize different competencies

**Example Scenario**:
```
User's new story: "Led a team to migrate our database to PostgreSQL..."

Agent thinks: "This sounds like a migration/technical leadership story.
Let me check if they already have similar stories."

Agent calls: search_similar_stories(query="database migration leadership", user_id=...)

Results:
- "Led MongoDB to DynamoDB migration" (Leadership, Execution)
- "Coordinated microservices database split" (Leadership, Technical)

Agent's coaching: "You already have strong database migration stories
showcasing Leadership. Consider reframing THIS story to emphasize the
Strategic Thinking aspect - why you chose PostgreSQL, how you evaluated
trade-offs, etc. This would diversify your portfolio."
```

**Implementation Notes**:
- Query Firestore `stories` collection filtered by `user_id`
- Use semantic search (possibly ChromaDB or simple keyword matching on title/PAR fields)
- Return story titles, tags, and brief PAR summaries
- Consider similarity threshold to avoid false positives

---

### Tool 2: `get_competency_coverage`

**Purpose**: Check how many stories the user has for specific competencies to help balance their interview prep portfolio.

**Function Signature**:
```python
@tool
def get_competency_coverage(user_id: str, competency: Optional[str] = None) -> str:
    """
    Analyze the user's story portfolio by competency coverage.

    Use this when a story could fit multiple competencies and you want to
    recommend the competency the user needs most.

    Args:
        user_id: The user's unique identifier
        competency: Specific competency to check (optional). If None, returns all competencies.

    Returns:
        Count of stories per competency, highlighting gaps and strengths
    """
```

**When Agent Calls This**:
- During tagging, when a story could fit multiple competencies
- To recommend which competency tag to emphasize
- To identify portfolio gaps and suggest new story topics

**Example Scenario**:
```
User's story: "Resolved conflict between eng and product teams about roadmap..."

Agent tags it as: Leadership, Communication, Conflict

Agent thinks: "This story shows multiple competencies. Which one does
the user need most in their portfolio?"

Agent calls: get_competency_coverage(user_id=..., competency="Conflict")
Result: User has 1 Conflict story

Agent calls: get_competency_coverage(user_id=..., competency="Leadership")
Result: User has 7 Leadership stories

Agent's coaching: "Great story! I tagged this as Leadership, Communication,
and Conflict. Since you already have 7 Leadership stories but only 1 Conflict
story, I recommend positioning this primarily as a Conflict Resolution example.
Emphasize how you mediated between teams rather than just the leadership aspect."
```

**Implementation Notes**:
- Query Firestore `stories` collection filtered by `user_id`
- Count stories grouped by `tags` array
- Return formatted breakdown (e.g., "Leadership: 7, Communication: 4, Conflict: 1, ...")
- Identify gaps (competencies with 0-1 stories)
- Consider user's target role when suggesting which gaps to fill

---

## External Market Intelligence Tools (Tavily Search)

### Tool 3: `get_company_interview_insights`

**Purpose**: Provide company-specific interview coaching based on the target company's values, leadership principles, and interview format.

**Function Signature**:
```python
@tool
def get_company_interview_insights(company: str, role: str, user_id: str) -> str:
    """
    Get real-time insights about a specific company's interview style and values.

    Use this when the user has specified a target company in their profile
    to tailor coaching to that company's specific expectations.

    Args:
        company: Target company name (e.g., "Amazon", "Google", "Stripe")
        role: Target role (e.g., "Product Manager", "Staff Engineer")
        user_id: The user's unique identifier (for context)

    Returns:
        Summary of company's interview priorities, leadership principles, and
        what they look for in behavioral stories
    """
```

**When Agent Calls This**:
- User has `target_companies` specified in their profile
- During coaching to align story framing with company values
- To suggest specific metrics or outcomes that resonate with the company

**Example Scenario**:
```
User profile: target_role = "Senior PM", target_companies = ["Amazon"]

User's story: "Result: Shipped feature in 2 weeks, beating deadline"

Agent thinks: "Let me see what Amazon actually values in PMs"

Agent calls: get_company_interview_insights(company="Amazon", role="PM", user_id=...)

Tavily search query: "Amazon product manager interview leadership principles 2026"

Results show: Amazon emphasizes "Customer Obsession" and "Bias for Action"

Agent's coaching: "Amazon PM interviews heavily emphasize 'Customer Obsession.'
Your Result focuses on speed ('2 weeks'), but doesn't mention customer impact.
Add: 'reducing customer support tickets by 40%' or 'improving user satisfaction
from 3.2 to 4.5.' This aligns with Amazon's leadership principles."
```

**Implementation Notes**:
- Requires adding `target_companies` field to user profile schema (see below)
- Use Tavily search API to fetch current company interview insights
- Search queries should include: company name, role, "interview", "leadership principles", current year
- Cache results per company/role combination (TTL: 30 days) to reduce API costs
- Parse and summarize key themes from search results

**Profile Schema Updates Required**:
```python
# Add to ProfileUpdateRequest and ProfileResponse models
current_company: Optional[str] = None
target_companies: Optional[List[str]] = None  # Multiple targets allowed
company_size: Optional[str] = None  # "startup" | "mid-size" | "enterprise"
```

---

### Tool 4: `get_role_interview_trends`

**Purpose**: Provide up-to-date insights on what specific roles are emphasizing in behavioral interviews.

**Function Signature**:
```python
@tool
def get_role_interview_trends(role: str, year: int = 2026) -> str:
    """
    Get current interview trends and priorities for a specific role.

    Use this to ensure coaching aligns with what's currently emphasized in
    interviews, not outdated advice.

    Args:
        role: Target role (e.g., "Staff Engineer", "Engineering Manager", "Product Manager")
        year: Current year for recency (default: 2026)

    Returns:
        Summary of current interview priorities, common questions, and focus areas
    """
```

**When Agent Calls This**:
- User has `target_role` in profile
- To ensure coaching reflects current hiring trends
- When suggesting how to reframe a story for a specific role level

**Example Scenario**:
```
User profile: target_role = "Staff Engineer", career_stage = "Senior → Staff"

User's story focuses heavily on coding implementation details

Agent thinks: "What are Staff Engineer interviews emphasizing right now?"

Agent calls: get_role_interview_trends(role="Staff Engineer", year=2026)

Tavily search query: "staff engineer behavioral interview questions 2026 trends"

Results: "Staff interviews now emphasize system design trade-offs, cross-team
influence, and technical strategy over hands-on coding"

Agent's coaching: "Your story focuses heavily on the code you wrote. Staff-level
interviews care more about influence and strategy. Reframe: emphasize how you
convinced 3 teams to adopt this approach, or how your technical decision reduced
future tech debt by $500K."
```

**Implementation Notes**:
- Use Tavily search with queries like: "{role} behavioral interview questions {year}"
- Cache results per role (TTL: 60 days) as trends change slowly
- Focus on: seniority expectations, common question themes, what differentiates levels
- Combine with user's `career_stage` for transition-specific advice

---

### Tool 5: `get_industry_context`

**Purpose**: Tailor coaching based on industry-specific vocabularies, priorities, and expectations.

**Function Signature**:
```python
@tool
def get_industry_context(industry: str, role: str) -> str:
    """
    Get industry-specific context and priorities for interview stories.

    Use this when the user has a target industry that has specific expectations
    (e.g., fintech emphasizes compliance, healthcare emphasizes privacy).

    Args:
        industry: Target industry (e.g., "fintech", "healthcare", "gaming", "e-commerce")
        role: Target role for industry-specific role expectations

    Returns:
        Summary of industry priorities, common terminology, and key themes
    """
```

**When Agent Calls This**:
- User has `target_industry` in profile (already exists in schema)
- To add industry-specific context to coaching
- To suggest industry-appropriate metrics and terminology

**Example Scenario**:
```
User profile: target_role = "Engineering Manager", target_industry = "Fintech"

Agent thinks: "What do fintech companies care about for EMs?"

Agent calls: get_industry_context(industry="fintech", role="Engineering Manager")

Tavily search query: "fintech engineering manager interview priorities compliance security"

Results: Fintech emphasizes regulatory compliance, security, incident response,
and financial system reliability

Agent's coaching: "In fintech, leadership stories should highlight risk mitigation
and compliance awareness. Add how you ensured PCI compliance during this migration,
or how you handled a security incident. Mention uptime/reliability metrics (e.g.,
99.99% SLA) if applicable."
```

**Implementation Notes**:
- Use user's `target_industry` from existing profile schema
- Tavily search queries: "{industry} {role} interview priorities"
- Cache per industry/role combination (TTL: 90 days)
- Focus on: industry-specific metrics, compliance/regulatory themes, common terminology

---

### Tool 6: `benchmark_impact_metrics`

**Purpose**: Help users understand if their quantitative results are impressive or need context.

**Function Signature**:
```python
@tool
def benchmark_impact_metrics(metric_type: str, value: str, context: str) -> str:
    """
    Benchmark a specific metric against industry standards.

    Use this when a user provides a quantitative result but you're unsure
    if it's impressive or needs additional context.

    Args:
        metric_type: Type of metric (e.g., "API latency improvement", "cost reduction", "user growth")
        value: The specific value (e.g., "15%", "$100K", "10,000 users")
        context: Additional context (e.g., "backend optimization", "SaaS startup")

    Returns:
        Industry benchmark comparison and coaching on how to frame the metric
    """
```

**When Agent Calls This**:
- User's Result section includes percentages or dollar amounts
- To validate if metrics are impressive or need reframing
- To suggest additional context that makes metrics more compelling

**Example Scenario**:
```
User's Result: "Improved API latency by 15%"

Agent thinks: "Is 15% latency improvement impressive?"

Agent calls: benchmark_impact_metrics(
    metric_type="API latency improvement",
    value="15%",
    context="backend API optimization"
)

Tavily search query: "typical API latency optimization results backend engineering benchmarks"

Results: Industry standard is 20-50% for optimization projects

Agent's coaching: "15% is a solid improvement, but typical backend optimizations
achieve 20-50%. Consider: (1) Explaining why 15% was technically challenging in
your specific context (e.g., 'while maintaining backwards compatibility' or
'without adding infrastructure costs'), or (2) If you achieved more in related
areas, include it (e.g., '15% latency + 30% throughput improvement')."
```

**Implementation Notes**:
- Tavily search queries: "{metric_type} industry benchmark {context}"
- Parse search results for typical ranges and standards
- Provide coaching on whether to add context, reframe, or celebrate the metric
- Cache common metric benchmarks (TTL: 180 days)

---

## Story Quality & Craft Tools

### Tool 7: `detect_weak_storytelling_patterns`

**Purpose**: Identify common storytelling mistakes that hurt interview performance.

**Function Signature**:
```python
@tool
def detect_weak_storytelling_patterns(story_text: dict, user_id: str) -> str:
    """
    Analyze a story for common storytelling weaknesses and antipatterns.

    Use this during coaching to catch articulation issues that reduce
    interview impact even when the underlying experience is strong.

    Args:
        story_text: Dict with 'problem', 'action', 'result' text
        user_id: The user's unique identifier (for context)

    Returns:
        List of detected weaknesses with specific improvement suggestions
    """
```

**When Agent Calls This**:
- During every coaching session as a quality check
- To provide specific, actionable writing feedback
- To catch patterns users don't notice themselves

**Example Scenario**:
```
User's story text:
Problem: "The system was slow and needed optimization."
Action: "We analyzed the bottlenecks and the database queries were optimized.
A caching layer was added and the team worked together to implement it."
Result: "The project was successful and things improved."

Agent calls: detect_weak_storytelling_patterns(story_text={...}, user_id=...)

Detected patterns:
1. PASSIVE_VOICE: "queries were optimized", "layer was added" (Action section)
2. VAGUE_RESULT: "successful", "things improved" (Result section)
3. WE_VS_I_IMBALANCE: "we" used 2x, "I" used 0x (Action section)
4. WEAK_VERBS: "worked together" instead of specific actions (Action section)

Agent's coaching:
"⚠️ Your story uses passive voice heavily: 'queries were optimized' and 'layer was added.'
Interviewers want to know YOUR specific role. Replace with: 'I optimized queries by...'
or 'I designed and implemented a caching layer...'

⚠️ Your Result is too vague: 'successful' and 'improved' don't tell the interviewer anything.
Add concrete metrics: How much faster did it get? What business impact?
Example: 'Reduced API latency from 2.3s to 400ms, enabling 50% more concurrent users.'"
```

**Implementation Notes**:
- Pattern detection categories:
  - **Passive voice**: Regex patterns for "was/were [verb]ed", "has been", "got [verb]ed"
  - **We vs. I ratio**: Count "we"/"our"/"us" vs "I"/"my"/"me" (flag if we:I ratio > 3:1)
  - **Vague results**: Check for weak words: "successful", "improved", "better", "good", "well" without specifics
  - **Weak verbs**: "helped", "contributed to", "involved in", "worked on", "participated"
  - **Missing specificity**: Result section <50 words or lacks numbers/metrics
  - **Excessive length**: Total story >600 words (too long for verbal delivery)
- Use NLP libraries (spaCy or simple regex) for pattern detection
- Return prioritized list (most important issues first)
- Provide specific rewrite suggestions, not just "this is wrong"

---

### Tool 8: `analyze_story_structure_quality`

**Purpose**: Validate that the PAR structure is clear, balanced, and logically coherent.

**Function Signature**:
```python
@tool
def analyze_story_structure_quality(story_text: dict, user_id: str) -> str:
    """
    Analyze the balance and completeness of PAR structure.

    Use this to ensure each section (Problem, Action, Result) is
    appropriately developed and logically connected.

    Args:
        story_text: Dict with 'problem', 'action', 'result' text
        user_id: The user's unique identifier (for context)

    Returns:
        Structural analysis with balance metrics and improvement suggestions
    """
```

**When Agent Calls This**:
- During every coaching session alongside weak pattern detection
- To catch structural issues (missing sections, imbalanced length, logical gaps)
- Before suggesting story is ready for interviews

**Example Scenario**:
```
User's story text:
Problem: "The API was slow." (15 words)
Action: "I profiled the code and found N+1 queries in the ORM layer. I refactored
to use batch loading, added Redis caching for frequently accessed data, implemented
query result pagination, and worked with the infrastructure team to optimize database
indexes. I also wrote comprehensive tests to ensure no regressions." (180 words)
Result: "It got faster." (10 words)

Agent calls: analyze_story_structure_quality(story_text={...}, user_id=...)

Analysis results:
- Problem: 15 words (7% of story)
- Action: 180 words (87% of story)
- Result: 10 words (5% of story)
- Total: 205 words

Issues detected:
1. RESULT_UNDERDEVELOPED: Result is only 5% of story (should be 25-35%)
2. PROBLEM_WEAK: Problem lacks context (Why was slowness a problem? Impact?)
3. ACTION_HEAVY: Action is 87% of story (technical details overwhelming)

Agent's coaching:
"📊 Structure Analysis:
- Problem: 15 words (7%) ⚠️ Too brief
- Action: 180 words (87%) ⚠️ Too detailed
- Result: 10 words (5%) ⚠️ Too vague

Your story is action-heavy but result-light. Interviewers care most about OUTCOMES.

Fix your Result:
'It got faster' → 'Reduced API latency from 3.2s to 240ms (92% improvement), handling
10x more requests during peak traffic. This unblocked the mobile team's launch and
reduced customer support tickets by 35%.'

Strengthen your Problem:
'The API was slow' → 'Our core API was averaging 3.2s response time, causing mobile
app timeouts and 50+ customer complaints daily. The mobile team couldn't launch their
new feature until we fixed this.'"
```

**Implementation Notes**:
- Word count analysis:
  - Calculate word count for each section (Problem, Action, Result)
  - Calculate percentages
  - Flag imbalances:
    - Problem <10% or >40%
    - Action <30% or >70%
    - Result <15% or >50%
- Completeness checks:
  - Any section <25 words? Flag as underdeveloped
  - Any section missing entirely? Critical error
  - Total story <100 words? Too short
  - Total story >600 words? Too long for interview
- Logical coherence (optional advanced):
  - Does Action address Problem? (keyword overlap check)
  - Does Result relate to Problem? (outcome keywords)
- Provide specific expansion suggestions:
  - "Your Result needs: business impact, metrics, stakeholder outcomes"
  - "Your Problem needs: context, urgency, why it mattered"
- Return severity levels: Critical (missing section), Warning (imbalanced), Info (minor)

---

### Tool 9: `validate_career_stage_alignment`

**Purpose**: Ensure story scope and framing match the expectations appropriate for the user's career stage.

**Function Signature**:
```python
@tool
def validate_career_stage_alignment(story_text: dict, user_id: str, career_stage: str) -> str:
    """
    Validate that story scope and impact align with user's career stage.

    Use this to catch overclaiming (early career claiming exec impact) or
    underselling (senior leaders being too tactical).

    Args:
        story_text: Dict with 'problem', 'action', 'result' text
        user_id: The user's unique identifier
        career_stage: User's career stage ("early-career" | "mid-career" | "senior-leadership")

    Returns:
        Career stage alignment analysis with specific reframing suggestions
    """
```

**When Agent Calls This**:
- During every coaching session (alongside other quality tools)
- When story scope seems mismatched with typical career stage expectations
- To provide stage-appropriate framing guidance

**Example Scenarios**:

**Scenario 1: Early Career Overclaiming**
```
User profile: career_stage = "early-career"

User's story:
Result: "My technical decision transformed the company's entire engineering culture
and became the foundation for our 5-year technical strategy."

Agent calls: validate_career_stage_alignment(story_text={...}, career_stage="early-career")

Detection:
- SCOPE_MISMATCH: Claims company-wide, multi-year strategic impact
- LANGUAGE_SIGNALS: "transformed entire culture", "5-year strategy"
- CREDIBILITY_ISSUE: Early career unlikely to drive org-wide strategy

Agent's coaching:
"⚠️ Your Result claims company-wide culture transformation and 5-year strategy ownership.
For early career roles, this scope sounds overclaimed and may hurt credibility.

Reframe to your actual sphere of influence:
- 'My approach was adopted by 2 other teams, influencing how 15 engineers handle similar problems'
- 'My manager presented this to leadership as a model for the broader organization'
- 'This became the template our team used for the next 3 projects'

This shows impact while staying credible for your career stage."
```

**Scenario 2: Senior Leadership Too Tactical**
```
User profile: career_stage = "senior-leadership"

User's story:
Action: "I wrote the Python script to parse the log files, debugged the null pointer
exception, and fixed the off-by-one error in the array indexing. I also updated the
unit tests and deployed the fix to production."

Agent calls: validate_career_stage_alignment(story_text={...}, career_stage="senior-leadership")

Detection:
- TACTICAL_FOCUS: Heavy emphasis on individual coding tasks
- MISSING_STRATEGIC: No mention of team direction, architectural decisions, or org impact
- LANGUAGE_SIGNALS: "I wrote", "I debugged", "I fixed" (IC-level language)

Agent's coaching:
"⚠️ Your story focuses heavily on hands-on coding tasks. Senior leadership interviews
emphasize strategic thinking, organizational impact, and influencing through others,
not individual execution.

Reframe to highlight leadership aspects:
- WHY was this problem important at a business/org level?
- Did you DECIDE to tackle this vs. delegate? Why?
- What PROCESS did you establish to prevent this class of issues?
- How did this UNBLOCK your team or influence the broader architecture?

Example reframe:
'When production logs revealed a critical data integrity issue affecting 20% of transactions,
I made the call to debug it personally to deeply understand the root cause. This informed
my decision to redesign our error handling framework, which I then had my team implement
across 15 services, reducing similar incidents by 80%.'"
```

**Scenario 3: Mid-Career Appropriate Scope**
```
User profile: career_stage = "mid-career"

User's story:
Action: "I led a cross-functional working group of 5 engineers to evaluate database options.
I drove the technical analysis, presented trade-offs to leadership, and coordinated the
migration plan with 3 dependent teams."

Result: "Migrated 8 microservices to Postgres, improving query performance by 60% and
reducing infrastructure costs by $40K/year. My migration playbook was adopted by 2 other
teams for their own database transitions."

Agent calls: validate_career_stage_alignment(story_text={...}, career_stage="mid-career")

Detection:
- SCOPE_APPROPRIATE: Cross-team influence (3-5 teams), tactical execution + strategic thinking
- IMPACT_LEVEL_MATCH: Team/department impact (not individual-only, not org-wide)
- LEADERSHIP_SIGNALS: Led working group, drove analysis, influenced other teams
- VALIDATION: No issues detected

Agent's coaching:
"✅ Your story scope aligns well with mid-career expectations. You show:
- Cross-team influence (coordinated with 3 teams)
- Both execution (led migration) and strategic thinking (evaluated options, presented trade-offs)
- Measurable impact with appropriate scope ($40K savings, 60% improvement)
- Influence beyond your immediate work (playbook adopted by 2 teams)

This demonstrates the balance of technical depth and leadership that mid-career interviews
look for."
```

**Implementation Notes**:

- **Career stage expectation patterns**:
  - **Early Career**:
    - Expected scope: Individual or small team (1-3 people)
    - Expected impact: Task/project level, building blocks
    - Red flags: "company-wide", "organizational strategy", "led 10+ people"
    - Good signals: "learned", "grew", "took initiative", "influenced my team"

  - **Mid-Career**:
    - Expected scope: Cross-team (3-8 people), department-level
    - Expected impact: Multiple projects, some influence beyond immediate team
    - Red flags: Only individual work OR claiming C-level strategic decisions
    - Good signals: "led cross-functional", "coordinated", "drove", "adopted by other teams"

  - **Senior Leadership**:
    - Expected scope: Organization-wide, multi-team, strategic
    - Expected impact: Long-term, architectural, cultural, business-level
    - Red flags: Heavy tactical focus, individual IC work as main story
    - Good signals: "defined strategy", "influenced org", "built the framework", "enabled the team"

- **Detection logic**:
  - **Keyword analysis**: Flag scope words (company-wide, team, individual) against career stage
  - **Pronoun usage**: "I did X" vs "I enabled the team to do X" vs "I defined the strategy"
  - **Impact metrics**: Individual (lines of code) vs team (delivery velocity) vs org (culture, strategy)
  - **Decision-making level**: Tactical (code choices) vs strategic (architecture, hiring, priorities)

- **Common mismatches to detect**:
  1. **Overclaiming** (early/mid claiming senior scope)
  2. **Underselling** (senior being too tactical)
  3. **Academic/intern stories** for senior roles (flag as outdated)
  4. **Generic language** that doesn't show stage-appropriate impact

- **Coaching recommendations**:
  - Provide before/after reframe examples specific to detected issues
  - Reference user's actual career stage in feedback
  - Explain WHY the mismatch hurts (credibility, missed opportunity to show right skills)
  - Suggest concrete expansions (add strategic context, quantify scope, show leadership)

---

## Implementation Priority

### Phase 1: Internal Portfolio Tools
1. ✅ `search_similar_stories` - Prevent duplication, high user value
2. ✅ `get_competency_coverage` - Portfolio balance, fits naturally into coaching

### Phase 2: Story Quality Tools (High Priority)
7. 🎯 `detect_weak_storytelling_patterns` - **Critical for MVP**, catches common interview failures
8. 🎯 `analyze_story_structure_quality` - **Critical for MVP**, ensures PAR balance

**Why Phase 2 is high priority**: Tools 1-2 help with portfolio strategy, but 7-8 help users tell stories well. These address the #1 reason good experiences become bad interviews - poor articulation. No schema changes needed, works with existing data.

### Phase 3: High-Value Search Tools
3. ✅ `get_company_interview_insights` - **Killer feature**, major differentiator
4. ✅ `get_role_interview_trends` - Keeps coaching current

### Phase 4: Nice-to-Have Search Tools
5. ⚠️ `get_industry_context` - Useful, but lower priority
6. ⚠️ `benchmark_impact_metrics` - Helpful for quantitative stories

---

## Technical Considerations

### Tavily Integration
- Use existing Tavily API setup from `backend/requirements.txt`
- Implement caching strategy to reduce API costs:
  - Company insights: 30-day TTL
  - Role trends: 60-day TTL
  - Industry context: 90-day TTL
  - Metric benchmarks: 180-day TTL
- Consider using Redis or simple file-based cache for MVP

### Agent Tool Selection Logic
The coaching agent should intelligently decide which tools to use based on:
- Available user profile data (if `target_companies` exists, use company insights)
- Story content (if quantitative metrics present, consider benchmarking)
- Portfolio state (always check competency coverage for multi-tag stories)

### Error Handling
- All search tools should gracefully degrade if Tavily API fails
- Return helpful fallback messages (e.g., "Unable to fetch company insights at this time")
- Don't block coaching generation if search tools fail

### Cost Management
- Set `top_k` limits on search results (e.g., max 3 results per query)
- Implement query result caching
- Monitor Tavily API usage and costs
- Consider rate limiting for expensive search operations

---

## Success Metrics

### Tool Usage Metrics
- How often does the agent call each tool?
- Which tools correlate with higher user satisfaction?
- Are users filling in `target_companies` field?

### User Impact Metrics
- Do users with balanced competency coverage get better interview outcomes?
- Does company-specific coaching improve story quality scores?
- Are users creating fewer duplicative stories?

### Technical Metrics
- Average Tavily API cost per coaching session
- Cache hit rates for search queries
- Tool execution latency

---

## Future Enhancements

### Advanced Tool Ideas
- `suggest_missing_stories`: Analyze portfolio gaps and suggest specific story prompts
- `compare_to_job_description`: Parse a job posting and recommend which stories to emphasize
- `interview_scenario_simulator`: Generate realistic follow-up questions for practice
- `story_export_optimizer`: Format stories specifically for resume, LinkedIn, or interview guides

### Multi-Tool Orchestration
- Chain tools together (e.g., competency coverage → role trends → targeted coaching)
- Build tool dependency graphs for complex coaching scenarios

---

## Questions & Decisions Needed

1. **Profile Schema**: Confirm addition of `target_companies` (List[str]) field
2. **Caching Strategy**: Redis vs. file-based vs. in-memory for MVP?
3. **Tavily Budget**: Set monthly API cost limit and usage alerts
4. **Tool Verbosity**: Should agent explain when/why it's calling tools to the user?

---

## References

- Existing tool: `search_personal_memory` in `backend/ai/tools.py`
- Agent implementation: `get_coaching_agent` in `backend/ai/chains.py`
- Tavily Python SDK: https://docs.tavily.com/docs/python-sdk
