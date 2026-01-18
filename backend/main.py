from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth_router, profile_router, tags_router, ai_router, memory_router, stories_router
from firebase_config import firebase_app

app = FastAPI()

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:3000",      # Local Flutter web dev
        "http://localhost:8080",      # Alternative local dev
        "http://127.0.0.1:3000",
        "http://127.0.0.1:8080",
        # Add production domain when deployed
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth_router.router)
app.include_router(profile_router.router)
app.include_router(tags_router.router, prefix="/tags", tags=["tags"])
app.include_router(memory_router.router, prefix="/memory", tags=["memory"])
app.include_router(ai_router.router)
app.include_router(stories_router.router)


@app.get("/")
async def root():
    return {"message": "Hello from PARfolio API"}

@app.get("/status")
async def status():
    return {"status": "ok", "version": "0.1.0"}

@app.get("/health")
async def health():
    return {"status": "healthy"}
