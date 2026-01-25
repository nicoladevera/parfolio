# Deployment Scripts

This folder contains automated deployment scripts for PARfolio.

## Setup (First Time Only)

### Option 1: Copy from Templates (Recommended for Team)

```bash
# Copy templates to actual scripts
cp scripts/deploy-backend.sh.template scripts/deploy-backend.sh
cp scripts/deploy-frontend.sh.template scripts/deploy-frontend.sh

# Edit deploy-backend.sh and update:
# - PEM_FILE path (line 13)
# - SSH_HOST (line 14)
# - Health check URL (line 58)
```

### Option 2: Use Environment Variables (Recommended for You)

Set these in your `~/.zshrc` or `~/.bashrc`:

```bash
export PARFOLIO_PEM_FILE="$HOME/Documents/Keys/parfolio-key.pem"
export PARFOLIO_SSH_HOST="nicoladevera@parfolio-backend.westcentralus.cloudapp.azure.com"
```

Then use the template directly:

```bash
./scripts/deploy-backend.sh.template
```

## Usage

### Deploy Backend

```bash
./scripts/deploy-backend.sh
```

**What it does:**
- Connects to Azure VM via SSH
- Pulls latest code from GitHub
- Installs dependencies
- Restarts backend service
- Tests health endpoint

### Deploy Frontend

```bash
./scripts/deploy-frontend.sh
```

**What it does:**
- Builds Flutter web app
- Creates deploy folder with all assets
- Shows upload instructions for Hostinger

## Security

⚠️ **IMPORTANT:**

- **✅ SAFE to commit:** `.template` files
- **❌ DO NOT commit:** Actual `deploy-*.sh` files (they're gitignored)
- **❌ NEVER commit:** PEM files or credentials

The actual deployment scripts are gitignored to prevent exposing:
- Local file paths
- SSH hostnames
- Server infrastructure details

## Files

- `deploy-backend.sh.template` - Template for backend deployment
- `deploy-frontend.sh.template` - Template for frontend deployment
- `deploy-backend.sh` - Your local copy (gitignored)
- `deploy-frontend.sh` - Your local copy (gitignored)
