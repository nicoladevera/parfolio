import pytest
from fastapi.testclient import TestClient
from main import app
from dependencies.auth_dependencies import get_current_user
from firebase_admin import firestore

client = TestClient(app)

# Mock user data
MOCK_USER = {
    "uid": "test_user_123",
    "email": "test@example.com"
}

# Dependency override
async def override_get_current_user():
    return MOCK_USER

app.dependency_overrides[get_current_user] = override_get_current_user

def test_create_and_get_story():
    # 1. Create a story
    payload = {
        "title": "Test Story Title",
        "problem": "Test Problem",
        "action": "Test Action",
        "result": "Test Result",
        "tags": ["Leadership", "Communication"],
        "raw_transcript": "This is a test transcript",
        "status": "draft",
        "coaching": {
            "strength": {"overview": "Good start", "detail": "You did well."},
            "gap": {"overview": "Could be better", "detail": "Try adding more detail."},
            "suggestion": {"overview": "Try this", "detail": "Add metrics."}
        }
    }
    
    response = client.post("/stories", json=payload)
    assert response.status_code == 201
    data = response.json()
    assert data["title"] == payload["title"]
    assert data["user_id"] == MOCK_USER["uid"]
    story_id = data["story_id"]
    
    # 2. Get the story
    response = client.get(f"/stories/{story_id}")
    assert response.status_code == 200
    assert response.json()["title"] == payload["title"]

def test_list_stories_filtering():
    # Create multiple stories with different statuses
    client.post("/stories", json={
        "title": "Draft Story",
        "problem": "P", "action": "A", "result": "R",
        "tags": ["Impact"],
        "raw_transcript": "T",
        "status": "draft"
    })
    
    client.post("/stories", json={
        "title": "Complete Story",
        "problem": "P", "action": "A", "result": "R",
        "tags": ["Leadership"],
        "raw_transcript": "T",
        "status": "complete"
    })
    
    # List all
    response = client.get("/stories")
    assert response.status_code == 200
    all_stories = response.json()
    assert len(all_stories) >= 2
    
    # Filter by status
    response = client.get("/stories?status=complete")
    assert response.status_code == 200
    complete_stories = response.json()
    assert all(s["status"] == "complete" for s in complete_stories)
    
    # Filter by tag
    response = client.get("/stories?tag=Leadership")
    assert response.status_code == 200
    leadership_stories = response.json()
    assert all("Leadership" in s["tags"] for s in leadership_stories)

def test_update_story():
    # Create a story
    response = client.post("/stories", json={
        "title": "Old Title",
        "problem": "P", "action": "A", "result": "R",
        "tags": ["Communication"],
        "raw_transcript": "T",
        "status": "draft"
    })
    story_id = response.json()["story_id"]
    
    # Update it
    update_payload = {
        "title": "New Title",
        "status": "complete"
    }
    response = client.put(f"/stories/{story_id}", json=update_payload)
    assert response.status_code == 200
    data = response.json()
    assert data["title"] == "New Title"
    assert data["status"] == "complete"
    # Verify non-updated field remains
    assert data["problem"] == "P"

def test_delete_story():
    # Create a story
    response = client.post("/stories", json={
        "title": "To be deleted",
        "problem": "P", "action": "A", "result": "R",
        "tags": ["Communication"],
        "raw_transcript": "T",
        "status": "draft"
    })
    story_id = response.json()["story_id"]
    
    # Delete it
    response = client.delete(f"/stories/{story_id}")
    assert response.status_code == 204
    
    # Verify it's gone
    response = client.get(f"/stories/{story_id}")
    assert response.status_code == 404

def test_unauthorized_access():
    # Create a story as user 1
    response = client.post("/stories", json={
        "title": "User 1 Story",
        "problem": "P", "action": "A", "result": "R",
        "tags": ["Communication"],
        "raw_transcript": "T",
        "status": "draft"
    })
    story_id = response.json()["story_id"]
    
    # Switch to user 2
    app.dependency_overrides[get_current_user] = lambda: {"uid": "other_user", "email": "other@example.com"}
    
    # Try to get user 1's story
    response = client.get(f"/stories/{story_id}")
    assert response.status_code == 403
    
    # Try to update user 1's story
    response = client.put(f"/stories/{story_id}", json={"title": "Hacked"})
    assert response.status_code == 403
    
    # Try to delete user 1's story
    response = client.delete(f"/stories/{story_id}")
    assert response.status_code == 403
    
    # Clean up override
    app.dependency_overrides[get_current_user] = override_get_current_user
