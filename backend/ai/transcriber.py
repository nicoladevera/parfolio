import os
import wave
import struct
import uuid
from google.cloud import speech_v1p1beta1 as speech
from google.cloud import storage
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

    # For non-WAV files (likely WebM Opus from web browsers)
    # Flutter's record package on web typically outputs WebM Opus
    print(f"Non-WAV format detected. Trying WEBM_OPUS encoding.")
    return speech.RecognitionConfig.AudioEncoding.WEBM_OPUS, 48000, 1

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

    print(f"Audio format: {sample_rate}Hz, {channels} channel(s), encoding={encoding.name}")

    # Configure audio settings
    audio = speech.RecognitionAudio(content=content)

    # Build config
    config = speech.RecognitionConfig(
        encoding=encoding,
        sample_rate_hertz=sample_rate,
        language_code="en-US",
        enable_automatic_punctuation=True,
        model="default",
        audio_channel_count=channels,
    )

    # Perform transcription
    # Check file size to determine which API to use
    # Files over ~1MB or >60 seconds need async API, but we'll use sync first and fallback
    try:
        print("Using synchronous recognition (for audio < 1 minute)...")
        response = client.recognize(config=config, audio=audio)
    except Exception as e:
        error_msg = str(e)
        # If sync fails due to length, try long-running recognize with GCS
        if "too long" in error_msg.lower() or "LongRunningRecognize" in error_msg or "duration limit" in error_msg.lower():
            print("Audio too long for sync API. Uploading to GCS for long-running recognition...")

            # Upload audio to GCS
            try:
                # Get Firebase Storage bucket name
                bucket_name = os.getenv("FIREBASE_STORAGE_BUCKET", "agentic-coding-project.firebasestorage.app")
                storage_client = storage.Client(credentials=credentials)
                bucket = storage_client.bucket(bucket_name)

                # Create unique blob name
                blob_name = f"temp/transcription-{uuid.uuid4()}.wav"
                blob = bucket.blob(blob_name)

                # Upload file
                print(f"Uploading to gs://{bucket_name}/{blob_name}...")
                blob.upload_from_filename(file_path)

                # Get GCS URI
                gcs_uri = f"gs://{bucket_name}/{blob_name}"
                print(f"File uploaded. Using GCS URI: {gcs_uri}")

                # Create audio object with URI instead of content
                audio_gcs = speech.RecognitionAudio(uri=gcs_uri)

                # Perform long-running recognition
                operation = client.long_running_recognize(config=config, audio=audio_gcs)
                print("Waiting for transcription to complete (this may take a while)...")
                response = operation.result(timeout=1800)  # 30 minute processing timeout

                # Clean up - delete the temporary file from GCS
                print(f"Deleting temporary file from GCS: {blob_name}")
                blob.delete()

            except Exception as gcs_e:
                print(f"Long-running Speech-to-Text API error: {gcs_e}")
                raise Exception(f"Failed to transcribe long audio: {str(gcs_e)}")
        else:
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
