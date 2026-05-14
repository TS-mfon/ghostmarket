#!/bin/bash

# Simple VPS Deployment Script
# Run this to deploy backend to your VPS

set -e

echo "🚀 Deploying GhostMarket Backend to VPS"
echo "========================================"

# Load credentials
source .env.deploy

VPS_HOST="172.236.110.179"
VPS_USER="root"

echo "VPS: $VPS_HOST"
echo ""

# Create package
echo "📦 Creating deployment package..."
tar -czf /tmp/ghostmarket-deploy.tar.gz backend/ db/ docker-compose.yml .env.example
echo "✓ Package created"

# Upload
echo ""
echo "📤 Uploading to VPS..."
echo "You'll be prompted for your VPS password"
scp /tmp/ghostmarket-deploy.tar.gz ${VPS_USER}@${VPS_HOST}:/tmp/
echo "✓ Uploaded"

# Deploy
echo ""
echo "🚀 Deploying on VPS..."
echo "You'll be prompted for your VPS password again"

ssh ${VPS_USER}@${VPS_HOST} << 'ENDSSH'
echo "Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

echo "Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

echo "Extracting deployment..."
cd ~
rm -rf ghostmarket
mkdir -p ghostmarket
cd ghostmarket
tar -xzf /tmp/ghostmarket-deploy.tar.gz

echo "Creating .env file..."
cat > .env << 'EOF'
DATABASE_URL=postgresql://ghostmarket:ghostmarket_secure_2024@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://studio.genlayer.com
GENLAYER_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
GENLAYER_TOKEN_ADDRESS=0x0000000000000000000000000000000000000000
JWT_SECRET=$(openssl rand -base64 32)
CRYPTORANK_API_KEY=
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
POSTGRES_PASSWORD=ghostmarket_secure_2024
EOF

echo "Starting services..."
docker-compose down 2>/dev/null || true
docker-compose up -d

echo "Waiting for services to start..."
sleep 20

echo ""
echo "✓ Deployment complete!"
docker-compose ps

ENDSSH

echo ""
echo "✅ Backend deployed successfully!"
echo ""
echo "Backend URL: http://${VPS_HOST}:8000"
echo "API Docs: http://${VPS_HOST}:8000/docs"
echo ""
echo "Next: Deploy frontend to Vercel"
echo "Run: cd frontend && vercel --prod"
