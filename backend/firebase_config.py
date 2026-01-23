import os
import json
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv(override=True)

def initialize_firebase():
    """Initializes the Firebase Admin SDK."""
    # Check if a Firebase app has already been initialized
    if not firebase_admin._apps:
        try:
            # Try to load from environment variable first (for production)
            firebase_creds_json = os.getenv("FIREBASE_CREDENTIALS_JSON")

            if firebase_creds_json:
                # Parse JSON from environment variable
                cred_dict = json.loads(firebase_creds_json)
                cred = credentials.Certificate(cred_dict)
                print("Firebase credentials loaded from FIREBASE_CREDENTIALS_JSON environment variable")
            else:
                # Fall back to file path (for local development)
                cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH", "./firebase-credentials.json")

                if os.path.exists(cred_path):
                    cred = credentials.Certificate(cred_path)
                    print(f"Firebase credentials loaded from file: {cred_path}")
                else:
                    print(f"Warning: Firebase credentials file not found at {cred_path}. Firebase functionality will be limited.")
                    return None

            bucket_name = os.getenv("FIREBASE_STORAGE_BUCKET")

            firebase_admin.initialize_app(cred, {
                'storageBucket': bucket_name
            })
            print(f"Firebase Admin SDK initialized successfully with bucket: {bucket_name}")

        except Exception as e:
            print(f"Error initializing Firebase Admin SDK: {e}")
            return None

    return firebase_admin.get_app() if firebase_admin._apps else None

# Initialize once when the module is imported
firebase_app = initialize_firebase()

def get_user_profile(user_id: str) -> dict:
    """Fetch user profile from Firestore for coaching context."""
    db = firestore.client()
    doc = db.collection("users").document(user_id).get()
    if doc.exists:
        return doc.to_dict()
    return {}
