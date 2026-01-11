from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth_router, profile_router
from firebase_config import firebase_app

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Include routers
app.include_router(auth_router.router)
app.include_router(profile_router.router)

@app.get("/")
async def root():
    return {"message": "Hello from PARfolio API"}

@app.get("/status")
async def status():
    return {"status": "ok", "version": "0.1.0"}

@app.get("/health")
async def health():
    return {"status": "healthy"}
