import os
import requests
import json
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

BASE_URL = "http://localhost:8000/ai"

def test_coaching_with_samples():
    samples_dir = "samples/transcripts"
    sample_files = [f for f in os.listdir(samples_dir) if f.startswith("sample_transcript_")]
    
    for sample_file in sample_files:
        print(f"\n{'='*60}")
        print(f"Testing Coaching with {sample_file}")
        print(f"{'='*60}")
        
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
        
        tags = []
        if tag_resp.status_code == 200:
            tags = [t['tag'] for t in tag_resp.json()['tags']]
            print(f"Assigned Tags: {tags}")

        # Step 3: Generate Coaching Insights
        print("\n[Step 3] Generating Coaching Insights...")
        coach_payload = {
            "first_name": "Nicola",
            "problem": par_data['problem'],
            "action": par_data['action'],
            "result": par_data['result'],
            "tags": tags,
            "user_profile": {
                "current_role": "Product Manager",
                "target_role": "Senior Product Manager",
                "career_stage": "mid_career"
            }
        }
        
        coach_resp = requests.post(
            f"{BASE_URL}/coach",
            json=coach_payload
        )
        
        if coach_resp.status_code != 200:
            print(f"Error coaching: {coach_resp.text}")
            continue
            
        coach_data = coach_resp.json()
        
        for field in ['strength', 'gap', 'suggestion']:
            insight = coach_data[field]
            print(f"\n--- {field.upper()} ---")
            print(f"Overview: {insight['overview']}")
            print(f"Detail: {insight['detail']}")

if __name__ == "__main__":
    print("Verification Script for /ai/coach")
    print("Make sure your backend is running at http://localhost:8000")
    try:
        test_coaching_with_samples()
    except Exception as e:
        print(f"Test failed: {str(e)}")
