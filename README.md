# PARfolio

> **Turn your work experiences into interview-ready stories.**

PARfolio is an AI-powered voice-first app that helps mid-career professionals capture, structure, and organize their work experiences into interview-ready PAR (Problem–Action–Result) narratives.

---

## The Problem

Mid-career professionals have valuable career stories in their heads, but those stories are messy, unstructured, and easy to forget—making interview preparation time-consuming, stressful, and inconsistent.

## The Solution

PARfolio listens to your rambling work stories, automatically structures them into a clear Problem–Action–Result format, categorizes them by behavioral competency, and stores them for easy retrieval.

---

## Key Features

- 🎙️ **Voice-First Recording**: Capture your work stories naturally through speech.
- 🤖 **AI Orchestrator**: Converts rambling speech into structured PAR (Problem-Action-Result) stories.
- 🧠 **Personal Memory**: Upload resumes, LinkedIn data, articles, and transcripts for AI-powered semantic search and personalized coaching.
- 🛠️ **Agentic Coaching**: AI agent autonomously retrieves user context from memory to personalize feedback.
- 🏷️ **Behavioral Tagging**: Auto-assigns competencies like Leadership, Communication, and Impact.
- ⚡ **All-in-One Pipeline**: Orchestrate the entire flow from raw audio/text to polished PAR story in a single API call.
- 📁 **Story Bank**: Manage, filter, and export your polished narratives.

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend (App)** | Flutter (Web) |
| **Marketing (Landing)** | HTML, CSS, JS (Vibrant/Playful Design) |
| **Backend** | FastAPI (Python) |
| **Database** | Firebase Firestore |
| **Auth** | Firebase Authentication |
| **Speech-to-Text** | OpenAI Whisper (Local) |
| **Vector DB** | ChromaDB (Local) |
| **AI/LLM** | Google Gemini 2.0/2.5 Pro (Primary) / OpenAI GPT-4o / Anthropic Claude 3.5 Sonnet |

---

## Project Structure

```
parfolio/
├── frontend/                 # Flutter Web App
│   ├── lib/                  # Dart source code
│   └── web/                  # Web entry point
├── backend/                  # FastAPI server
│   ├── main.py               # Entry point
│   ├── memory/               # Personal memory logic (ChromaDB, parsing, chunking)
│   ├── data/                 # Local data storage (ChromaDB persistence)
│   ├── ai/                   # LangChain logic (chains, schemas, prompts) & Whisper
│   ├── firebase_config.py    # Firebase initialization
│   ├── firebase_storage.py   # Firebase Storage utilities
│   ├── models/               # Pydantic data models
│   ├── routers/              # API route handlers
│   ├── dependencies/         # Auth & shared dependencies
│   ├── tests/                # Verification and unit tests
│   ├── requirements.txt      # Python dependencies
│   └── .env.example          # Environment template
├── marketing/                # Landing Page
│   ├── index.html            # Main entry point
│   ├── style.css             # Vibrant design styles
│   ├── script.js             # Interactions
│   └── assets/               # Images and mockups
├── docs/
│   ├── overview.md           # Product overview & pitch
│   ├── spec_sheet.md         # Technical spec (schema, endpoints)
│   └── design_system.md      # Design system documentation
└── README.md
```

---

## Getting Started

### Backend Setup

1. **System Dependencies**: Ensure `ffmpeg` is installed on your system (required for Whisper).
   - On Mac: `brew install ffmpeg`
   - Linux: `sudo apt install ffmpeg`

2. Navigate to the `backend` directory:
   ```bash
   cd backend
   ```

2. Set up a virtual environment:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   ```

3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   # Note: Includes ChromaDB for vector storage
   ```

4. Create a `.env` file based on `.env.example`

5. Start the server (ensure virtual environment is active):
   ```bash
   # If venv is activated (from step 2):
   uvicorn main:app --reload
   
   # Or run directly without activation:
   ./venv/bin/uvicorn main:app --reload
   ```

6. **AI Verification**: Run tests against AI and Stories endpoints:
   ```bash
   # Test AI Tagging
   python tests/test_ai_tagging.py
   
   # Test Stories CRUD (Standard pytest)
   export PYTHONPATH=$PYTHONPATH:.
   pytest tests/test_stories_unit.py
   ```

### App Setup (Flutter)

1. Navigate to the `frontend` directory:
   ```bash
   cd frontend
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   # For Chrome
   flutter run -d chrome
   ```

### Marketing Site Setup (Landing Page)

Simply open `marketing/index.html` in your browser. No build process required.

---

## Documentation

- [Product Overview](docs/overview.md) — User persona, problem, solution, and pitch
- [Technical Spec Sheet](docs/spec_sheet.md) — Data schema, API endpoints, and examples
- [Design System](docs/design_system.md) — Visual language, colors, and component specs
- [Backend AI Implementation Guide](docs/backend_ai_implementation_guide.md) — Strategy for building the AI pipeline
- [Frontend AI Implementation Guide](docs/frontend_ai_implementation_guide.md) — Phase-by-phase frontend implementation

---

## License

MIT
