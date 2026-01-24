import os
import wave
from google.cloud import speech_v1p1beta1 as speech
from google.oauth2 import service_account

def transcribe_audio_file(file_path: str) -> str:
    """
    Transcribes a local audio file using Google Cloud Speech-to-Text.
    Automatically detects audio format from WAV file.
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

    # Auto-detect audio format from WAV file
    try:
        with wave.open(file_path, 'rb') as wav_file:
            sample_rate = wav_file.getframerate()
            channels = wav_file.getnchannels()
            sample_width = wav_file.getsampwidth()

            print(f"Audio format: {sample_rate}Hz, {channels} channel(s), {sample_width*8}-bit")

            # Determine encoding based on sample width
            if sample_width == 2:  # 16-bit
                encoding = speech.RecognitionConfig.AudioEncoding.LINEAR16
            elif sample_width == 4:  # 32-bit
                encoding = speech.RecognitionConfig.AudioEncoding.LINEAR16  # Convert to 16-bit
            else:
                encoding = speech.RecognitionConfig.AudioEncoding.LINEAR16  # Default
    except Exception as e:
        print(f"Could not read WAV headers: {e}. Using default format.")
        sample_rate = 16000
        encoding = speech.RecognitionConfig.AudioEncoding.LINEAR16

    # Configure audio settings
    audio = speech.RecognitionAudio(content=content)
    config = speech.RecognitionConfig(
        encoding=encoding,
        sample_rate_hertz=sample_rate,
        language_code="en-US",
        enable_automatic_punctuation=True,
        model="default",
        audio_channel_count=channels if 'channels' in locals() else 1,
    )

    # Perform transcription
    try:
        response = client.recognize(config=config, audio=audio)
    except Exception as e:
        print(f"Speech-to-Text API error: {e}")
        raise Exception(f"Failed to transcribe audio: {str(e)}")

    # Combine all transcription results
    transcript = ""
    for result in response.results:
        transcript += result.alternatives[0].transcript + " "

    transcribed_text = transcript.strip()

    if not transcribed_text:
        print("Warning: Transcription returned empty text. Audio may be silent or format incompatible.")

    print(f"Transcription complete: {len(transcribed_text)} characters")

    return transcribed_text
