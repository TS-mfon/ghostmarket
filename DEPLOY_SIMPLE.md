# 🚀 Deploy GhostMarket - Simple Steps

## ✅ Package is Ready

The deployment package is already created at: `/tmp/ghostmarket-deploy.tar.gz`

---

## Step 1: Upload to VPS (Run on your machine)

```bash
scp /tmp/ghostmarket-deploy.tar.gz root@172.236.110.179:/tmp/
```

**Enter your VPS password when prompted**

---

## Step 2: Deploy on VPS

### SSH into your VPS:

```bash
ssh root@172.236.110.179
```

### Then copy-paste this entire block:

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

# Extract deployment
cd ~ && rm -rf ghostmarket && mkdir ghostmarket && cd ghostmarket && tar -xzf /tmp/ghostmarket-deploy.tar.gz

# Create .env file
cat > .env << 'EOF'
DATABASE_URL=postgresql://ghostmarket:ghostmarket_pass_2024@postgres:5432/ghostmarket
REDIS_URL=redis://redis:6379/0
GENLAYER_RPC_URL=https://studio.genlayer.com/api
GENLAYER_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
GENLAYER_TOKEN_ADDRESS=0x0000000000000000000000000000000000000000
JWT_SECRET=change_this_secret_$(openssl rand -hex 16)
CRYPTORANK_API_KEY=
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
POSTGRES_PASSWORD=ghostmarket_pass_2024
EOF

# Start services
docker-compose down 2>/dev/null || true && docker-compose up -d && sleep 25 && docker-compose ps
```

---

## Step 3: Deploy Frontend to Vercel

### On your local machine:

```bash
cd /home/sudodave/ghostmarket/frontend

# Install Vercel CLI if needed
npm i -g vercel

# Login
vercel login

# Deploy
vercel --prod \
  -e NEXT_PUBLIC_API_URL="http://172.236.110.179:8000" \
  -e NEXT_PUBLIC_CONTRACT_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_TOKEN_ADDRESS="0x0000000000000000000000000000000000000000" \
  -e NEXT_PUBLIC_CHAIN_ID="61999" \
  -e NEXT_PUBLIC_RPC_URL="https://studio.genlayer.com/api"
```

---

## ✅ What You'll Have

- **Backend**: http://172.236.110.179:8000
- **API Docs**: http://172.236.110.179:8000/docs
- **Frontend**: Your Vercel URL
- **Database**: PostgreSQL on VPS
- **Redis**: On VPS

---

## Test Backend

```bash
curl http://172.236.110.179:8000/health
```

Should return: `{"status":"ok"}`

---

## Deploy Contracts Later

For contracts, you can:

1. **Use GenLayer Studio UI**: https://studio.genlayer.com
2. **Deploy manually** when the RPC is stable
3. **Update contract addresses** in VPS `.env` file later

The platform works without contracts for now - you can add them later!

---

## Quick Summary

1. Upload: `scp /tmp/ghostmarket-deploy.tar.gz root@172.236.110.179:/tmp/`
2. SSH and run the big command block above
3. Deploy frontend with `vercel --prod`
4. Done! 🎉
