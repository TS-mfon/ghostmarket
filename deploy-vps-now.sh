#!/bin/bash
# VPS Deployment Script - Run this to deploy backend

set -e

VPS_HOST="172.236.110.179"
VPS_USER="root"

echo "🚀 Deploying Backend to VPS: $VPS_HOST"
echo ""

# Upload package
echo "📤 Uploading package..."
scp -o StrictHostKeyChecking=no /tmp/ghostmarket-deploy.tar.gz ${VPS_USER}@${VPS_HOST}:/tmp/
echo "✓ Uploaded"

# Deploy on VPS
echo ""
echo "🚀 Setting up on VPS..."
ssh -o StrictHostKeyChecking=no ${VPS_USER}@${VPS_HOST} << 'ENDSSH'

# Install Docker
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# Install Docker Compose
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Extract
echo "Extracting..."
cd ~
rm -rf ghostmarket
mkdir -p ghostmarket
cd ghostmarket
tar -xzf /tmp/ghostmarket-deploy.tar.gz

# Create .env
echo "Configuring..."
cat > .env << 'EOF'
DATABASE_URL=postgresql://ghostmarket:ghostmarket_pass_2024@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://studio.genlayer.com/api
GENLAYER_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
GENLAYER_TOKEN_ADDRESS=0x0000000000000000000000000000000000000000
JWT_SECRET=change_this_in_production_$(openssl rand -hex 16)
CRYPTORANK_API_KEY=
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
POSTGRES_PASSWORD=ghostmarket_pass_2024
EOF

# Start services
echo "Starting services..."
docker-compose down 2>/dev/null || true
docker-compose up -d

echo "Waiting..."
sleep 25

echo ""
echo "✅ Deployment complete!"
docker-compose ps

ENDSSH

echo ""
echo "✅ Backend deployed!"
echo ""
echo "🌐 Backend URL: http://${VPS_HOST}:8000"
echo "📚 API Docs: http://${VPS_HOST}:8000/docs"
echo ""
echo "Test it: curl http://${VPS_HOST}:8000/health"
