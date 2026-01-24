# Azure VM Deployment Guide for PARfolio

This guide covers deploying the PARfolio backend on Azure VM with DNS configuration.

## Production Configuration

**Backend URL:** http://parfolio-backend.westcentralus.cloudapp.azure.com
**Frontend URL:** https://parfolio.app

---

## Prerequisites on Azure VM

### 1. System Requirements

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3-pip ffmpeg git
```

### 2. Clone Repository

```bash
cd /home/azureuser  # or your preferred directory
git clone https://github.com/nicoladevera/parfolio.git
cd parfolio/backend
```

---

## Environment Configuration

### 1. Create `.env` File

```bash
cd /home/azureuser/parfolio/backend
nano .env
```

### 2. Required Environment Variables

```bash
# Server Configuration
PORT=80
HOST=0.0.0.0
DEBUG=False

# Frontend Configuration
FRONTEND_URL=https://parfolio.app

# Firebase Configuration
FIREBASE_CREDENTIALS_PATH=/home/azureuser/parfolio/backend/firebase-credentials.json
FIREBASE_API_KEY=your_firebase_web_api_key_here
FIREBASE_STORAGE_BUCKET=your-project.appspot.com

# AI API Keys
GOOGLE_API_KEY=your_google_gemini_api_key_here
TAVILY_API_KEY=your_tavily_api_key_here

# Optional: OpenAI API (if using as fallback)
# OPENAI_API_KEY=your_openai_key_here

# Model Configuration (optional overrides)
GEMINI_FLASH_MODEL=gemini-2.0-flash
GEMINI_PRO_MODEL=gemini-2.0-pro-exp-02-05
```

Save and exit (`Ctrl+X`, then `Y`, then `Enter`).

### 3. Upload Firebase Credentials

Copy your Firebase service account JSON to the server:

```bash
# On your local machine
scp backend/firebase-credentials.json azureuser@parfolio-backend.westcentralus.cloudapp.azure.com:/home/azureuser/parfolio/backend/
```

Or manually create the file on the server:
```bash
nano /home/azureuser/parfolio/backend/firebase-credentials.json
# Paste your Firebase credentials JSON
```

**Set proper permissions:**
```bash
chmod 600 /home/azureuser/parfolio/backend/firebase-credentials.json
```

---

## Installation

### 1. Create Virtual Environment

```bash
cd /home/azureuser/parfolio/backend
python3.11 -m venv venv
source venv/bin/activate
```

### 2. Install Dependencies

```bash
pip install --upgrade pip
pip install -r requirements.txt
```

This will install all required packages including:
- FastAPI, Uvicorn
- Firebase Admin SDK
- LangChain + Google Gemini
- OpenAI Whisper (large ML package - takes time)
- ChromaDB
- All other dependencies

**Note:** Installation may take 5-10 minutes due to ML packages.

---

## Running the Application

### Option 1: Manual Start (Testing)

```bash
cd /home/azureuser/parfolio/backend
source venv/bin/activate
uvicorn main:app --host 0.0.0.0 --port 80
```

**For non-privileged port (8000):**
```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

Then set up nginx reverse proxy (see below).

### Option 2: Systemd Service (Production)

Create a systemd service for automatic startup and restart on failure.

**1. Create service file:**
```bash
sudo nano /etc/systemd/system/parfolio-backend.service
```

**2. Add this configuration:**
```ini
[Unit]
Description=PARfolio FastAPI Backend
After=network.target

[Service]
Type=simple
User=azureuser
WorkingDirectory=/home/azureuser/parfolio/backend
Environment="PATH=/home/azureuser/parfolio/backend/venv/bin"
EnvironmentFile=/home/azureuser/parfolio/backend/.env
ExecStart=/home/azureuser/parfolio/backend/venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
```

**3. Enable and start the service:**
```bash
sudo systemctl daemon-reload
sudo systemctl enable parfolio-backend
sudo systemctl start parfolio-backend
```

**4. Check status:**
```bash
sudo systemctl status parfolio-backend
```

**5. View logs:**
```bash
sudo journalctl -u parfolio-backend -f
```

---

## Nginx Reverse Proxy (Recommended)

If running on port 8000 with nginx:

### 1. Install Nginx

```bash
sudo apt install -y nginx
```

