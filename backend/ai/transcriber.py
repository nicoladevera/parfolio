import os
import wave
import struct
from google.cloud import speech_v1p1beta1 as speech
from google.oauth2 import service_account

def detect_audio_format(file_path: str):
    """
    Detect audio format by reading file headers.
    Returns (encoding, sample_rate, channels)
    """
    with open(file_path, 'rb') as f:
        header = f.read(12)

    # Check for WAV (RIFF) format
    if header[:4] == b'RIFF' and header[8:12] == b'WAVE':
        try:
            with wave.open(file_path, 'rb') as wav_file:
                sample_rate = wav_file.getframerate()
                channels = wav_file.getnchannels()
                return speech.RecognitionConfig.AudioEncoding.LINEAR16, sample_rate, channels
        except:
            pass

    # Check for M4A/AAC format (ftyp or similar)
    # AAC files uploaded from Flutter web typically have file extension .wav but are AAC encoded
    # Default to ENCODING_UNSPECIFIED to let Google auto-detect
    print(f"Non-WAV format detected. Using Google auto-detection.")
    return speech.RecognitionConfig.AudioEncoding.ENCODING_UNSPECIFIED, None, 1

def transcribe_audio_file(file_path: str) -> str:
    """
    Transcribes a local audio file using Google Cloud Speech-to-Text.
    Automatically detects audio format and encoding.
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

    # Detect audio format
    encoding, sample_rate, channels = detect_audio_format(file_path)

    if sample_rate:
        print(f"Audio format: {sample_rate}Hz, {channels} channel(s), encoding={encoding.name}")
    else:
        print(f"Using auto-detection for format (encoding={encoding.name})")

    # Configure audio settings
    audio = speech.RecognitionAudio(content=content)

    # Build config with conditional parameters
    config_params = {
        "encoding": encoding,
        "language_code": "en-US",
        "enable_automatic_punctuation": True,
        "model": "default",
        "audio_channel_count": channels,
    }

    # Only add sample_rate if we detected it (not needed for auto-detection)
    if sample_rate:
        config_params["sample_rate_hertz"] = sample_rate

    config = speech.RecognitionConfig(**config_params)

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
        raise Exception("Transcription returned empty text")

    print(f"Transcription complete: {len(transcribed_text)} characters")

    return transcribed_text
