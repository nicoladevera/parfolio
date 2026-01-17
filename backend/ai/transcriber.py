import whisper
import os
import torch
from typing import Optional

# Singleton for the whisper model to avoid reloading on every request
_model: Optional[whisper.Whisper] = None

def get_whisper_model(model_size: str = "base"):
    """
    Returns the loaded Whisper model. Lazy loads it if not already present.
    """
    global _model
    if _model is None:
        print(f"Loading Whisper model: {model_size}...")
        # Automatically use GPU if available, otherwise CPU
        device = "cuda" if torch.cuda.is_available() else "cpu"
        # On Mac, check for MPS (Metal Performance Shaders) for faster inference on Apple Silicon
        if torch.backends.mps.is_available():
            device = "mps"
            
        _model = whisper.load_model(model_size, device=device)
        print(f"Whisper model loaded on {device}.")
    return _model

def transcribe_audio_file(file_path: str) -> str:
    """
    Transcribes a local audio file using Whisper.
    Returns the transcribed text.
    """
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Audio file not found at {file_path}")
        
    model = get_whisper_model()
    
    print(f"Transcribing {file_path}...")
    result = model.transcribe(file_path)
    
    # Whisper result is a dict with 'text' and 'segments'
    return result["text"].strip()