### 2. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/parfolio-backend
```

**Add this configuration:**
```nginx
server {
    listen 80;
    server_name parfolio-backend.westcentralus.cloudapp.azure.com;

    client_max_body_size 50M;  # For audio file uploads

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # WebSocket support (if needed)
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### 3. Enable Site

```bash
sudo ln -s /etc/nginx/sites-available/parfolio-backend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## Azure Network Security Group (NSG)

Ensure these ports are open in your Azure NSG:

- **Port 80 (HTTP):** Inbound rule for backend API
- **Port 22 (SSH):** For server management

### Add Inbound Rule via Azure Portal:

1. Go to your VM → Networking → Add inbound port rule
2. **Source:** Any
3. **Source port ranges:** *
4. **Destination:** Any
5. **Destination port ranges:** 80
6. **Protocol:** TCP
7. **Action:** Allow
8. **Priority:** 1000
9. **Name:** Allow-HTTP

---

## Testing Deployment

### 1. Test Backend Health

```bash
curl http://parfolio-backend.westcentralus.cloudapp.azure.com/health
# Expected: {"status":"healthy"}
```

### 2. Test from Frontend

Open https://parfolio.app and try:
- User registration
- Login
- Create a story
- Check browser console for errors

### 3. Check CORS

If you see CORS errors in browser console:
1. Verify `FRONTEND_URL=https://parfolio.app` in `.env`
2. Restart backend: `sudo systemctl restart parfolio-backend`
3. Check allowed origins in logs

---

## Monitoring & Maintenance

### View Application Logs

```bash
# Systemd service logs
sudo journalctl -u parfolio-backend -f

# Nginx access logs
sudo tail -f /var/log/nginx/access.log

# Nginx error logs
sudo tail -f /var/log/nginx/error.log
```

### Restart Services

```bash
# Restart backend
sudo systemctl restart parfolio-backend

# Restart nginx
sudo systemctl restart nginx
```

### Update Code

```bash
cd /home/azureuser/parfolio
git pull origin main
cd backend
source venv/bin/activate
pip install -r requirements.txt  # If dependencies changed
sudo systemctl restart parfolio-backend
```

---

## Data Persistence

### ChromaDB Storage

Vector embeddings are stored at:
```
/home/azureuser/parfolio/backend/data/chromadb/
```

**Backup ChromaDB:**
```bash
tar -czf chromadb-backup-$(date +%Y%m%d).tar.gz /home/azureuser/parfolio/backend/data/chromadb/
```

### Firebase

All user data, stories, and metadata are stored in Firebase (cloud-managed).

---

## Troubleshooting

### Backend Not Starting

```bash
# Check service status
sudo systemctl status parfolio-backend

# Check logs for errors
sudo journalctl -u parfolio-backend -n 50

# Common issues:
# - Missing .env file
# - Wrong Firebase credentials path
# - Missing API keys
# - Port 80 already in use (use 8000 with nginx)
```

### CORS Errors

```bash
# Verify FRONTEND_URL in .env
cat /home/azureuser/parfolio/backend/.env | grep FRONTEND_URL

# Should show: FRONTEND_URL=https://parfolio.app

# Restart to apply changes
sudo systemctl restart parfolio-backend
```

### 502 Bad Gateway (Nginx)

```bash
# Check if backend is running
sudo systemctl status parfolio-backend

# Check nginx config
sudo nginx -t

# Check nginx logs
sudo tail -f /var/log/nginx/error.log
```

### High Memory Usage

Whisper model loads ~3GB into memory on first transcription request. Consider:
- Using at least 4GB RAM on VM
- Implementing lazy loading (already done)
- Monitoring with `htop`

---

## Security Considerations

### 1. Firewall

```bash
# Enable UFW
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw enable
```

### 2. Secure Credentials

```bash
# Ensure .env has restricted permissions
chmod 600 /home/azureuser/parfolio/backend/.env
chmod 600 /home/azureuser/parfolio/backend/firebase-credentials.json
```

### 3. HTTPS (Future Upgrade)

Consider adding SSL/TLS with Let's Encrypt:
```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d parfolio-backend.westcentralus.cloudapp.azure.com
```

---

## Cost Optimization

### VM Sizing

Recommended minimum:
- **Size:** Standard B2s (2 vCPU, 4 GB RAM)
- **Disk:** 30 GB Standard SSD
- **Cost:** ~$30-40/month

For cost savings:
- Stop VM when not in use (dev/testing)
- Use Reserved Instances for production (save 30-70%)

### API Usage Monitoring

Monitor costs for:
- Google Gemini API calls
- Tavily API searches
- Firebase Firestore reads/writes

Set up budget alerts in Google Cloud Console and Tavily dashboard.

---

## Support

For issues:
1. Check logs: `sudo journalctl -u parfolio-backend -f`
2. Verify environment variables in `.env`
3. Test backend health endpoint
4. Check Azure NSG rules
5. Review CORS configuration

---

**Last Updated:** 2026-01-23
