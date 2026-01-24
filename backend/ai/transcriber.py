import os
from google.cloud import speech_v1p1beta1 as speech
from google.oauth2 import service_account

def transcribe_audio_file(file_path: str) -> str:
    """
    Transcribes a local audio file using Google Cloud Speech-to-Text.
    Returns the transcribed text.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Audio file not found at {file_path}")

    print(f"Transcribing {file_path} with Google Speech-to-Text...")

    # Load credentials from the same Firebase credentials file
    credentials_path = os.getenv("FIREBASE_CREDENTIALS_PATH", "./firebase-credentials.json")
    credentials = service_account.Credentials.from_service_account_file(credentials_path)

    # Create Speech client
    client = speech.SpeechClient(credentials=credentials)

    # Read audio file
    with open(file_path, "rb") as audio_file:
        content = audio_file.read()

    # Configure audio settings
    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=speech.RecognitionConfig.AudioEncoding.LINEAR16,
        sample_rate_hertz=16000,  # Adjust if your audio has different sample rate
        language_code="en-US",
        enable_automatic_punctuation=True,
        model="default",  # Use 'video' model for better accuracy if needed
    )

    # Perform transcription
    response = client.recognize(config=config, audio=audio)

    # Combine all transcription results
    transcript = ""
    for result in response.results:
        transcript += result.alternatives[0].transcript + " "

    transcribed_text = transcript.strip()
    print(f"Transcription complete: {len(transcribed_text)} characters")

    return transcribed_text
