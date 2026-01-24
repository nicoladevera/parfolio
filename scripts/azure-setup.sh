#!/bin/bash
# Azure VM Setup Script for PARfolio Backend
# Run this script on your Azure VM after cloning the repository

set -e  # Exit on error

echo "=================================="
echo "PARfolio Backend Setup for Azure"
echo "=================================="
echo ""

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Configuration
# Automatically detect the current user's home directory
USER_HOME="$HOME"
APP_DIR="$USER_HOME/parfolio"
BACKEND_DIR="$APP_DIR/backend"
VENV_DIR="$BACKEND_DIR/venv"
CURRENT_USER="$USER"

echo "Detected user: $CURRENT_USER"
echo "Installation directory: $APP_DIR"
echo ""

# Step 1: Update system packages
echo -e "${GREEN}Step 1: Updating system packages...${NC}"
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3-pip ffmpeg git nginx

# Step 2: Clone repository (if not already cloned)
if [ ! -d "$APP_DIR" ]; then
    echo -e "${GREEN}Step 2: Cloning repository...${NC}"
    cd "$USER_HOME"
    git clone https://github.com/nicoladevera/parfolio.git
else
    echo -e "${YELLOW}Repository already cloned. Pulling latest changes...${NC}"
    cd "$APP_DIR"
    git pull origin main
fi

# Step 3: Create virtual environment
echo -e "${GREEN}Step 3: Creating Python virtual environment...${NC}"
cd "$BACKEND_DIR"
if [ ! -d "$VENV_DIR" ]; then
    python3.11 -m venv venv
else
    echo -e "${YELLOW}Virtual environment already exists.${NC}"
fi

# Step 4: Install Python dependencies
echo -e "${GREEN}Step 4: Installing Python dependencies (this may take 3-5 minutes)...${NC}"
source "$VENV_DIR/bin/activate"
pip install --upgrade pip
pip install -r requirements.txt

# Step 5: Create .env file if it doesn't exist
if [ ! -f "$BACKEND_DIR/.env" ]; then
    echo -e "${GREEN}Step 5: Creating .env file from template...${NC}"
    cp "$BACKEND_DIR/.env.example" "$BACKEND_DIR/.env"
    echo -e "${YELLOW}IMPORTANT: Edit $BACKEND_DIR/.env and add your API keys!${NC}"
    echo -e "${YELLOW}Required variables:${NC}"
    echo "  - FIREBASE_API_KEY"
    echo "  - FIREBASE_STORAGE_BUCKET"
    echo "  - GOOGLE_API_KEY"
    echo "  - TAVILY_API_KEY"
else
    echo -e "${YELLOW}.env file already exists. Skipping...${NC}"
fi

# Step 6: Set permissions
echo -e "${GREEN}Step 6: Setting file permissions...${NC}"
chmod 600 "$BACKEND_DIR/.env"
if [ -f "$BACKEND_DIR/firebase-credentials.json" ]; then
    chmod 600 "$BACKEND_DIR/firebase-credentials.json"
else
    echo -e "${YELLOW}Warning: firebase-credentials.json not found.${NC}"
    echo -e "${YELLOW}Please upload it to $BACKEND_DIR/firebase-credentials.json${NC}"
fi

# Step 7: Create ChromaDB data directory
echo -e "${GREEN}Step 7: Creating data directories...${NC}"
mkdir -p "$BACKEND_DIR/data/chromadb"

# Step 8: Create systemd service
echo -e "${GREEN}Step 8: Creating systemd service...${NC}"
sudo bash -c "cat > /etc/systemd/system/parfolio-backend.service" <<EOF
[Unit]
Description=PARfolio FastAPI Backend
After=network.target

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$BACKEND_DIR
Environment="PATH=$VENV_DIR/bin"
EnvironmentFile=$BACKEND_DIR/.env
ExecStart=$VENV_DIR/bin/uvicorn main:app --host 0.0.0.0 --port 8000
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload

# Step 9: Configure Nginx
echo -e "${GREEN}Step 9: Configuring Nginx reverse proxy...${NC}"
sudo bash -c "cat > /etc/nginx/sites-available/parfolio-backend" <<'EOF'
server {
    listen 80;
    server_name parfolio-backend.westcentralus.cloudapp.azure.com;

    client_max_body_size 50M;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;

        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
EOF

sudo ln -sf /etc/nginx/sites-available/parfolio-backend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx

# Step 10: Summary
echo ""
echo -e "${GREEN}=================================="
echo "Setup Complete!"
echo -e "==================================${NC}"
echo ""
echo -e "${YELLOW}Next Steps:${NC}"
echo "1. Edit $BACKEND_DIR/.env and add your API keys"
echo "2. Upload firebase-credentials.json to $BACKEND_DIR/"
echo "3. Start the service: sudo systemctl start parfolio-backend"
echo "4. Enable auto-start: sudo systemctl enable parfolio-backend"
echo "5. Check status: sudo systemctl status parfolio-backend"
echo ""
echo -e "${YELLOW}Test your deployment:${NC}"
echo "curl https://parfolio-backend.westcentralus.cloudapp.azure.com/health"
echo ""
echo -e "${YELLOW}Enable HTTPS with Let's Encrypt:${NC}"
echo "sudo apt install certbot python3-certbot-nginx"
echo "sudo certbot --nginx -d parfolio-backend.westcentralus.cloudapp.azure.com"
echo ""
echo -e "${YELLOW}View logs:${NC}"
echo "sudo journalctl -u parfolio-backend -f"
echo ""
