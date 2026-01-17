import os
import sys
import uuid
from firebase_admin import storage, firestore
from firebase_config import firebase_app

def migrate_user_files(user_id: str):
    """
    Migrates all files for a single user to the new structure and updates Firestore.
    
    Args:
        user_id: The Firebase user ID to migrate
    """
    bucket = storage.bucket()
    db = firestore.client()
    moved_files = []
    errors = []
    
    print(f"\n=== Migrating files and database for user: {user_id} ===\n")
    
    # 1. Migrate audio files: {userId}/audio/* -> users/{userId}/audio/*
    print("📁 Checking audio files...")
    audio_prefix = f"{user_id}/audio/"
    blobs = list(bucket.list_blobs(prefix=audio_prefix))
    
    for blob in blobs:
        try:
            old_path = blob.name
            filename = old_path.replace(audio_prefix, "")
            new_path = f"users/{user_id}/audio/{filename}"
            
            new_blob = bucket.blob(new_path)
            new_blob.rewrite(blob)
            blob.delete()
            
            moved_files.append(f"{old_path} -> {new_path}")
            print(f"  ✅ Moved: {old_path} -> {new_path}")
        except Exception as e:
            errors.append(f"Failed to move {blob.name}: {str(e)}")
            print(f"  ❌ Error: {str(e)}")
    
    # 2. Migrate transcript files: {userId}/transcripts/* -> users/{userId}/transcripts/*
    print("\n📄 Checking transcript files...")
    transcript_prefix = f"{user_id}/transcripts/"
    blobs = list(bucket.list_blobs(prefix=transcript_prefix))
    
    for blob in blobs:
        try:
            old_path = blob.name
            filename = old_path.replace(transcript_prefix, "")
            new_path = f"users/{user_id}/transcripts/{filename}"
            
            new_blob = bucket.blob(new_path)
            new_blob.rewrite(blob)
            blob.delete()
            
            moved_files.append(f"{old_path} -> {new_path}")
            print(f"  ✅ Moved: {old_path} -> {new_path}")
        except Exception as e:
            errors.append(f"Failed to move {blob.name}: {str(e)}")
            print(f"  ❌ Error: {str(e)}")
    
    # 3. Migrate profile photo: profile_photos/{userId}.jpg -> users/{userId}/profile_photo.jpg
    print("\n🖼️  Checking profile photo...")
    old_photo_path = f"profile_photos/{user_id}.jpg"
    new_photo_path = f"users/{user_id}/profile_photo.jpg"
    
    new_photo_url = None
    
    try:
        old_blob = bucket.blob(old_photo_path)
        new_blob = bucket.blob(new_photo_path)
        
        if old_blob.exists():
            new_blob.rewrite(old_blob)
            old_blob.delete()
            print(f"  ✅ Moved: {old_photo_path} -> {new_photo_path}")
        elif new_blob.exists():
            print(f"  ℹ️  Photo already at new location: {new_photo_path}")
        else:
            print(f"  ⚠️  No profile photo found for migration.")

        # Generate new public download URL with token (standard Firebase Storage behavior)
        if new_blob.exists():
            new_token = str(uuid.uuid4())
            new_blob.metadata = {"firebaseStorageDownloadTokens": new_token}
            new_blob.patch()
            
            # Construct the public URL manually
            new_photo_url = f"https://firebasestorage.googleapis.com/v0/b/{bucket.name}/o/{new_photo_path.replace('/', '%2F')}?alt=media&token={new_token}"
            print(f"  ✅ Generated new URL: {new_photo_url}")

    except Exception as e:
        errors.append(f"Failed to migrate/generate photo URL: {str(e)}")
        print(f"  ❌ Error: {str(e)}")

    # 4. Update Firestore
    if new_photo_url:
        print("\n🔥 Updating Firestore profile...")
        try:
            user_ref = db.collection("users").document(user_id)
            if user_ref.get().exists:
                user_ref.update({"profile_photo_url": new_photo_url})
                print(f"  ✅ Updated profile_photo_url in Firestore")
            else:
                print(f"  ⚠️  User document not found in Firestore for UID: {user_id}")
        except Exception as e:
            errors.append(f"Failed to update Firestore: {str(e)}")
            print(f"  ❌ Error: {str(e)}")
    
    # Summary
    print(f"\n=== Migration Summary for {user_id} ===")
    print(f"✅ Success")
    print(f"❌ Errors: {len(errors)}")
    
    return len(errors) == 0

def main():
    """Main migration function."""
    if len(sys.argv) < 2:
        print("Usage: python migrate_storage.py <user_id1> [user_id2] ...")
        print("\nExample:")
        print("  python migrate_storage.py 4kAq6PbBKTOvnrqh7mxK8FSblsq1")
        sys.exit(1)
    
    user_ids = sys.argv[1:]
    
    print("=" * 60)
    print("Firebase Storage & Firestore Migration")
    print("=" * 60)
    print(f"\nMigrating {len(user_ids)} user(s)...")
    
    success_count = 0
    for user_id in user_ids:
        if migrate_user_files(user_id):
            success_count += 1
    
    print("\n" + "=" * 60)
    print(f"Migration complete: {success_count}/{len(user_ids)} users updated")
    print("=" * 60)
    
    if success_count < len(user_ids):
        sys.exit(1)

if __name__ == "__main__":
    main()
