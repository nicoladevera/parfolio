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
| **Tags** | Auto-assign 1–3 tags per story from 8–10 predefined competencies (e.g., Leadership, Communication, Impact, Problem-Solving, Collaboration, Strategic Thinking, Innovation, Adaptability) |
| **Coaching** | Generate 2–3 concise insights: strength, gap, and improvement suggestion |

### 3. Story Storage, Retrieval & Export
| Aspect | Details |
|--------|---------|
| **Storage** | Persistent Firebase store for all structured stories |
| **Retrieval** | Browse, search, and filter stories by competency tags |
| **Export** | One-click export to Notion, Google Sheets, or plain text |

---

## Data Schema (Firebase Firestore)

### Collection: `users`
```
users/{userId}
├── email: string
├── displayName: string
├── createdAt: timestamp
└── updatedAt: timestamp
```

### Collection: `stories`
```
stories/{storyId}
├── userId: string (FK → users)
├── title: string (auto-generated)
├── rawTranscript: string (original voice input)
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
| `POST` | `/auth/register` | Register new user (Firebase Auth) |
| `POST` | `/auth/login` | Login and return JWT token |
| `GET` | `/auth/me` | Get current user profile |

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
| `POST` | `/ai/tag` | Auto-tag story with behavioral competencies |
| `POST` | `/ai/coach` | Generate coaching insights for a story |
| `POST` | `/ai/process` | **All-in-one**: transcribe → structure → tag → coach |

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
| `POST` | `/export/notion` | Export stories to Notion |
| `POST` | `/export/sheets` | Export stories to Google Sheets |
| `GET` | `/export/download` | Download stories as JSON/CSV/TXT |

---

## Tech Stack Summary

| Layer | Technology |
|-------|------------|
| **Frontend** | Flutter (Web) |
| **Backend** | FastAPI (Python) |
| **Database** | Firebase Firestore |
| **Auth** | Firebase Authentication |
| **Speech-to-Text** | Google Cloud Speech-to-Text / Whisper |
| **AI/LLM** | OpenAI GPT-5.2 / Anthropic Claude Sonnet 4.5 or Opus 4.5 (for PAR structuring, tagging, coaching) |
| **Hosting** | Firebase Hosting (frontend) + Cloud Run / Railway (backend) |

---

## Request/Response Examples

### `POST /ai/process` — All-in-One Processing
**Request:**
```json
{
  "audio_url": "gs://bucket/audio/recording.wav"
}
```

**Response:**
```json
{
  "story_id": "abc123",
  "title": "Led Cross-Functional Team to Ship New Feature",
  "rawTranscript": "So there was this time when our team was really struggling...",
  "problem": "Our product team faced a critical deadline with unclear requirements and siloed communication across engineering, design, and marketing.",
  "action": "I initiated daily standups, created a shared Notion doc for requirements, and facilitated a workshop to align stakeholders on priorities.",
  "result": "We shipped the feature 2 days early, reduced miscommunication by 60%, and the process became our team's standard for cross-functional projects.",
  "tags": ["Leadership", "Communication", "Problem-Solving"],
  "coaching": {
    "strength": "Strong demonstration of initiative and stakeholder management.",
    "gap": "Consider adding specific metrics for the 'reduced miscommunication' claim.",
    "suggestion": "Include how you personally handled any conflicts or pushback during alignment."
  }
}
```

---

## Next Steps

1. [x] Set up Flutter project structure (Web)
2. [ ] Implement Firebase Auth flow
3. [ ] Build `/ai/process` endpoint with OpenAI/Gemini integration
4. [ ] Create Stories CRUD endpoints
5. [ ] Design and build Flutter UI for voice recording + story display
6. [ ] Implement export functionality
