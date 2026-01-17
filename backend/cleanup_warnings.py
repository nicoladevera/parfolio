#!/usr/bin/env python3
"""
Cleanup script to remove redundant AI-generated warnings from existing stories in Firestore.
"""

from firebase_admin import firestore
from firebase_config import firebase_app

def cleanup_story_warnings():
    db = firestore.client()
    stories_ref = db.collection("stories")
    docs = stories_ref.stream()
    
    updated_count = 0
    total_count = 0
    
    print("=" * 60)
    print("Firestore Warnings Cleanup Script")
    print("=" * 60)
    
    for doc in docs:
        total_count += 1
        data = doc.to_dict()
        warnings = data.get("warnings", [])
        
        if not warnings:
            continue
            
        # Filter warnings: only keep technical failure messages
        # Structure suggestions like "Result lacks metrics" do not contain "failed"
        original_count = len(warnings)
        filtered_warnings = [w for w in warnings if "failed" in w.lower()]
        
        if len(filtered_warnings) != original_count:
            print(f"🧹 Cleaning story: {doc.id}")
            print(f"   Removed: {original_count - len(filtered_warnings)} redundant warning(s)")
            doc.reference.update({"warnings": filtered_warnings})
            updated_count += 1
            
    print("\n" + "=" * 60)
    print(f"Cleanup complete!")
    print(f"Total stories checked: {total_count}")
    print(f"Stories updated: {updated_count}")
    print("=" * 60)

if __name__ == "__main__":
    cleanup_story_warnings()
