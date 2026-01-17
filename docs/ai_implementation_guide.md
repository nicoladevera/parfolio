# AI Implementation Guide

> **Purpose**: High-level strategy for implementing PARfolio's AI processing features systematically.
> 
> **Status**: In Progress. Phase 1 (Core PAR Structuring) is complete. Reference this document alongside `spec_sheet.md` for remaining phases.

---

## Overview

PARfolio's AI processing pipeline transforms voice recordings into structured PAR stories with tags and coaching insights. This guide outlines the recommended implementation approach.

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
- [ ] Store audio files in Firebase Storage (e.g., `gs://bucket/{userId}/audio/{storyId}.wav`)
- [ ] Store the audio URL in Firestore (`audioUrl`) as optional field
- [x] Save transcript text to Firebase Storage as `.txt` file (at `{userId}/transcripts/{storyId}.txt`)
- [x] Store the transcript URL in Firestore (`rawTranscriptUrl`)
- [ ] Connect to `/ai/structure` for end-to-end flow

**Input**: `audio_url`, `story_id`, `user_id`
**Output**: `audio_url`, `raw_transcript`, `raw_transcript_url` (Firebase Storage URL to transcript text file)

---

### Phase 3: Behavioral Tagging
**Endpoint**: `POST /ai/tag`

**Tasks**:
- Use the 10 predefined competency tags from the frontend: Leadership, Ownership, Impact, Communication, Conflict, Strategic Thinking, Execution, Adaptability, Failure, and Innovation.
- Design classification prompt using these specific tags.
- Ensure 1-3 tags per story
- Test with existing PAR stories from Phase 1

**Input**: `problem`, `action`, `result`  
**Output**: `tags` (array of strings)

---

### Phase 4: Coaching Insights
**Endpoint**: `POST /ai/coach`

**Tasks**:
- Generate strength, gap, and improvement suggestion
- Ensure actionable, specific feedback
- Test with diverse story types

**Input**: `problem`, `action`, `result`, `tags`  
**Output**: `coaching` object (`strength`, `gap`, `suggestion`)

---

### Phase 5: All-in-One Orchestrator
**Endpoint**: `POST /ai/process`

**Tasks**:
- Chain all four steps: transcribe → structure → tag → coach
- Add error handling for partial failures
- Optimize by running independent steps in parallel (e.g., tag + coach can run simultaneously)
- Return complete story object

**Input**: `audio_url`  
**Output**: Complete story with all fields

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
- **Transcription**: Google Cloud Speech-to-Text or OpenAI Whisper
- **Structuring/Tagging/Coaching**: Google Gemini 2.0/2.5 Pro (Primary) or OpenAI GPT-4/Anthropic Claude

### Prompt Engineering Best Practices
- Use few-shot examples for PAR structuring
- Provide clear competency definitions for tagging
- Request specific, actionable coaching feedback
- Test prompts with diverse story types (technical, leadership, interpersonal)

### Error Handling
- Graceful degradation: if tagging fails, still return PAR structure
- Retry logic for transient API failures
- User-friendly error messages

### Cost Optimization
- Cache transcriptions (don't re-transcribe on re-structure)
- Consider batch processing for tag + coach (single LLM call)
- Monitor token usage per endpoint

### Storage Pattern for Audio & Transcripts

**Audio Files**:
- Store original recordings in Firebase Storage: `gs://bucket/audio/{storyId}.wav` (or `.mp3`, `.m4a`)
- Store the URL in Firestore as `audioUrl` (optional field)
- Path convention: `gs://bucket/audio/{storyId}.{extension}`

**Transcripts**:
- Store raw transcripts as text files in Firebase Storage (similar to profile photos)
- Path convention: `gs://bucket/{userId}/transcripts/{storyId}.txt`
- Store the Firebase Storage URL in Firestore as `rawTranscriptUrl`
- Benefits: GDPR-friendly (per-user folders), no Firestore document size limits, better performance
- The `/stories/{story_id}/transcript` endpoint can directly serve the file from Storage

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
- **Sample Transcripts**: Located in `backend/samples/`. Use these for testing Phase 1 (Structuring) and Phase 3 (Tagging) to ensure the AI handles various narrative styles and behavioral signals correctly.

---

## Reference

See `spec_sheet.md` for:
- Complete API endpoint specifications
- Request/response examples
- Data schema for stories
- Tech stack details
