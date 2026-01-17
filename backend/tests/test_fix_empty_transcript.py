
import pytest
from fastapi.testclient import TestClient
from main import app
from unittest.mock import patch, MagicMock

client = TestClient(app)

def test_process_story_empty_transcript():
    """
    Test that /ai/process returns 400 when transcript is empty.
    """
    payload = {
        "raw_transcript": "",
        "story_id": "test-story-id",
        "user_id": "test-user-id"
    }
    
    # Mock authentication dependency if needed
    # (Assuming for now we can call it directly or mocks are handled in test_stories_unit.py style)
    # If there's auth middleware, we might need to mock get_current_user
    
    response = client.post("/ai/process", json=payload)
    
    assert response.status_code == 400
    # This hits an earlier validation check for strictly empty/missing inputs
    assert "Either audio_url or raw_transcript must be provided" in response.json()["detail"]

def test_process_story_whitespace_transcript():
    """
    Test that /ai/process returns 400 when transcript is just whitespace.
    """
    payload = {
        "raw_transcript": "   \n  ",
        "story_id": "test-story-id",
        "user_id": "test-user-id"
    }
    
    response = client.post("/ai/process", json=payload)
    
    assert response.status_code == 400
    assert "Transcription failed or audio was empty" in response.json()["detail"]
