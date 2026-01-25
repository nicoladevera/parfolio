# Quick Deployment Guide

**Last Updated:** January 25, 2026

This guide provides the simplest way to deploy PARfolio to production. Use this after merging changes to the main branch.

---

## Prerequisites

- ✅ Changes merged to `main` branch on GitHub
- ✅ SSH key (`parfolio-key.pem`) in `~/Documents/Keys/`
- ✅ Hostinger login credentials
- ✅ Deployment scripts set up (see [First-Time Setup](#first-time-setup) below)

---

## First-Time Setup

**⚠️ Important:** The actual deployment scripts are gitignored for security. Set them up once:

```bash
# Copy templates to create your local scripts
cp scripts/deploy-backend.sh.template scripts/deploy-backend.sh
cp scripts/deploy-frontend.sh.template scripts/deploy-frontend.sh

# Edit deploy-backend.sh to update your paths:
# - Line 13: PEM_FILE (e.g., ~/Documents/Keys/parfolio-key.pem)
# - Line 14: SSH_HOST (e.g., user@your-host.com)
# - Line 58: Health check URL

# Make executable
chmod +x scripts/deploy-backend.sh scripts/deploy-frontend.sh
```

**Or use environment variables** (add to `~/.zshrc`):
```bash
export PARFOLIO_PEM_FILE="$HOME/Documents/Keys/parfolio-key.pem"
export PARFOLIO_SSH_HOST="nicoladevera@parfolio-backend.westcentralus.cloudapp.azure.com"
```

See [scripts/README.md](../scripts/README.md) for more details.

---

## Option 1: Automated Scripts (Recommended)

### Deploy Backend (Azure VM)

```bash
cd /Users/nicoladevera/Developer/parfolio
./scripts/deploy-backend.sh
```

**What it does:**
- Connects to Azure VM via SSH
- Pulls latest code from GitHub
- Installs dependencies
- Restarts backend service
- Tests health endpoint

**Expected output:**
```
✅ Backend deployment completed!
🌐 Backend URL: https://parfolio-backend.westcentralus.cloudapp.azure.com
```

### Deploy Frontend (Hostinger)

```bash
cd /Users/nicoladevera/Developer/parfolio
./scripts/deploy-frontend.sh
```

**What it does:**
- Cleans old deploy folder
- Builds Flutter web app
- Copies landing page files
- Creates deploy folder ready for upload

**Expected output:**
```
✅ Build completed successfully!
📊 Deployment Summary:
   Location: /Users/nicoladevera/Developer/parfolio/deploy/
   Size: ~42M
```

**Then manually:**
1. Go to https://hpanel.hostinger.com
2. File Manager → `public_html/`
3. Delete old files (index.html, style.css, script.js, assets/, app/)
4. Upload ALL files from `deploy/` folder
5. Test: https://parfolio.app/ and https://parfolio.app/app
6. Hard reload browser (Cmd+Shift+R or Ctrl+Shift+R)

---

## Option 2: Manual Step-by-Step

### Backend Deployment

**Step 1:** Connect to Azure VM
```bash
ssh -i ~/Documents/Keys/parfolio-key.pem nicoladevera@parfolio-backend.westcentralus.cloudapp.azure.com
```

**Step 2:** Update code
```bash
cd ~/parfolio
git pull origin main
```

**Step 3:** Install dependencies
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
```

**Step 4:** Restart service
```bash
sudo systemctl restart parfolio-backend
```

**Step 5:** Check status
```bash
sudo systemctl status parfolio-backend
# Should show "active (running)"
```

**Step 6:** Test health
```bash
curl https://parfolio-backend.westcentralus.cloudapp.azure.com/health
# Should return: {"status":"healthy"}
```

**Step 7:** Exit
```bash
exit
```

---

### Frontend Deployment

**Step 1:** Navigate to project
```bash
cd /Users/nicoladevera/Developer/parfolio
```

**Step 2:** Build Flutter app
```bash
cd frontend
flutter build web --release --base-href "/app/"
cd ..
```

**Step 3:** Create deploy folder
```bash
rm -rf deploy
mkdir -p deploy

cp marketing/index.html deploy/
cp marketing/style.css deploy/
cp marketing/script.js deploy/
cp -r marketing/assets deploy/

mkdir -p deploy/app
cp -r frontend/build/web/* deploy/app/
```

**Step 4:** Verify
```bash
du -sh deploy/
ls -la deploy/
# Should show ~42M with index.html, assets/, and app/
```

**Step 5:** Upload to Hostinger
1. Go to https://hpanel.hostinger.com
2. File Manager → `public_html/`
3. Delete old files
4. Upload all from `deploy/`

**Step 6:** Test
- Visit https://parfolio.app/
- Visit https://parfolio.app/app
- Hard reload: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)

---

## For AI Agents

To deploy PARfolio, run these commands:

**Backend:**
```bash
cd /Users/nicoladevera/Developer/parfolio && ./scripts/deploy-backend.sh
```

**Frontend:**
```bash
cd /Users/nicoladevera/Developer/parfolio && ./scripts/deploy-frontend.sh
```

Then instruct the user to upload the `deploy/` folder to Hostinger.

---

## Troubleshooting

### Backend won't start
```bash
# Check logs
ssh -i ~/Documents/Keys/parfolio-key.pem nicoladevera@parfolio-backend.westcentralus.cloudapp.azure.com
sudo journalctl -u parfolio-backend -n 50
```

### Frontend shows old version
- Hard reload browser (Cmd+Shift+R or Ctrl+Shift+R)
- Clear browser cache completely
- Check upload finished successfully in Hostinger

### Health check fails
- Wait 10 seconds and try again (service might be starting)
- Check service status: `sudo systemctl status parfolio-backend`
- Verify `.env` has `ENVIRONMENT=production`

---

## Post-Deployment Checklist

**Backend:**
- [ ] Health endpoint returns `{"status":"healthy"}`
- [ ] Service status shows "active (running)"
- [ ] No errors in logs

**Frontend:**
- [ ] Landing page loads at https://parfolio.app/
- [ ] Flutter app loads at https://parfolio.app/app
- [ ] Login/signup works
- [ ] Can create stories
- [ ] Memory bank works
- [ ] Mobile layout looks correct
- [ ] No console errors (F12)

---

## Quick Reference

**Backend URL:** https://parfolio-backend.westcentralus.cloudapp.azure.com
**Frontend URL:** https://parfolio.app
**Hostinger:** https://hpanel.hostinger.com

**Scripts:**
- `scripts/deploy-backend.sh` - Deploy backend to Azure
- `scripts/deploy-frontend.sh` - Build frontend for upload

**SSH:**
```bash
ssh -i ~/Documents/Keys/parfolio-key.pem nicoladevera@parfolio-backend.westcentralus.cloudapp.azure.com
```

**Logs:**
```bash
sudo journalctl -u parfolio-backend -f
```
