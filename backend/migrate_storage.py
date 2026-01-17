#!/usr/bin/env python3
"""
Migration script to move Firebase Storage files to new unified structure.

Old structure:
- {userId}/audio/*
- {userId}/transcripts/*
- profile_photos/{userId}.jpg

New structure:
- users/{userId}/audio/*
- users/{userId}/transcripts/*
- users/{userId}/profile_photo.jpg
"""

import os
import sys
from firebase_admin import storage
from firebase_config import firebase_app

def migrate_user_files(user_id: str):
    """
    Migrates all files for a single user to the new structure.
    
    Args:
        user_id: The Firebase user ID to migrate
    """
    bucket = storage.bucket()
    moved_files = []
    errors = []
    
    print(f"\n=== Migrating files for user: {user_id} ===\n")
    
    # 1. Migrate audio files: {userId}/audio/* -> users/{userId}/audio/*
    print("📁 Checking audio files...")
    audio_prefix = f"{user_id}/audio/"
    blobs = list(bucket.list_blobs(prefix=audio_prefix))
    
    for blob in blobs:
        try:
            old_path = blob.name
            # Extract the filename after "audio/"
            filename = old_path.replace(audio_prefix, "")
            new_path = f"users/{user_id}/audio/{filename}"
            
            # Copy to new location
            new_blob = bucket.blob(new_path)
            new_blob.rewrite(blob)
            
            # Delete old file
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
            # Extract the filename after "transcripts/"
            filename = old_path.replace(transcript_prefix, "")
            new_path = f"users/{user_id}/transcripts/{filename}"
            
            # Copy to new location
            new_blob = bucket.blob(new_path)
            new_blob.rewrite(blob)
            
            # Delete old file
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
    
    try:
        old_blob = bucket.blob(old_photo_path)
        if old_blob.exists():
            new_blob = bucket.blob(new_photo_path)
            new_blob.rewrite(old_blob)
            old_blob.delete()
            
            moved_files.append(f"{old_photo_path} -> {new_photo_path}")
            print(f"  ✅ Moved: {old_photo_path} -> {new_photo_path}")
        else:
            print(f"  ⚠️  No profile photo found at {old_photo_path}")
    except Exception as e:
        errors.append(f"Failed to move profile photo: {str(e)}")
        print(f"  ❌ Error: {str(e)}")
    
    # Summary
    print(f"\n=== Migration Summary for {user_id} ===")
    print(f"✅ Files moved: {len(moved_files)}")
    print(f"❌ Errors: {len(errors)}")
    
    if errors:
        print("\n🚨 Errors encountered:")
        for error in errors:
            print(f"  - {error}")
        return False
    
    return True

def main():
    """Main migration function."""
    if len(sys.argv) < 2:
        print("Usage: python migrate_storage.py <user_id1> [user_id2] ...")
        print("\nExample:")
        print("  python migrate_storage.py 4kAq6PbBKTOvnrqh7mxK8FSblsq1")
        sys.exit(1)
    
    user_ids = sys.argv[1:]
    
    print("=" * 60)
    print("Firebase Storage Migration Script")
    print("=" * 60)
    print(f"\nMigrating {len(user_ids)} user(s)...")
    
    success_count = 0
    for user_id in user_ids:
        if migrate_user_files(user_id):
            success_count += 1
    
    print("\n" + "=" * 60)
    print(f"Migration complete: {success_count}/{len(user_ids)} users migrated successfully")
    print("=" * 60)
    
    if success_count < len(user_ids):
        sys.exit(1)

if __name__ == "__main__":
    main()
