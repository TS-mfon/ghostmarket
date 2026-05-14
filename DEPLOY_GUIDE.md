# 🚀 Deployment Guide - Step by Step

## Prerequisites

- GitHub account
- Vercel account (free tier works)
- GenLayer wallet with testnet tokens
- GenLayer CLI installed: `pip install genlayer`

---

## Step 1: Deploy Contracts to GenLayer Testnet

```bash
cd ghostmarket

# Make sure you have GenLayer CLI configured
genlayer account list

# Deploy contracts (this will take a few minutes)
./scripts/deploy-contracts.sh
```

**Expected Output:**
```
✅ GhostMarketCore deployed at: 0x...
✅ GHOST Token deployed at: 0x...
```

**Save these addresses!** You'll need them for the next steps.

---

## Step 2: Push to GitHub

```bash
# Add all files
git add .

# Commit
git commit -m "Initial commit: GhostMarket complete platform"

# Create GitHub repo (via GitHub website or CLI)
# Then add remote and push:
git remote add origin https://github.com/YOUR_USERNAME/ghostmarket.git
git push -u origin main
```

---

## Step 3: Deploy Frontend to Vercel

### Option A: Via Vercel Dashboard (Recommended)

1. Go to https://vercel.com/new
2. Import your GitHub repository
3. Configure project:
   - **Framework Preset**: Next.js
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `.next`

4. Add Environment Variables:
   ```
   NEXT_PUBLIC_API_URL=https://your-backend-url.com
   NEXT_PUBLIC_CONTRACT_ADDRESS=<your-core-contract-address>
   NEXT_PUBLIC_TOKEN_ADDRESS=<your-token-contract-address>
   NEXT_PUBLIC_CHAIN_ID=genlayer-testnet
   NEXT_PUBLIC_RPC_URL=https://testnet-rpc.genlayer.com
   ```

5. Click "Deploy"

### Option B: Via Vercel CLI

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Deploy from frontend directory
cd frontend
vercel --prod

# Follow prompts and add environment variables when asked
```

---

## Step 4: Deploy Backend to VPS (Optional)

If you have a VPS:

```bash
# SSH into your VPS
ssh user@your-vps-ip

# Clone repo
git clone https://github.com/YOUR_USERNAME/ghostmarket.git
cd ghostmarket

# Copy and configure environment
cp .env.example .env
nano .env  # Add your configuration

# Start with Docker Compose
docker-compose up -d

# Check logs
docker-compose logs -f backend
```

**Or use a managed service:**
- Railway.app
- Render.com
- DigitalOcean App Platform

---

## Step 5: Test the Deployment

### Test Contracts

```bash
# Test GhostMarketCore
genlayer call <CONTRACT_ADDRESS> get_trend_count --network testnet

# Submit a test trend
genlayer call <CONTRACT_ADDRESS> submit_trend \
  --args "Test Trend" "Description" "tech" "hackernews" "https://news.ycombinator.com" 75 \
  --network testnet
```

### Test Frontend

1. Visit your Vercel URL: `https://your-app.vercel.app`
2. Check these pages:
   - ✅ Homepage loads
   - ✅ Feed page shows trends
   - ✅ Dashboard displays stats
   - ✅ Analytics charts render
   - ✅ Wallet connect modal opens

### Test Backend (if deployed)

```bash
# Health check
curl https://your-backend-url.com/health

# Get trends
curl https://your-backend-url.com/api/v1/trends/

# API docs
open https://your-backend-url.com/docs
```

---

## Step 6: Configure Production Settings

### Update CORS in Backend

Edit `backend/app/core/config.py`:

```python
CORS_ORIGINS: List[str] = [
    "http://localhost:3000",
    "https://your-app.vercel.app",  # Add your Vercel URL
]
```

### Update Frontend API URL

In Vercel dashboard, update environment variable:
```
NEXT_PUBLIC_API_URL=https://your-backend-url.com
```

Then redeploy:
```bash
vercel --prod
```

---

## Troubleshooting

### Contract Deployment Fails

```bash
# Check GenLayer CLI is configured
genlayer account list

# Check you have testnet tokens
genlayer account balance --network testnet

# Get testnet tokens from faucet
# Visit: https://faucet.genlayer.com
```

### Vercel Build Fails

```bash
# Test build locally first
cd frontend
npm run build

# Check for TypeScript errors
npm run type-check

# Check for linting errors
npm run lint
```

### Frontend Can't Connect to Backend

1. Check CORS settings in backend
2. Verify `NEXT_PUBLIC_API_URL` is correct
3. Check backend is running: `curl https://your-backend-url.com/health`
4. Check browser console for errors

### Contract Calls Fail

1. Verify contract addresses are correct
2. Check GenLayer testnet status
3. Ensure wallet has testnet tokens
4. Check contract explorer for transaction status

---

## Environment Variables Checklist

### Backend (.env)
- ✅ `DATABASE_URL`
- ✅ `REDIS_URL`
- ✅ `GENLAYER_RPC_URL`
- ✅ `GENLAYER_CONTRACT_ADDRESS`
- ✅ `JWT_SECRET` (change from default!)
- ✅ `COINGECKO_API_KEY` (optional)
- ✅ `ONESIGNAL_APP_ID` (optional)
- ✅ `ONESIGNAL_API_KEY` (optional)

### Frontend (.env.local or Vercel)
- ✅ `NEXT_PUBLIC_API_URL`
- ✅ `NEXT_PUBLIC_CONTRACT_ADDRESS`
- ✅ `NEXT_PUBLIC_TOKEN_ADDRESS`
- ✅ `NEXT_PUBLIC_CHAIN_ID`
- ✅ `NEXT_PUBLIC_RPC_URL`

---

## Post-Deployment Checklist

- [ ] Contracts deployed to GenLayer testnet
- [ ] Contract addresses saved and configured
- [ ] Code pushed to GitHub
- [ ] Frontend deployed to Vercel
- [ ] Backend deployed (VPS or managed service)
- [ ] Environment variables configured
- [ ] CORS settings updated
- [ ] All pages load correctly
- [ ] Wallet connection works
- [ ] Contract calls succeed
- [ ] API endpoints respond
- [ ] Analytics charts render

---

## Monitoring

### Contract Activity
- Explorer: `https://testnet-explorer.genlayer.com/contract/<ADDRESS>`
- Check transaction history
- Monitor gas usage

### Frontend
- Vercel Analytics (built-in)
- Check deployment logs in Vercel dashboard

### Backend
- Check logs: `docker-compose logs -f backend`
- Monitor API response times
- Check database connections

---

## Next Steps After Deployment

1. **Test End-to-End Flows**
   - Submit a trend
   - Make a prediction
   - Vote on trends
   - Join a war room

2. **Configure Notifications**
   - Set up OneSignal account
   - Add API keys to backend
   - Test push notifications

3. **Add Real Data**
   - Configure CoinGecko API key
   - Run trend scraper
   - Populate initial trends

4. **Set Up Monitoring**
   - Add error tracking (Sentry)
   - Set up uptime monitoring
   - Configure alerts

5. **Security Hardening**
   - Change all default secrets
   - Enable rate limiting
   - Set up SSL certificates
   - Configure firewall rules

---

## Support

If you encounter issues:

1. Check the logs (Vercel, Docker, GenLayer)
2. Verify all environment variables
3. Test contracts directly with GenLayer CLI
4. Check network connectivity
5. Review CORS and security settings

---

**Deployment complete! 🎉**

Your GhostMarket platform is now live and ready to detect trends before they go mainstream!
