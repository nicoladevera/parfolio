# PARfolio — Technical One-Pager

> **AI-powered voice-first app** that transforms unstructured spoken work stories into organized, interview-ready PAR narratives.

---

## MVP Features (Must Haves)

### 1. Voice → PAR Story Builder
| Aspect | Details |
|--------|---------|
| **Input** | Voice recording (speech-to-text) |
| **Processing** | AI structures rambling speech into Problem–Action–Result format |
| **Output** | Clean PAR narrative + auto-generated short, descriptive title |

### 2. Behavioral Tagging & Lightweight Coaching
| Aspect | Details |
|--------|---------|
| **Tags** | Auto-assign 1–3 tags per story from the 10 predefined competencies: Leadership, Ownership, Impact, Communication, Conflict, Strategic Thinking, Execution, Adaptability, Failure, and Innovation. |
| **Coaching** | Generate 2–3 concise insights: strength, gap, and improvement suggestion |

### 3. AI Orchestration & Personalization
| Aspect | Details |
|--------|---------|
| **AI Orchestrator** | Converts rambling speech into structured PAR (Problem-Action-Result) stories. |
| **Personal Memory** | Upload resumes, LinkedIn data, articles, and transcripts for AI-powered semantic search and personalized coaching using holistic summarization (supports native drag & drop on web/desktop). |
| **Agentic Coaching** | AI agent autonomously retrieves user context from memory to personalize feedback. |
| **Behavioral Tagging** | Auto-assigns competencies like Leadership, Communication, and Impact. |

### 4. Story Storage, Retrieval & Export
| Aspect | Details |
|--------|---------|
| **Storage** | Persistent Firebase store for all structured stories |
| **Retrieval** | Browse, search, and filter stories by competency tags |
| **Export (Bulk)** | Download collection of PAR-formatted stories for export to Notion, Google Sheets, or as plain text/JSON/CSV |
| **Export (Individual)** | Download raw transcript as a text file (**Implemented client-side for immediate access**) |

---

## Data Schema (Firebase Firestore)

### Collection: `users`
```
users/{userId}
├── email: string
├── firstName: string
├── lastName: string
├── displayName: string
├── currentRole: string (optional)
├── targetRole: string (optional)
├── currentIndustry: string (optional)
├── targetIndustry: string (optional)
├── careerStage: enum (optional) ["early_career", "mid_career", "senior_leadership"]
├── transitionTypes: array of enums (optional) ["same_role_new_company", "role_change", "industry_change", "company_type_shift"]
├── currentCompany: string (optional)
├── targetCompanies: array of strings (optional)
├── currentCompanySize: enum (optional) ["startup", "small", "medium", "enterprise"]
├── targetCompanySize: enum (optional) ["startup", "small", "medium", "enterprise"]
├── profilePhotoUrl: string (optional, path: users/{userId}/profile_photo.jpg)
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `stories`
```
stories/{storyId}
├── userId: string (FK → users)
├── title: string (auto-generated)
├── audioUrl: string (optional, Firebase Storage URL to original recording at users/{userId}/audio/{storyId}.{ext})
├── rawTranscriptUrl: string (Firebase Storage URL to transcript text file at users/{userId}/transcripts/{storyId}.txt)
├── problem: string (PAR - Problem)
├── action: string (PAR - Action)
├── result: string (PAR - Result)
├── tags: string[] (e.g., ["Leadership", "Communication"])
├── coaching: {
│   ├── strength: string
│   ├── gap: string
│   └── suggestion: string
│   }
├── status: string ("draft" | "complete")
├── createdAt: timestamp
└── updatedAt: timestamp

> **Note**: Audio files should be subject to a retention policy (e.g., auto-delete after 30 days or when story is marked complete) to manage storage costs. Users should have the option to manually delete recordings.
```

### Collection: `tags` (Optional — for predefined competencies)
```
tags/{tagId}
├── name: string (e.g., "Leadership")
├── description: string
└── category: string (e.g., "behavioral", "technical")
```

---

## API Endpoints (FastAPI)

### Authentication
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/auth/register` | Register new user (requires email, password, first_name, last_name) |
| `POST` | `/auth/login` | Login and return JWT token |
| `GET` | `/auth/me` | Get current user profile |

---

### Profile
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/profile` | Get current user's full profile |
| `PUT` | `/profile` | Update profile fields (current_role, target_role, etc.) |

---

### Stories CRUD
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/stories` | Create new story (accepts raw transcript) |
| `GET` | `/stories` | List all stories for current user |
| `GET` | `/stories/{story_id}` | Get single story by ID |
| `PUT` | `/stories/{story_id}` | Update story (edit PAR, tags, etc.) |
| `DELETE` | `/stories/{story_id}` | Delete a story |

---

### AI Processing
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/ai/transcribe` | Convert audio file → text transcript |
| `POST` | `/ai/structure` | Convert raw transcript → PAR format + title |
| `POST` | `/ai/tag` | Auto-tag story with behavioral competencies (1-3 tags, confidence, reasoning) |
| `POST` | `/ai/coach` | **Tool-calling agent**: Generates insights, autonomously retrieves context from Memory DB if needed |
| `POST` | `/ai/process` | **All-in-one orchestrator**: transcribe → structure → tag → coach (uses tool-calling agent for coaching). *Note: AI-generated structuring warnings are filtered out for UX clarity.* |

---

### Memory
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/memory/upload` | Upload context file (PDF/DOCX/TXT) → Parse → Summarize (Holistic) → Store in ChromaDB. AI automatically detects source type (resume, linkedin, article, transcript). |
| `POST` | `/memory/search` | Semantic search across user's personal memory entries |
| `GET` | `/memory/entries/{user_id}` | List all memory entries for a specific user |
| `DELETE` | `/memory/entries/{user_id}/{entry_id}` | Delete a specific memory entry |

