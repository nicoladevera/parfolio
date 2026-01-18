import os
import requests
import json
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

BASE_URL = "http://localhost:8000/ai"

def test_tagging_with_samples():
    samples_dir = "backend/samples/transcripts"
    sample_files = [f for f in os.listdir(samples_dir) if f.startswith("sample_transcript_")]
    
    for sample_file in sample_files:
        print(f"\n{'='*50}")
        print(f"Testing with {sample_file}")
        print(f"{'='*50}")
        
        with open(os.path.join(samples_dir, sample_file), "r") as f:
            transcript = f.read()
        
        # Step 1: Structure the transcript
        print("\n[Step 1] Structuring transcript...")
        struct_resp = requests.post(
            f"{BASE_URL}/structure",
            json={"raw_transcript": transcript}
        )
        
        if struct_resp.status_code != 200:
            print(f"Error structuring: {struct_resp.text}")
            continue
            
        par_data = struct_resp.json()
        print(f"Title: {par_data['title']}")
        
        # Step 2: Tag the PAR story
        print("\n[Step 2] Tagging story...")
        tag_resp = requests.post(
            f"{BASE_URL}/tag",
            json={
                "problem": par_data['problem'],
                "action": par_data['action'],
                "result": par_data['result']
            }
        )
        
        if tag_resp.status_code != 200:
            print(f"Error tagging: {tag_resp.text}")
            continue
            
        tag_data = tag_resp.json()
        print("\nAssigned Tags:")
        for tag_item in tag_data['tags']:
            print(f"- {tag_item['tag']} (Confidence: {tag_item['confidence']:.2f})")
            print(f"  Reasoning: {tag_item['reasoning']}")

if __name__ == "__main__":
    # Note: Ensure the FastAPI server is running before executing this test script
    print("Verification Script for /ai/tag")
    print("Make sure your backend is running at http://localhost:8000")
    try:
        test_tagging_with_samples()
    except Exception as e:
        print(f"Test failed: {str(e)}")
