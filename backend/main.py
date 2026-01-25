import os
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from routers import auth_router, profile_router, tags_router, ai_router, memory_router, stories_router
from firebase_config import firebase_app

app = FastAPI()

# Configure CORS origins based on environment
allowed_origins = [
    # Local development
    "http://localhost:3000",
    "http://localhost:5173",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:5173",
    # Flutter web development server (dynamic port range)
    "http://localhost:60153",
    # Production frontend (Hostinger)
    "https://parfolio.app",
    "http://parfolio.app",
    "https://www.parfolio.app",
    "http://www.parfolio.app",
]

# Add additional frontend URL from environment variable if specified
frontend_url = os.getenv("FRONTEND_URL")
if frontend_url and frontend_url not in allowed_origins:
    allowed_origins.append(frontend_url)
    # Also add https version if http is provided
    if frontend_url.startswith("http://"):
        https_url = frontend_url.replace("http://", "https://")
        if https_url not in allowed_origins:
            allowed_origins.append(https_url)
    elif frontend_url.startswith("https://"):
        http_url = frontend_url.replace("https://", "http://")
        if http_url not in allowed_origins:
            allowed_origins.append(http_url)

# Add CORS middleware
# In development, allow all localhost origins (Flutter uses dynamic ports)
allow_origin_regex = None
if os.getenv("ENVIRONMENT") != "production":
    allow_origin_regex = r"http://localhost:\d+"

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_origin_regex=allow_origin_regex,
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
