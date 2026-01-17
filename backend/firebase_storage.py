import os
import tempfile
from firebase_admin import storage
from firebase_config import firebase_app

def get_bucket():
    """Returns the default Firebase Storage bucket."""
    return storage.bucket()

def download_audio_from_storage(storage_url: str) -> str:
    """
    Downloads an audio file from Firebase Storage to a temporary local file.
    Supports both gs:// and https:// URLs.
    Returns the path to the temporary file.
    """
    bucket = get_bucket()
    
    # Extract blob path from URL
    if storage_url.startswith("gs://"):
        # gs://bucket-name/path/to/file
        blob_path = "/".join(storage_url.split("/")[3:])
    elif "firebasestorage.googleapis.com" in storage_url:
        # https://firebasestorage.googleapis.com/v0/b/bucket-name/o/path%2Fto%2Ffile?alt=media
        blob_path = storage_url.split("/o/")[1].split("?")[0].replace("%2F", "/")
    else:
        raise ValueError(f"Unsupported storage URL format: {storage_url}")

    blob = bucket.blob(blob_path)
    
    # Create a temporary file
    _, temp_path = tempfile.mkstemp(suffix=os.path.splitext(blob_path)[1])
    
    # Download to temp file
    blob.download_to_filename(temp_path)
    print(f"Downloaded {storage_url} to {temp_path}")
    
    return temp_path

def upload_transcript_to_storage(user_id: str, story_id: str, transcript_text: str) -> str:
    """
    Uploads transcript text to Firebase Storage at {user_id}/transcripts/{story_id}.txt.
    Returns the public URL of the uploaded file.
    """
    bucket = get_bucket()
    blob_path = f"{user_id}/transcripts/{story_id}.txt"
    blob = bucket.blob(blob_path)
    
    # Upload text
    blob.upload_from_string(transcript_text, content_type="text/plain")
    
    # Make it public and return URL (or signed URL depending on app config)
    # For simplicity in this MVP, we might just return the media link if bucket permissions allow
    # or use make_public() if that's the desired flow.
    # blob.make_public()
    
    return blob.public_url if blob.public_url else f"https://storage.googleapis.com/{bucket.name}/{blob_path}"
