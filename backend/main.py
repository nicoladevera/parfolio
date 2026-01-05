from fastapi import FastAPI
from firebase_config import firebase_app

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.get("/status")
async def status():
    return {"status": "ok", "version": "0.1.0"}

@app.get("/health")
async def health():
    return {"status": "healthy"}
