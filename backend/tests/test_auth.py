import pytest
from fastapi.testclient import TestClient
from unittest.mock import patch, MagicMock
from main import app
from datetime import datetime

client = TestClient(app)

# Create a real-ish looking exception for the mock
class MockEmailAlreadyExistsError(Exception):
    pass

@patch("routers.auth_router.auth")
@patch("routers.auth_router.db")
def test_register_with_current_role(mock_db, mock_auth):
    # Setup mocks
    mock_auth.EmailAlreadyExistsError = MockEmailAlreadyExistsError
    
    mock_user_record = MagicMock()
    mock_user_record.uid = "test_uid_123"
    mock_auth.create_user.return_value = mock_user_record
    
    # Registration payload
    payload = {
        "email": "test@example.com",
        "password": "password123",
        "first_name": "John",
        "last_name": "Doe",
        "current_role": "Software Engineer"
    }
    
    # Call registration endpoint
    response = client.post("/auth/register", json=payload)
    
    # Assertions
    if response.status_code != 201:
        print(f"Error: {response.json()}")
        
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == payload["email"]
    assert data["current_role"] == payload["current_role"]
    assert data["user_id"] == "test_uid_123"
    
    # Verify Firestore call
    mock_db.collection.assert_called_with("users")
    mock_db.collection().document.assert_called_with("test_uid_123")
    mock_db.collection().document().set.assert_called_once()

@patch("routers.auth_router.auth")
@patch("routers.auth_router.db")
def test_register_without_current_role(mock_db, mock_auth):
    # Setup mocks
    mock_auth.EmailAlreadyExistsError = MockEmailAlreadyExistsError
    
    mock_user_record = MagicMock()
    mock_user_record.uid = "test_uid_456"
    mock_auth.create_user.return_value = mock_user_record
    
    # Registration payload (no current_role)
    payload = {
        "email": "jane@example.com",
        "password": "password123",
        "first_name": "Jane",
        "last_name": "Smith"
    }
    
    # Call registration endpoint
    response = client.post("/auth/register", json=payload)
    
    # Assertions
    assert response.status_code == 201
    data = response.json()
    assert data["current_role"] == None
