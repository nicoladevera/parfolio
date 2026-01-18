# Backend AI Implementation Guide

> **Purpose**: High-level strategy for implementing PARfolio's AI processing features systematically.
> 
> **Status**: Complete. Phases 1-6 are implemented and verified.

---

## Overview

PARfolio's AI processing pipeline transforms voice recordings into structured PAR stories with tags and coaching insights. It also maintains a **Personal Memory Database** using vector storage for personalized context retrieval.

---

## Recommended Implementation Strategy: **Incremental Approach**

Build each AI processing step individually, then create the all-in-one orchestrator.

### Why Incremental?

1. **Complexity Management**: Each step has distinct technical challenges (audio handling, prompt engineering, classification logic)
2. **Easier Debugging**: Isolate issues to specific components
3. **Early Value Delivery**: Users get partial functionality while development continues
4. **Cost Optimization**: Understand API costs/latency per step before batching

---

## Implementation Order

### Phase 1: Core PAR Structuring ✅ (Complete)
**Endpoint**: `POST /ai/structure`

**Why first?** Test with hardcoded text transcripts to focus on prompt engineering without audio complexity.

**Tasks**:
- [x] Design prompt to convert rambling speech → Problem/Action/Result format
- [x] Generate concise, descriptive story titles
- [x] Handle edge cases (short stories, unclear narratives, missing PAR elements)
- [x] Test with sample transcripts

**Input**: `raw_transcript` (string)  
**Output**: `problem`, `action`, `result`, `title`

---

### Phase 2: Audio Transcription ✅ (Complete)
**Endpoint**: `POST /ai/transcribe`

**Tasks**:
- [x] Integrate Google Cloud Speech-to-Text or OpenAI Whisper (implemented Whisper Local)
- [x] Handle audio format conversion (Whisper handles many natively)
- [ ] Store audio files in Firebase Storage (at `gs://bucket/users/{userId}/audio/{storyId}.wav`)
- [ ] Store the audio URL in Firestore (`audioUrl`) as optional field
- [x] Save transcript text to Firebase Storage as `.txt` file (at `gs://bucket/users/{userId}/transcripts/{storyId}.txt`)
- [x] Store the transcript URL in Firestore (`rawTranscriptUrl`)
- [ ] Connect to `/ai/structure` for end-to-end flow

**Input**: `audio_url`, `story_id`, `user_id`
**Output**: `audio_url`, `raw_transcript`, `raw_transcript_url` (Firebase Storage URL to transcript text file)

---

### Phase 3: Behavioral Tagging ✅ (Complete)
**Endpoint**: `POST /ai/tag`

**Tasks**:
- Use the 10 predefined competency tags from the frontend: Leadership, Ownership, Impact, Communication, Conflict, Strategic Thinking, Execution, Adaptability, Failure, and Innovation.
- Design classification prompt using these specific tags.
- Ensure 1-3 tags per story
- Test with existing PAR stories from Phase 1

**Input**: `problem`, `action`, `result`  
**Output**: `tags` (array of strings)

---

### Phase 4: Coaching Insights ✅ (Complete)
**Endpoint**: `POST /ai/coach`

**Tasks**:
- [x] Generate strength, gap, and improvement suggestion
- [x] Ensure actionable, specific feedback with hybrid format (overview + detail)
- [x] Personalized with user's first name
- [x] Contextual awareness of tags and user profile
- [x] Test with diverse story types

**Input**: `problem`, `action`, `result`, `tags`  
**Output**: `coaching` object (`strength`, `gap`, `suggestion`)

---

### Phase 5: All-in-One Orchestrator ✅ (Complete)
**Endpoint**: `POST /ai/process`

**Tasks**:
- [x] Chain all four steps: transcribe → structure → tag → coach
- [x] Add error handling for partial failures
- [x] Optimize by running independent steps in parallel (Actually sequential for tag-aware coaching)
- [x] Return complete story object

**Input**: `audio_url`  
**Output**: Complete story with all fields

---

### Phase 6: Personal Memory Database ✅ (Complete)
**Base Path**: `/memory`

**Tasks**:
- [x] Implement holistic document processing (no chunking) for richer context
- [x] Implement AI-powered holistic summarization of entire documents
- [x] Implement AI-based source type auto-detection (resume, linkedin, article, transcript)
- [x] Build semantic search for personalized record retrieval

**Endpoints**:
- `POST /memory/upload`: Process and store context files
- `POST /memory/search`: Semantic search across user memory
- `GET /memory/entries/{user_id}`: List stored memory blocks
- `DELETE /memory/entries/{user_id}/{entry_id}`: Remove specific memory

---

### Phase 6b: Memory Tool Integration ✅ (Complete)
**Objective**: Transform the Personal Memory Database into a tool for the AI agent to enable autonomous personalization.

**Tasks**:
- [x] Create `ai/tools.py` with `search_personal_memory` LangChain tool
- [x] Implement tool-calling coaching agent in `ai/chains.py`
- [x] Update coaching prompts to guide agentic tool usage
- [x] Integrate agentic coaching into `/ai/coach` and `/ai/process` endpoints
- [x] Implement JSON response parsing and graceful fallbacks
- [x] **Forced Pre-Analysis**: Core quality tools (`analyze_storytelling`, `analyze_structure`) are pre-called before the agent runs, ensuring data-driven coaching regardless of agent tool-calling behavior
- [x] **Agent Reasoning Logging**: Agent outputs a `_reasoning` field explaining which findings informed each insight (logged to console, stripped before storage)

