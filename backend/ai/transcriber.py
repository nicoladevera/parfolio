import whisper
import os
import torch
from typing import Optional

# Singleton for the whisper model to avoid reloading on every request
_model: Optional[whisper.Whisper] = None

# Enable MPS fallback for unsupported operations on Mac
os.environ["PYTORCH_ENABLE_MPS_FALLBACK"] = "1"

def get_whisper_model(model_size: str = "base"):
    """
    Returns the loaded Whisper model. Lazy loads it if not already present.
    """
    global _model
    if _model is None:
        print(f"Loading Whisper model: {model_size}...")
        
        # Determine best available device
        if torch.cuda.is_available():
            device = "cuda"
        elif torch.backends.mps.is_available():
            device = "mps"
        else:
            device = "cpu"
            
        try:
            _model = whisper.load_model(model_size, device=device)
            print(f"Whisper model loaded on {device}.")
        except Exception as e:
            print(f"Failed to load Whisper on {device}: {e}. Falling back to cpu.")
            _model = whisper.load_model(model_size, device="cpu")
            print("Whisper model loaded on cpu.")
            
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
