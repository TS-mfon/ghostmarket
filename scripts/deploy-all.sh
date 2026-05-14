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

if [ -z "$GENLAYER_PRIVATE_KEY" ]; then
    log_error "GenLayer private key missing (GENLAYER_PRIVATE_KEY)"
    MISSING_CREDS=1
fi

if [ -z "$VERCEL_TOKEN" ]; then
    log_warning "Vercel token missing - will try interactive login"
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
# STEP 2: Deploy Contracts to GenLayer
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 2: Deploying Contracts to GenLayer${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Check if genlayer CLI is installed
if ! command -v genlayer &> /dev/null; then
    log_info "Installing GenLayer CLI..."
    pip install genlayer -q
fi

# Configure GenLayer account
log_info "Configuring GenLayer account..."
export GENLAYER_PRIVATE_KEY="$GENLAYER_PRIVATE_KEY"

# Deploy GhostMarketCore
log_info "Deploying GhostMarketCore contract (this may take a few minutes)..."
CORE_DEPLOY_OUTPUT=$(genlayer deploy contracts/GhostMarketCore.py --network testnet 2>&1)
CORE_ADDRESS=$(echo "$CORE_DEPLOY_OUTPUT" | grep -oP 'Contract deployed at: \K[0-9a-fx]+' || echo "")

if [ -z "$CORE_ADDRESS" ]; then
    log_error "Failed to deploy GhostMarketCore"
    echo "$CORE_DEPLOY_OUTPUT"
    exit 1
fi
log_success "GhostMarketCore deployed: $CORE_ADDRESS"

# Deploy GHOST Token
log_info "Deploying GHOST Token contract..."
TOKEN_DEPLOY_OUTPUT=$(genlayer deploy contracts/GHOSTToken.py --network testnet --args 1000000000000000000000000 2>&1)
TOKEN_ADDRESS=$(echo "$TOKEN_DEPLOY_OUTPUT" | grep -oP 'Contract deployed at: \K[0-9a-fx]+' || echo "")

if [ -z "$TOKEN_ADDRESS" ]; then
    log_error "Failed to deploy GHOST Token"
    echo "$TOKEN_DEPLOY_OUTPUT"
    exit 1
fi
log_success "GHOST Token deployed: $TOKEN_ADDRESS"

# Save contract addresses
echo "GENLAYER_CONTRACT_ADDRESS=$CORE_ADDRESS" >> .env
echo "GENLAYER_TOKEN_ADDRESS=$TOKEN_ADDRESS" >> .env

echo ""
log_success "Contracts deployed successfully!"
echo "  GhostMarketCore: $CORE_ADDRESS"
echo "  GHOST Token:     $TOKEN_ADDRESS"
echo ""

# ============================================
# STEP 3: Deploy Frontend to Vercel
# ============================================
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}STEP 3: Deploying Frontend to Vercel${NC}"
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
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_CONTRACT_ADDRESS=$CORE_ADDRESS
NEXT_PUBLIC_TOKEN_ADDRESS=$TOKEN_ADDRESS
NEXT_PUBLIC_CHAIN_ID=genlayer-testnet
NEXT_PUBLIC_RPC_URL=https://testnet-rpc.genlayer.com
EOF

# Deploy with environment variables
VERCEL_OUTPUT=$(vercel --prod --yes \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS="$CORE_ADDRESS" \
  -e NEXT_PUBLIC_TOKEN_ADDRESS="$TOKEN_ADDRESS" \
  -e NEXT_PUBLIC_CHAIN_ID="genlayer-testnet" \
  -e NEXT_PUBLIC_RPC_URL="https://testnet-rpc.genlayer.com" \
  -e NEXT_PUBLIC_API_URL="http://localhost:8000" \
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
echo -e "${GREEN}✓${NC} GhostMarketCore:   $CORE_ADDRESS"
echo -e "${GREEN}✓${NC} GHOST Token:       $TOKEN_ADDRESS"
echo ""
echo "Contract Explorer:"
echo "  https://testnet-explorer.genlayer.com/contract/$CORE_ADDRESS"
echo "  https://testnet-explorer.genlayer.com/contract/$TOKEN_ADDRESS"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Visit your app: $VERCEL_URL"
echo "  2. Test the features (feed, predictions, dashboard)"
echo "  3. Share your deployed app!"
echo ""
echo -e "${YELLOW}Note:${NC} Backend is running locally. To deploy backend, see DEPLOY_GUIDE.md"
echo ""
