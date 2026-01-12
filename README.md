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

| Feature | Description |
|---------|-------------|
| 🎙️ **Voice → PAR Story Builder** | Speak your messy work story, get a clean PAR narrative with an auto-generated title |
| 🏷️ **Behavioral Tagging** | Auto-assign 1–3 competency tags (e.g., Leadership, Communication, Impact) |
| 👤 **User Profile** | Capture role, industry, and career stage to provide high-context AI coaching |
| 💡 **Lightweight Coaching** | Get 2–3 insights per story: strengths, gaps, and suggestions |
| 📚 **Story Portfolio** | Browse, search, and filter your stories by tag |
| 📤 **Export** | One-click export to Notion, Google Sheets, or plain text |

---

## Tech Stack

| Layer | Technology |
|-------|------------|
| **Frontend (App)** | Flutter (Web) |
| **Marketing (Landing)** | HTML, CSS, JS (Vibrant/Playful Design) |
| **Backend** | FastAPI (Python) |
| **Database** | Firebase Firestore |
| **Auth** | Firebase Authentication |
| **Speech-to-Text** | Google Cloud Speech-to-Text / Whisper |
| **AI/LLM** | OpenAI GPT-5.2 / Anthropic Claude Sonnet 4.5 or Opus 4.5 |

---

## Project Structure

```
parfolio/
├── frontend/                 # Flutter Web App
│   ├── lib/                  # Dart source code
│   └── web/                  # Web entry point
├── backend/                  # FastAPI server
│   ├── main.py               # Entry point
│   ├── firebase_config.py    # Firebase initialization
│   ├── requirements.txt      # Python dependencies
│   └── .env.example          # Environment template
├── marketing/                # Landing Page
│   ├── index.html            # Main entry point
│   ├── style.css             # Vibrant design styles
│   ├── script.js             # Interactions
│   └── assets/               # Images and mockups
├── docs/
│   ├── overview.md           # Product overview & pitch
│   └── spec_sheet.md         # Technical spec (schema, endpoints)
└── README.md
```

---

## Getting Started

### Backend Setup

1. Navigate to the `backend` directory:
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
   ```

4. Create a `.env` file based on `.env.example`

5. Start the server:
   ```bash
   uvicorn main:app --reload
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

---

## License

MIT
