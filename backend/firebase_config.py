import os
import firebase_admin
from firebase_admin import credentials, firestore
from dotenv import load_dotenv

# Load environment variables from .env
load_dotenv(override=True)

def initialize_firebase():
    """Initializes the Firebase Admin SDK."""
    cred_path = os.getenv("FIREBASE_CREDENTIALS_PATH")
    
    if not cred_path:
        # Default to the example path if not set, or you could keep it required
        cred_path = "./firebase-credentials.json"
        print(f"Warning: FIREBASE_CREDENTIALS_PATH not set, defaulting to {cred_path}")

    # Check if a Firebase app has already been initialized
    if not firebase_admin._apps:
        try:
            if os.path.exists(cred_path):
                cred = credentials.Certificate(cred_path)
                bucket_name = os.getenv("FIREBASE_STORAGE_BUCKET")
                
                firebase_admin.initialize_app(cred, {
                    'storageBucket': bucket_name
                })
                print(f"Firebase Admin SDK initialized successfully with bucket: {bucket_name}")
            else:
                print(f"Warning: Firebase credentials file not found at {cred_path}. Firebase functionality will be limited.")
        except Exception as e:
            print(f"Error initializing Firebase Admin SDK: {e}")
    
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
