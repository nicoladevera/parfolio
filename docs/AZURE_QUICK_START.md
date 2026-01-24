# Azure VM Quick Start Guide

Fast setup guide for deploying PARfolio backend on Azure VM.

---

## 🚀 Automated Setup (Recommended)

### 1. SSH into Azure VM
```bash
ssh azureuser@parfolio-backend.westcentralus.cloudapp.azure.com
```

### 2. Clone and Run Setup Script
```bash
git clone https://github.com/nicoladevera/parfolio.git
cd parfolio
chmod +x scripts/azure-setup.sh
./scripts/azure-setup.sh
```

The script will:
- Install Python 3.11, FFmpeg, Nginx
- Create virtual environment
- Install all dependencies
- Configure systemd service
- Set up Nginx reverse proxy

### 3. Configure Environment Variables

Edit the `.env` file:
```bash
nano /home/azureuser/parfolio/backend/.env
```

**Required values to update:**
```bash
FRONTEND_URL=https://parfolio.app
FIREBASE_API_KEY=your_firebase_web_api_key
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
GOOGLE_API_KEY=your_google_gemini_api_key
TAVILY_API_KEY=your_tavily_api_key
```

Save: `Ctrl+X` → `Y` → `Enter`

### 4. Upload Firebase Credentials

**From your local machine:**
```bash
scp backend/firebase-credentials.json azureuser@parfolio-backend.westcentralus.cloudapp.azure.com:/home/azureuser/parfolio/backend/
```

**Or manually create on server:**
```bash
nano /home/azureuser/parfolio/backend/firebase-credentials.json
# Paste your Firebase service account JSON
# Save: Ctrl+X → Y → Enter
```

Set permissions:
```bash
chmod 600 /home/azureuser/parfolio/backend/firebase-credentials.json
```

### 5. Start Backend Service

```bash
sudo systemctl start parfolio-backend
sudo systemctl enable parfolio-backend
sudo systemctl status parfolio-backend
```

### 6. Test Deployment

```bash
curl http://parfolio-backend.westcentralus.cloudapp.azure.com/health
# Expected: {"status":"healthy"}
```

---

## 📋 Environment Variables Reference

Copy these values from your local `.env` and Firebase project:

| Variable | Where to Find It | Example |
|----------|------------------|---------|
| `FIREBASE_API_KEY` | Firebase Console → Project Settings → Web API Key | `AIzaSyC...` |
| `FIREBASE_STORAGE_BUCKET` | Firebase Console → Storage → Bucket name | `parfolio-xyz.appspot.com` |
| `GOOGLE_API_KEY` | Google AI Studio → API Keys | `AIzaSyD...` |
| `TAVILY_API_KEY` | Tavily Dashboard → API Keys | `tvly-...` |

---

## 🔍 Quick Commands

### View Logs
```bash
sudo journalctl -u parfolio-backend -f
```

### Restart Service
```bash
sudo systemctl restart parfolio-backend
```

### Update Code
```bash
cd /home/azureuser/parfolio
git pull origin main
cd backend
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart parfolio-backend
```

### Check Service Status
```bash
sudo systemctl status parfolio-backend
```

---

## 🌐 Azure Network Security Group

**Ensure Port 80 is open:**

1. Azure Portal → Your VM → Networking
2. Add inbound port rule:
   - Port: `80`
   - Protocol: `TCP`
   - Source: `Any`
   - Action: `Allow`
   - Name: `Allow-HTTP`

---

## ✅ Deployment Checklist

- [ ] VM created with at least 4GB RAM
- [ ] Port 80 open in NSG
- [ ] Repository cloned
- [ ] Setup script executed
- [ ] `.env` file configured with all API keys
- [ ] `firebase-credentials.json` uploaded
- [ ] Backend service started and enabled
- [ ] Health endpoint returns `{"status":"healthy"}`
- [ ] Frontend can connect (check browser console)

---

## 🐛 Troubleshooting

**Service won't start?**
```bash
sudo journalctl -u parfolio-backend -n 50
```

**CORS errors in browser?**
- Check `FRONTEND_URL=https://parfolio.app` in `.env`
- Restart: `sudo systemctl restart parfolio-backend`

**502 Bad Gateway?**
- Check if backend is running: `sudo systemctl status parfolio-backend`
- Check nginx logs: `sudo tail -f /var/log/nginx/error.log`

---

## 📚 Full Documentation

See `docs/AZURE_DEPLOYMENT.md` for complete deployment guide.

---

**Production URLs:**
- Frontend: https://parfolio.app
- Backend: http://parfolio-backend.westcentralus.cloudapp.azure.com