---

### Tags
| Method | Endpoint | Description |
|--------|----------|-------------|
| `GET` | `/tags` | List all available competency tags |
| `GET` | `/stories?tag={tag_name}` | Filter stories by tag |

---

### Export
| Method | Endpoint | Description |
|--------|----------|-------------|
| `POST` | `/export/notion` | Export PAR-formatted stories to Notion |
| `POST` | `/export/sheets` | Export PAR-formatted stories to Google Sheets |
| `GET` | `/export/download` | Download collection of PAR-formatted stories as JSON/CSV/TXT |
| `GET` | `/stories/{story_id}/transcript` | Download raw transcript for a single story as a text file |

---

## Tech Stack Summary

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Web) |
| **Backend** | FastAPI (Python) |
| **Database** | Firebase Firestore |
| **Auth** | Firebase Authentication |
| **Speech-to-Text** | OpenAI Whisper (Local) |
| **AI/LLM** | Gemini 2.0 Flash (structuring, tagging) / Gemini 2.0 Pro Experimental (coaching) |
| **Hosting** | Hostinger (frontend) + Azure VM (backend) |

---

## Request/Response Examples

### `POST /ai/process` — All-in-One Processing
**Request:**
```json
{
  "audio_url": "gs://bucket/audio/recording.wav",
  "story_id": "abc123",
  "user_id": "uid_456",
  "raw_transcript": null
}
```

> [!TIP]
> You can provide `raw_transcript` instead of `audio_url` to skip the transcription step. If both are provided, `raw_transcript` takes precedence.

**Response:**
```json
{
  "story_id": "abc123",
  "title": "Led Cross-Functional Team to Ship New Feature",
  "rawTranscriptUrl": "https://firebasestorage.googleapis.com/v0/b/parfolio/o/transcripts%2Fabc123.txt?alt=media",
  "problem": "Our product team faced a critical deadline with unclear requirements and siloed communication across engineering, design, and marketing.",
  "action": "I initiated daily standups, created a shared Notion doc for requirements, and facilitated a workshop to align stakeholders on priorities.",
  "result": "We shipped the feature 2 days early, reduced miscommunication by 60%, and the process became our team's standard for cross-functional projects.",
  "tags": ["Leadership", "Communication", "Strategic Thinking"],
  "coaching": {
    "strength": {
       "overview": "Strong demonstration of initiative and stakeholder management.",
       "detail": "Your proactive stance in 'initiating daily standups' and 'creating a shared Notion doc' directly addressed the communication silos. This shows senior-level ownership and the ability to establish repeatable processes."
    },
    "gap": {
       "overview": "Consider adding specific metrics for the 'reduced miscommunication' claim.",
       "detail": "While you mentioned a 60% reduction, clarifying how this was measured (e.g., speed of delivery or team feedback) would make the result more undeniable during an interview."
    },
    "suggestion": {
       "overview": "Include how you personally handled any conflicts or pushback.",
       "detail": "Adding a sentence about navigating a specific disagreement during the workshops would strengthen the 'Leadership' and 'Conflict Resolution' signals in this story."
    }
  }
}
```

---

## Next Steps

1. [x] Set up Flutter project structure (Web)
2. [x] Implement Firebase Auth flow
3. [x] Build `/ai/structure` endpoint with Gemini integration (Phase 1)
4. [x] Build `/ai/transcribe` endpoint with Whisper Local (Phase 2)
5. [x] Create Stories CRUD endpoints
6. [x] Design and build Flutter UI for voice recording + story display
7. [x] Implement AI Service Integration (Frontend Phase 1) - Audio upload, AI processing, story creation
8. [x] Implement enhanced processing screen with stages (Frontend Phase 2)
9. [x] Implement story review/edit screen (Frontend Phase 3)
10. [x] Implement enhanced dashboard with full P/A/R write-up (Frontend Phase 4)
11. [x] Implement personal memory bank (Frontend Phase 5) - **Complete with AI source detection and expand/collapse UI**
12. [x] Implement export functionality (**Individual transcript export implemented**)

### `PUT /profile` — Update User Profile
**Request:**
```json
{
  "current_role": "Product Manager",
  "target_role": "Senior Product Manager",
  "current_industry": "Fintech",
  "target_industry": "Climate Tech",
  "career_stage": "mid_career",
  "transition_types": ["role_change", "industry_change"],
  "current_company": "Stripe",
  "target_companies": ["OpenAI", "Anthropic"],
  "current_company_size": "enterprise",
  "target_company_size": "medium",
  "profile_photo_url": "https://firebasestorage.googleapis.com/v0/b/..."
}
```

**Response:**
```json
{
  "user_id": "uid_123",
  "email": "user@example.com",
  "current_role": "Product Manager",
  "target_role": "Senior Product Manager",
  "current_industry": "Fintech",
  "target_industry": "Climate Tech",
  "career_stage": "mid_career",
  "transition_types": ["role_change", "industry_change"],
  "current_company": "Stripe",
  "target_companies": ["OpenAI", "Anthropic"],
  "current_company_size": "enterprise",
  "target_company_size": "medium",
  "profile_photo_url": "https://firebasestorage.googleapis.com/v0/b/..."
}
```
