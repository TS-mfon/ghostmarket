# Deployment Guide

## Prerequisites

- VPS with Ubuntu 22.04+
- Domain name pointed to VPS
- GenLayer testnet account with funds

## Backend Deployment (VPS)

### 1. Initial Server Setup

```bash
# SSH into VPS
ssh user@your-vps-ip

# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo apt install docker-compose -y

# Install Nginx
sudo apt install nginx -y

# Install Certbot for SSL
sudo apt install certbot python3-certbot-nginx -y
```

### 2. Clone Repository

```bash
cd /app
git clone https://github.com/yourusername/ghostmarket.git
cd ghostmarket
```

### 3. Configure Environment

```bash
cp .env.example .env
nano .env
# Fill in production values
```

### 4. Start Services

```bash
docker-compose up -d
```

### 5. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/ghostmarket
```

Add:
```nginx
server {
    listen 80;
    server_name api.ghostmarket.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enable site:
```bash
sudo ln -s /etc/nginx/sites-available/ghostmarket /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### 6. Setup SSL

```bash
sudo certbot --nginx -d api.ghostmarket.com
```

## Frontend Deployment (Vercel)

### 1. Connect GitHub Repository

1. Go to https://vercel.com
2. Import your GitHub repository
3. Configure build settings:
   - Framework: Next.js
   - Root Directory: `frontend`
   - Build Command: `npm run build`
   - Output Directory: `.next`

### 2. Set Environment Variables

In Vercel dashboard, add:
```
NEXT_PUBLIC_API_URL=https://api.ghostmarket.com
NEXT_PUBLIC_CONTRACT_ADDRESS=<your-contract-address>
NEXT_PUBLIC_CHAIN_ID=genlayer-testnet
```

### 3. Deploy

Vercel will auto-deploy on push to main branch.

## Contract Deployment (GenLayer Testnet)

### 1. Install GenLayer CLI

```bash
npm install -g @genlayer/cli
```

### 2. Configure Network

```bash
genlayer network add testnet https://testnet-rpc.genlayer.com
genlayer network use testnet
```

### 3. Create Account

```bash
genlayer account create
genlayer account use <your-address>
```

### 4. Deploy Contract

```bash
cd contracts
genlayer deploy GhostMarketCore.py
```

Save the contract address and update environment variables.

## Database Setup

### 1. Create Database

```bash
docker-compose exec postgres psql -U ghostmarket
CREATE DATABASE ghostmarket;
\c ghostmarket
CREATE EXTENSION vector;
\q
```

### 2. Run Migrations

```bash
docker-compose exec backend alembic upgrade head
```

## Monitoring

### Setup Logging

```bash
# View backend logs
docker-compose logs -f backend

# View Nginx logs
sudo tail -f /var/log/nginx/access.log
```

### Health Checks

- Backend: https://api.ghostmarket.com/health
- Frontend: https://ghostmarket.com

## Troubleshooting

### Backend not starting
```bash
docker-compose logs backend
docker-compose restart backend
```

### Database connection issues
```bash
docker-compose exec postgres pg_isready
```

### SSL certificate renewal
```bash
sudo certbot renew --dry-run
```

## Rollback

```bash
cd /app/ghostmarket
git checkout <previous-commit>
docker-compose up -d --build
```
