# Agentic Coding Project

This repository contains the backend server for the Agentic Coding Project, built using FastAPI and the Firebase Admin SDK.

## Project Structure
- `backend/`: The main FastAPI server directory.
    - `main.py`: Entry point for the FastAPI application.
    - `firebase_config.py`: Centralized Firebase initialization.
    - `requirements.txt`: Python dependencies.
    - `.venv/`: Python virtual environment (ignored by Git).
    - `.env.example`: Template for environment variables.

## Getting Started
To get the backend running locally:

1.  Navigate to the `backend` directory.
2.  Set up a virtual environment: `python3 -m venv venv`.
3.  Activate the environment: `source venv/bin/activate`.
4.  Install dependencies: `pip install -r requirements.txt`.
5.  Create a `.env` file based on `.env.example`.
6.  Start the server: `uvicorn main:app --reload`.