**Capabilities**:
- **Autonomous Retrieval**: The AI agent decides if context (resumes, past projects) is needed to improve coaching.
- **Improved Contextualization**: Feedback references specific skills and experiences found in the user's memory database.
- **Guaranteed Quality Analysis**: Pre-analysis always runs, providing storytelling pattern detection and structure balance scoring.

**Development Logging**:
The coaching pipeline outputs helpful debug information:
```
📊 Running pre-analysis tools...
   ✅ Pre-analysis complete
   - Raw transcript: 344 words
   - Structured PAR: 76 words
   - Storytelling issues: 2
   - Structure score: 0.76
   - Issues found:
     • [high] we_instead_of_i: Found 3 instances of 'we' language...

🤖 Agent context summary:
   - User: Daniela (mid_career at Zocdoc)
   - Target: Engineering Manager at ['GoodRx', 'Headway', 'Calm']

🧠 Invoking coaching agent...

🔧 TOOL CALL: get_company_insights  (if agent uses optional tools)
   Input: {"company": "GoodRx"}
   ✅ Result: GoodRx values...

📝 Agent output received (2326 chars)
💭 Agent reasoning: Used pre-analysis finding of vague results...

✅ Agent finished generating coaching insights
```

---

## Endpoint Architecture

### Individual Endpoints
**Purpose**: 
- User re-runs specific steps (e.g., "regenerate tags")
- Edit workflows (user edits PAR, then requests new coaching)
- Testing/debugging
- Cost control (skip coaching to save API costs)

### All-in-One Endpoint (`/ai/process`)
**Purpose**:
- Primary user flow: record → complete story in one call
- Simplifies frontend logic
- Better UX: single loading state
- Can optimize with parallel API calls

### Implementation Pattern
1. Build individual functions for each AI step
2. Create individual API endpoints that call these functions
3. Create `/ai/process` that orchestrates the individual functions
4. Frontend uses `/ai/process` for main recording flow
5. Frontend uses individual endpoints for "regenerate" features

---

## Technical Considerations

### AI Model Selection
- **Transcription**: OpenAI Whisper (Local)
- **Structuring/Tagging/Coaching/Memory**: Google Gemini 2.0/2.5 Pro
- **Vector Database**: ChromaDB (Local Persistence)

### Prompt Engineering Best Practices
- Use few-shot examples for PAR structuring
- Provide clear competency definitions for tagging
- Request specific, actionable coaching feedback
- Test prompts with diverse story types (technical, leadership, interpersonal)

### Error Handling
- Graceful degradation: if tagging fails, still return PAR structure.
- **UX Filtering**: AI-generated suggestions from the structuring phase (e.g., "Result lacks metrics") are filtered out of the `warnings` array to prevent cluttering the UI with technical-looking warnings for coaching issues. Only actual system failures (Transcription failed, Tagging failed) are surfaced as warnings.
- Retry logic for transient API failures.

### Cost Optimization
- Cache transcriptions (don't re-transcribe on re-structure)
- Consider batch processing for tag + coach (single LLM call)
- Monitor token usage per endpoint

### Storage Pattern for Audio & Transcripts

**Audio Files**:
- Store original recordings in Firebase Storage: `gs://bucket/users/{userId}/audio/{storyId}.wav` (or `.mp3`, `.m4a`)
- Store the URL in Firestore as `audioUrl` (optional field)
- Path convention: `gs://bucket/users/{userId}/audio/{storyId}.{extension}`

**Transcripts**:
- Store raw transcripts as text files in Firebase Storage (similar to profile photos)
- Path convention: `gs://bucket/users/{userId}/transcripts/{storyId}.txt`
- Store the Firebase Storage URL in Firestore as `rawTranscriptUrl`
- Benefits: GDPR-friendly (per-user folders), no Firestore document size limits, better performance
- The `/stories/{story_id}/transcript` endpoint can directly serve the file from Storage

### AI Features (Personalized Context)
The AI now supports personalized coaching by incorporating the user's first name and career context from their profile.

**Audio Retention Policy**:
- Implement auto-deletion of audio files after 30 days (or when story is marked "complete")
- Provide user control: "Delete original recording" button in UI
- Keep transcripts indefinitely (small file size, high utility)
- Rationale: Balances short-term verification needs with long-term storage costs and user privacy

---

## Testing Strategy

1. **Unit Tests**: Each AI function with mock responses
2. **Integration Tests**: End-to-end flow with real API calls
3. **Prompt Testing**: Diverse story samples (short, long, unclear, technical, behavioral)
4. **User Acceptance**: Test with real recordings from target users

---

## Future Enhancements

- **Parallel Processing**: Run tagging + coaching simultaneously in `/ai/process`
- **Streaming Responses**: Stream PAR structure as it's generated
- **User Feedback Loop**: Let users rate AI outputs to improve prompts
- **Custom Competencies**: Allow users to define their own tags
- **Multi-language Support**: Transcribe and structure in languages beyond English

---

## Testing Resources
- **Sample Transcripts**: Located in `backend/samples/transcripts/`. Use these for testing Phase 1 (Structuring) and Phase 3 (Tagging) to ensure the AI handles various narrative styles and behavioral signals correctly.
- **Sample Memory Files**: Located in `backend/samples/memory/`. Includes PDF resume, LinkedIn profile, Markdown, and DOCX files for testing Phase 6 (Personal Memory) processing and semantic retrieval.

---

## Reference

See `spec_sheet.md` for:
- Complete API endpoint specifications
- Request/response examples
- Data schema for stories
- Tech stack details
