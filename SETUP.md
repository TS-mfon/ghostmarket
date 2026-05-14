# ✅ READY TO DEPLOY - Just Add Your Credentials!

## What I've Set Up For You

✅ **VPS Backend Deployment** - Backend will deploy to your VPS with password auth
✅ **Wallet-Based Deployment** - Use your wallet to deploy contracts  
✅ **GenLayer Studio (Gasless!)** - No gas fees for contract deployment
✅ **CryptoRank Integration** - Replaced CoinGecko with CryptoRank API
✅ **Automated Everything** - One script deploys everything

---

## What You Need to Provide

Create `.env.deploy` file with these credentials:

```bash
cd /home/sudodave/ghostmarket
cp .env.deploy.example .env.deploy
nano .env.deploy
```

### Fill in these fields:

```bash
# 1. GitHub (to push code)
GITHUB_USERNAME=your-username
GITHUB_TOKEN=get-from-https://github.com/settings/tokens

# 2. Your GenLayer Wallet
GENLAYER_WALLET_ADDRESS=0x...your-wallet-address...
GENLAYER_PRIVATE_KEY=0x...your-private-key...

# 3. Vercel (for frontend)
VERCEL_TOKEN=get-from-https://vercel.com/account/tokens

# 4. Your VPS
VPS_HOST=your-vps-ip-or-domain
VPS_USER=root
VPS_PASSWORD=your-vps-password

# 5. CryptoRank API
CRYPTORANK_API_KEY=get-from-https://cryptorank.io/api

# Optional (can leave empty)
POSTGRES_PASSWORD=
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
```

---

## Then Run Deployment

```bash
cd /home/sudodave/ghostmarket
./scripts/deploy-all.sh
```

**That's it!** The script will:

1. ✅ Push code to GitHub
2. ✅ Deploy contracts using your wallet
3. ✅ Deploy backend to your VPS (auto-installs Docker)
4. ✅ Deploy frontend to Vercel
5. ✅ Test everything
6. ✅ Give you all URLs

**Time: ~10-15 minutes**

---

## What Gets Deployed

- **GitHub Repo**: https://github.com/YOUR_USERNAME/ghostmarket
- **Frontend**: https://ghostmarket-xxx.vercel.app
- **Backend**: http://YOUR_VPS_IP:8000
- **Contracts**: On GenLayer Studio (gasless)
- **Database**: PostgreSQL on your VPS
- **Redis**: On your VPS

---

## Quick Credential Guide

### GitHub Token
1. Go to https://github.com/settings/tokens
2. Generate new token (classic)
3. Select: `repo` + `workflow`
4. Copy token

### Vercel Token
1. Go to https://vercel.com/account/tokens
2. Create token
3. Select "Full Account"
4. Copy token

### CryptoRank API
1. Go to https://cryptorank.io/api
2. Sign up (free)
3. Get API key from dashboard

### Your Wallet
- Just provide your wallet address and private key
- **No gas fees needed!** GenLayer Studio is gasless
- No testnet tokens required

### Your VPS
- IP address or domain
- SSH username (usually `root` or `ubuntu`)
- SSH password

---

## After Deployment

You'll get output like:

```
🎉 DEPLOYMENT COMPLETE!

✓ GitHub Repository: https://github.com/yourusername/ghostmarket
✓ Frontend URL:      https://ghostmarket-abc123.vercel.app
✓ Backend URL:       http://123.456.789.012:8000
✓ GhostMarketCore:   0xABC123...
✓ GHOST Token:       0xDEF456...
✓ Deployed by:       0x...your-wallet...
```

---

## Security Notes

- `.env.deploy` is in `.gitignore` (won't be pushed)
- Your credentials stay on your machine
- Script uses them to deploy, then they're safe
- VPS password is only used for SSH connection

---

## Troubleshooting

### "sshpass not found"
Script will auto-install it

### "Docker not found on VPS"
Script will auto-install it

### "VPS connection failed"
- Check VPS IP is correct
- Check VPS is running
- Check password is correct
- Try SSH manually: `ssh user@vps-ip`

---

## Need More Help?

- **Detailed guide**: `CREDENTIALS_GUIDE.md`
- **Manual deployment**: `DEPLOY_GUIDE.md`
- **Project overview**: `README.md`

---

**Ready to deploy?**

```bash
# 1. Add your credentials
nano .env.deploy

# 2. Run deployment
./scripts/deploy-all.sh

# 3. Watch the magic! ✨
```

Your complete GhostMarket platform will be live in ~15 minutes! 🚀
