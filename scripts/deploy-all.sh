#!/bin/bash

# 🚀 GhostMarket Automated Deployment Script
# This script deploys everything automatically using credentials from .env.deploy

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }

echo -e "${BLUE}"
cat << "EOF"
   _____ _               _   __  __            _        _   
  / ____| |             | | |  \/  |          | |      | |  
 | |  __| |__   ___  ___| |_| \  / | __ _ _ __| | _____| |_ 
 | | |_ | '_ \ / _ \/ __| __| |\/| |/ _` | '__| |/ / _ \ __|
 | |__| | | | | (_) \__ \ |_| |  | | (_| | |  |   <  __/ |_ 
  \_____|_| |_|\___/|___/\__|_|  |_|\__,_|_|  |_|\_\___|\__|
                                                              
  Automated Deployment Script
EOF
echo -e "${NC}"

# Check if .env.deploy exists
if [ ! -f .env.deploy ]; then
    log_error ".env.deploy file not found!"
    echo ""
    echo "Please create .env.deploy from .env.deploy.example:"
    echo "  cp .env.deploy.example .env.deploy"
    echo "  nano .env.deploy  # Fill in your credentials"
    echo ""
    exit 1
fi

# Load credentials
log_info "Loading credentials from .env.deploy..."
source .env.deploy
log_success "Credentials loaded"

# Validate required credentials
MISSING_CREDS=0

if [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
    log_error "GitHub credentials missing (GITHUB_USERNAME, GITHUB_TOKEN)"
    MISSING_CREDS=1
fi

if [ -z "$GENLAYER_WALLET_ADDRESS" ] || [ -z "$GENLAYER_PRIVATE_KEY" ]; then
    log_error "GenLayer wallet missing (GENLAYER_WALLET_ADDRESS, GENLAYER_PRIVATE_KEY)"
    MISSING_CREDS=1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    log_warning "Vercel token missing - will try interactive login"
fi

if [ -z "$VPS_HOST" ] || [ -z "$VPS_USER" ] || [ -z "$VPS_PASSWORD" ]; then
    log_error "VPS credentials missing (VPS_HOST, VPS_USER, VPS_PASSWORD)"
    MISSING_CREDS=1
fi

if [ -z "$CRYPTORANK_API_KEY" ]; then
    log_warning "CryptoRank API key missing - crypto trends may not work"
fi

if [ $MISSING_CREDS -eq 1 ]; then
    log_error "Please fill in required credentials in .env.deploy"
    exit 1
fi

echo ""
log_info "Starting deployment process..."
echo ""

# ============================================
# STEP 1: Push to GitHub
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 1: Pushing to GitHub${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Create GitHub repo
log_info "Creating GitHub repository..."
REPO_NAME="ghostmarket"
GITHUB_RESPONSE=$(curl -s -X POST \
  -H "Authorization: token $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"$REPO_NAME\",\"description\":\"AI-Powered Predictive Demand Marketplace on GenLayer\",\"private\":false}")

if echo "$GITHUB_RESPONSE" | grep -q "already exists"; then
    log_warning "Repository already exists, using existing repo"
elif echo "$GITHUB_RESPONSE" | grep -q "html_url"; then
    log_success "GitHub repository created"
else
    log_error "Failed to create GitHub repository"
    echo "$GITHUB_RESPONSE"
    exit 1
fi

# Add remote and push
REPO_URL="https://${GITHUB_TOKEN}@github.com/${GITHUB_USERNAME}/${REPO_NAME}.git"
log_info "Adding GitHub remote..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

log_info "Pushing to GitHub..."
git push -u origin main --force

log_success "Code pushed to GitHub: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo ""

# ============================================
# STEP 2: Deploy Contracts to GenLayer Studio
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 2: Deploying Contracts to GenLayer Studio (Gasless)${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if genlayer CLI is installed
if ! command -v genlayer &> /dev/null; then
    log_info "Installing GenLayer CLI..."
    pip install genlayer -q
fi

# Configure GenLayer wallet
log_info "Configuring GenLayer wallet: $GENLAYER_WALLET_ADDRESS"
export GENLAYER_PRIVATE_KEY="$GENLAYER_PRIVATE_KEY"

# Deploy to Studio (gasless)
log_info "Deploying GhostMarketCore to GenLayer Studio (gasless, may take 5-10 minutes)..."
CORE_DEPLOY_OUTPUT=$(genlayer deploy contracts/GhostMarketCore.py --network studio 2>&1)
CORE_ADDRESS=$(echo "$CORE_DEPLOY_OUTPUT" | grep -oP 'Contract deployed at: \K[0-9a-fx]+' || echo "")

if [ -z "$CORE_ADDRESS" ]; then
    log_error "Failed to deploy GhostMarketCore"
    echo "$CORE_DEPLOY_OUTPUT"
    exit 1
fi
log_success "GhostMarketCore deployed: $CORE_ADDRESS"

# Deploy GHOST Token to Studio
log_info "Deploying GHOST Token to GenLayer Studio (gasless)..."
TOKEN_DEPLOY_OUTPUT=$(genlayer deploy contracts/GHOSTToken.py --network studio --args 1000000000000000000000000 2>&1)
TOKEN_ADDRESS=$(echo "$TOKEN_DEPLOY_OUTPUT" | grep -oP 'Contract deployed at: \K[0-9a-fx]+' || echo "")

if [ -z "$TOKEN_ADDRESS" ]; then
    log_error "Failed to deploy GHOST Token"
    echo "$TOKEN_DEPLOY_OUTPUT"
    exit 1
fi
log_success "GHOST Token deployed: $TOKEN_ADDRESS"

# Export for VPS deployment
export CORE_ADDRESS
export TOKEN_ADDRESS

# Save contract addresses
echo "GENLAYER_CONTRACT_ADDRESS=$CORE_ADDRESS" >> .env
echo "GENLAYER_TOKEN_ADDRESS=$TOKEN_ADDRESS" >> .env

echo ""
log_success "Contracts deployed successfully to GenLayer Studio (gasless)!"
echo "  GhostMarketCore: $CORE_ADDRESS"
echo "  GHOST Token:     $TOKEN_ADDRESS"
echo "  Deployed by:     $GENLAYER_WALLET_ADDRESS"
echo "  Network:         GenLayer Studio (gasless)"
echo ""

# ============================================
# STEP 3: Deploy Backend to VPS
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 3: Deploying Backend to VPS${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Install sshpass if needed
if ! command -v sshpass &> /dev/null; then
    log_info "Installing sshpass..."
    sudo apt-get update -qq && sudo apt-get install -y sshpass -qq
fi

# Generate postgres password if not provided
if [ -z "$POSTGRES_PASSWORD" ]; then
    POSTGRES_PASSWORD=$(openssl rand -base64 32)
fi

# Create deployment package
log_info "Creating deployment package..."
tar -czf /tmp/ghostmarket-backend.tar.gz \
    backend/ \
    db/ \
    docker-compose.yml \
    .env.example

# Upload to VPS
log_info "Uploading to VPS ($VPS_HOST)..."
sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    /tmp/ghostmarket-backend.tar.gz \
    ${VPS_USER}@${VPS_HOST}:/tmp/

# Deploy on VPS
log_info "Setting up backend on VPS..."
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no \
    ${VPS_USER}@${VPS_HOST} bash << ENDSSH

# Install Docker if needed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker \$USER
fi

# Install Docker Compose if needed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-\$(uname -s)-\$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Extract deployment
cd ~
rm -rf ghostmarket
mkdir -p ghostmarket
cd ghostmarket
tar -xzf /tmp/ghostmarket-backend.tar.gz

# Create .env file
cat > .env << 'ENVEOF'
DATABASE_URL=postgresql://ghostmarket:${POSTGRES_PASSWORD}@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://studio-rpc.genlayer.com
GENLAYER_CONTRACT_ADDRESS=${CORE_ADDRESS}
GENLAYER_TOKEN_ADDRESS=${TOKEN_ADDRESS}
JWT_SECRET=\$(openssl rand -base64 32)
CRYPTORANK_API_KEY=${CRYPTORANK_API_KEY}
ONESIGNAL_APP_ID=${ONESIGNAL_APP_ID}
ONESIGNAL_API_KEY=${ONESIGNAL_API_KEY}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
ENVEOF

# Start services
echo "Starting services..."
docker-compose down 2>/dev/null || true
docker-compose up -d

# Wait for services
echo "Waiting for services..."
sleep 20

echo "✓ Backend deployed!"
docker-compose ps

ENDSSH

BACKEND_URL="http://${VPS_HOST}:8000"
log_success "Backend deployed to VPS!"
log_info "Backend URL: $BACKEND_URL"
log_info "API Docs: $BACKEND_URL/docs"

echo ""

# ============================================
# STEP 4: Deploy Frontend to Vercel
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 4: Deploying Frontend to Vercel${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Install Vercel CLI if needed
if ! command -v vercel &> /dev/null; then
    log_info "Installing Vercel CLI..."
    npm install -g vercel
fi

# Configure Vercel
if [ -n "$VERCEL_TOKEN" ]; then
    export VERCEL_TOKEN="$VERCEL_TOKEN"
    log_info "Using Vercel token from .env.deploy"
else
    log_info "Running Vercel login (interactive)..."
    vercel login
fi

# Deploy to Vercel
cd frontend
log_info "Deploying to Vercel..."

# Create .env.local with contract addresses
cat > .env.local << EOF
NEXT_PUBLIC_API_URL=$BACKEND_URL
NEXT_PUBLIC_CONTRACT_ADDRESS=$CORE_ADDRESS
NEXT_PUBLIC_TOKEN_ADDRESS=$TOKEN_ADDRESS
NEXT_PUBLIC_CHAIN_ID=genlayer-studio
NEXT_PUBLIC_RPC_URL=https://studio-rpc.genlayer.com
EOF

# Deploy with environment variables
VERCEL_OUTPUT=$(vercel --prod --yes \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS="$CORE_ADDRESS" \
  -e NEXT_PUBLIC_TOKEN_ADDRESS="$TOKEN_ADDRESS" \
  -e NEXT_PUBLIC_CHAIN_ID="genlayer-studio" \
  -e NEXT_PUBLIC_RPC_URL="https://studio-rpc.genlayer.com" \
  -e NEXT_PUBLIC_API_URL="$BACKEND_URL" \
  2>&1)

VERCEL_URL=$(echo "$VERCEL_OUTPUT" | grep -oP 'https://[^\s]+\.vercel\.app' | head -1)

cd ..

if [ -z "$VERCEL_URL" ]; then
    log_error "Failed to get Vercel URL"
    echo "$VERCEL_OUTPUT"
    exit 1
fi

log_success "Frontend deployed to Vercel: $VERCEL_URL"
echo ""

# ============================================
# STEP 4: Test Deployment
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 4: Testing Deployment${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

log_info "Waiting for Vercel deployment to be ready..."
sleep 10

# Test homepage
log_info "Testing homepage..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL" || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    log_success "Homepage is accessible"
else
    log_warning "Homepage returned HTTP $HTTP_CODE (may need a moment to warm up)"
fi

# Test feed page
log_info "Testing feed page..."
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$VERCEL_URL/feed" || echo "000")
if [ "$HTTP_CODE" = "200" ]; then
    log_success "Feed page is accessible"
else
    log_warning "Feed page returned HTTP $HTTP_CODE"
fi

echo ""

# ============================================
# DEPLOYMENT COMPLETE
# ============================================
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 DEPLOYMENT COMPLETE!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${GREEN}✓${NC} GitHub Repository: https://github.com/${GITHUB_USERNAME}/${REPO_NAME}"
echo -e "${GREEN}✓${NC} Frontend URL:      $VERCEL_URL"
echo -e "${GREEN}✓${NC} Backend URL:       $BACKEND_URL"
echo -e "${GREEN}✓${NC} GhostMarketCore:   $CORE_ADDRESS"
echo -e "${GREEN}✓${NC} GHOST Token:       $TOKEN_ADDRESS"
echo -e "${GREEN}✓${NC} Deployed by:       $GENLAYER_WALLET_ADDRESS"
echo -e "${GREEN}✓${NC} Network:           GenLayer Studio (gasless)"
echo ""
echo "Contract Explorer:"
echo "  https://studio.genlayer.com/contract/$CORE_ADDRESS"
echo "  https://studio.genlayer.com/contract/$TOKEN_ADDRESS"
echo ""
echo -e "${BLUE}API Documentation:${NC}"
echo "  $BACKEND_URL/docs"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Visit your app: $VERCEL_URL"
echo "  2. Test the API: $BACKEND_URL/docs"
echo "  3. Check contracts on Studio"
echo "  4. Share your deployed app!"
echo ""
