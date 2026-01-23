# Use Python 3.11 slim image
FROM python:3.11-slim

# Install system dependencies (FFmpeg for Whisper)
RUN apt-get update && apt-get install -y \
    ffmpeg \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy backend requirements
COPY backend/requirements.txt /app/backend/requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r backend/requirements.txt

# Copy backend code
COPY backend /app/backend

# Create necessary directories for ChromaDB and other data
RUN mkdir -p /app/backend/data/chromadb

# Set working directory to backend
WORKDIR /app/backend

# Expose port (Railway will set PORT env var)
EXPOSE 8000

# Start command - Railway will provide PORT env var
CMD uvicorn main:app --host 0.0.0.0 --port ${PORT:-8000}
