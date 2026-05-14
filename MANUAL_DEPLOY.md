# 🚀 Manual VPS Deployment Commands

Since automated deployment had issues, here are the exact commands to run:

## Step 1: Create Deployment Package

```bash
cd /home/sudodave/ghostmarket

# Create deployment archive
tar -czf /tmp/ghostmarket-deploy.tar.gz \
    backend/ \
    db/ \
    docker-compose.yml \
    .env.example

echo "✓ Package created at /tmp/ghostmarket-deploy.tar.gz"
```

## Step 2: Upload to VPS

```bash
# Upload the package (you'll be prompted for password)
scp /tmp/ghostmarket-deploy.tar.gz root@172.236.110.179:/tmp/

echo "✓ Uploaded to VPS"
```

## Step 3: Deploy on VPS

```bash
# SSH into VPS (you'll be prompted for password)
ssh root@172.236.110.179

# Then run these commands on the VPS:
```

### On Your VPS, run:

```bash
# Install Docker if needed
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
fi

# Install Docker Compose if needed
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Extract deployment
cd ~
rm -rf ghostmarket
mkdir -p ghostmarket
cd ghostmarket
tar -xzf /tmp/ghostmarket-deploy.tar.gz

# Create .env file
cat > .env << 'EOF'
DATABASE_URL=postgresql://ghostmarket:ghostmarket_secure_2024@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://studio.genlayer.com
GENLAYER_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
GENLAYER_TOKEN_ADDRESS=0x0000000000000000000000000000000000000000
JWT_SECRET=$(openssl rand -base64 32)
CRYPTORANK_API_KEY=YOUR_CRYPTORANK_KEY_HERE
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
POSTGRES_PASSWORD=ghostmarket_secure_2024
EOF

# Start services
docker-compose down 2>/dev/null || true
docker-compose up -d

# Wait for services
sleep 20

# Check status
docker-compose ps

echo "✓ Backend deployed!"
echo "Backend URL: http://172.236.110.179:8000"
echo "API Docs: http://172.236.110.179:8000/docs"
```

## Step 4: Deploy Frontend to Vercel

```bash
cd /home/sudodave/ghostmarket/frontend

# Install Vercel CLI if needed
npm i -g vercel

# Login to Vercel
vercel login

# Deploy with environment variables
vercel --prod \
  -e NEXT_PUBLIC_API_URL="http://172.236.110.179:8000" \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_TOKEN_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_CHAIN_ID="genlayer-studio" \
  -e NEXT_PUBLIC_RPC_URL="https://studio.genlayer.com"
```

## Quick Copy-Paste Version

### On Your Local Machine:

```bash
cd /home/sudodave/ghostmarket && \
tar -czf /tmp/ghostmarket-deploy.tar.gz backend/ db/ docker-compose.yml .env.example && \
scp /tmp/ghostmarket-deploy.tar.gz root@172.236.110.179:/tmp/
```

### Then SSH and run on VPS:

```bash
ssh root@172.236.110.179

# Copy and paste this entire block:
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh && \
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
chmod +x /usr/local/bin/docker-compose && \
cd ~ && rm -rf ghostmarket && mkdir -p ghostmarket && cd ghostmarket && \
tar -xzf /tmp/ghostmarket-deploy.tar.gz && \
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
docker-compose down 2>/dev/null || true && \
docker-compose up -d && \
sleep 20 && \
docker-compose ps
```

### Then deploy frontend:

```bash
cd /home/sudodave/ghostmarket/frontend && \
vercel --prod \
  -e NEXT_PUBLIC_API_URL="http://172.236.110.179:8000" \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_TOKEN_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_CHAIN_ID="genlayer-studio" \
  -e NEXT_PUBLIC_RPC_URL="https://studio.genlayer.com"
```

## What You'll Have

After running these commands:

- ✅ Backend running at: http://172.236.110.179:8000
- ✅ API Docs at: http://172.236.110.179:8000/docs
- ✅ Frontend on Vercel
- ✅ Database and Redis on VPS

## Note About Contracts

The GenLayer Studio RPC endpoint seems to be unavailable. You have two options:

1. **Deploy contracts manually via GenLayer Studio UI** at https://studio.genlayer.com
2. **Use testnet instead** - change RPC to `https://testnet-rpc.genlayer.com` (requires testnet tokens)

For now, the backend will work without contracts - you can add contract addresses later by updating the `.env` file on your VPS.
