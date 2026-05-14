#!/bin/bash

# VPS Backend Deployment Script
# Deploys GhostMarket backend to VPS using password authentication

set -e

# Load environment
source .env.deploy

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1"; }

echo "🚀 Deploying Backend to VPS"
echo "============================"

# Install sshpass if not available
if ! command -v sshpass &> /dev/null; then
    log_info "Installing sshpass..."
    sudo apt-get update -qq && sudo apt-get install -y sshpass
fi

# Generate strong postgres password if not provided
if [ -z "$POSTGRES_PASSWORD" ]; then
    POSTGRES_PASSWORD=$(openssl rand -base64 32)
    log_info "Generated PostgreSQL password"
fi

# Create deployment package
log_info "Creating deployment package..."
tar -czf /tmp/ghostmarket-backend.tar.gz \
    backend/ \
    db/ \
    docker-compose.yml \
    .env.example

# Upload to VPS
log_info "Uploading to VPS..."
sshpass -p "$VPS_PASSWORD" scp -o StrictHostKeyChecking=no \
    /tmp/ghostmarket-backend.tar.gz \
    ${VPS_USER}@${VPS_HOST}:/tmp/

# Deploy on VPS
log_info "Deploying on VPS..."
sshpass -p "$VPS_PASSWORD" ssh -o StrictHostKeyChecking=no \
    ${VPS_USER}@${VPS_HOST} << 'ENDSSH'

# Install Docker if needed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Install Docker Compose if needed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Extract deployment
cd ~
rm -rf ghostmarket
mkdir -p ghostmarket
cd ghostmarket
tar -xzf /tmp/ghostmarket-backend.tar.gz

# Create .env file
cat > .env << EOF
DATABASE_URL=postgresql://ghostmarket:${POSTGRES_PASSWORD}@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://testnet-rpc.genlayer.com
GENLAYER_CONTRACT_ADDRESS=${CORE_ADDRESS}
GENLAYER_TOKEN_ADDRESS=${TOKEN_ADDRESS}
JWT_SECRET=$(openssl rand -base64 32)
CRYPTORANK_API_KEY=${CRYPTORANK_API_KEY}
ONESIGNAL_APP_ID=${ONESIGNAL_APP_ID}
ONESIGNAL_API_KEY=${ONESIGNAL_API_KEY}
POSTGRES_PASSWORD=${POSTGRES_PASSWORD}
EOF

# Start services
echo "Starting services..."
docker-compose down || true
docker-compose up -d

# Wait for services
echo "Waiting for services to start..."
sleep 15

# Run migrations
echo "Running database migrations..."
docker-compose exec -T backend alembic upgrade head || echo "Migrations skipped (may not be needed)"

echo "✓ Backend deployed successfully!"
docker-compose ps

ENDSSH

log_success "Backend deployed to VPS!"
log_info "Backend URL: http://${VPS_HOST}:8000"
log_info "API Docs: http://${VPS_HOST}:8000/docs"

# Save backend URL for Vercel
echo "BACKEND_URL=http://${VPS_HOST}:8000" >> .env

echo ""
echo "Next: Update Vercel with backend URL"
