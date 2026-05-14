# 🔐 How to Get Your Deployment Credentials

Follow these steps to get the credentials needed for automated deployment.

---

## 1. GitHub Token (Required)

**What it's for:** Pushing code to GitHub

**How to get it:**

1. Go to: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a name: "GhostMarket Deployment"
4. Select scopes:
   - ✅ `repo` (all repo permissions)
   - ✅ `workflow` (if using GitHub Actions)
5. Click "Generate token"
6. **Copy the token immediately** (you won't see it again!)

**Add to .env.deploy:**
```bash
GITHUB_USERNAME=your-github-username
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## 2. GenLayer Wallet (Required)

**What it's for:** Deploying smart contracts

**You'll provide your wallet address and private key**

**Add to .env.deploy:**
```bash
GENLAYER_WALLET_ADDRESS=0x1234567890123456789012345678901234567890
GENLAYER_PRIVATE_KEY=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Important:** 
- Make sure your wallet has testnet tokens!
- Get them from: https://faucet.genlayer.com
- Check balance: `genlayer account balance --network testnet`

---

## 3. VPS Credentials (Required)

**What it's for:** Deploying backend server

**You need:**
- VPS IP address or hostname
- SSH username (usually `root` or `ubuntu`)
- SSH password

**Add to .env.deploy:**
```bash
VPS_HOST=123.456.789.012
VPS_USER=root
VPS_PASSWORD=your-vps-password
```

**Note:** The script will automatically install Docker and Docker Compose on your VPS.

---

## 4. Vercel Token (Required)

**What it's for:** Deploying frontend

**Option A: Get API Token (Recommended)**

1. Go to: https://vercel.com/account/tokens
2. Click "Create Token"
3. Name it: "GhostMarket Deployment"
4. Select scope: "Full Account"
5. Click "Create"
6. **Copy the token**

**Add to .env.deploy:**
```bash
VERCEL_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Option B: Use Interactive Login**

Leave `VERCEL_TOKEN` empty in `.env.deploy` and the script will prompt you to login interactively.

---

## 4. Optional: Backend Deployment

**Only needed if you want to deploy the backend**

### Option A: Railway (Easiest)

1. Go to: https://railway.app/account/tokens
2. Click "Create Token"
3. Copy the token

```bash
RAILWAY_TOKEN=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
```

### Option B: Render

1. Go to: https://dashboard.render.com/u/settings#api-keys
2. Click "Create API Key"
3. Copy the key

```bash
RENDER_API_KEY=rnd_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

### Option C: Your VPS

```bash
VPS_HOST=your-server-ip
VPS_USER=your-ssh-username
VPS_SSH_KEY_PATH=/path/to/your/ssh/key
```

---

## 5. CryptoRank API (Required for crypto trends)

**What it's for:** Fetching trending cryptocurrency data

1. Go to: https://cryptorank.io/api
2. Sign up for free tier (no credit card needed)
3. Get your API key from dashboard

```bash
CRYPTORANK_API_KEY=your-api-key-here
```

**Note:** Free tier includes 10,000 requests/month which is plenty for this app.

---

## 6. OneSignal (Optional - for push notifications)

1. Go to: https://onesignal.com
2. Create a new app
3. Get your App ID and API Key from Settings

```bash
ONESIGNAL_APP_ID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx
ONESIGNAL_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

---

## Complete .env.deploy Example

```bash
# Required - GitHub
GITHUB_USERNAME=yourusername
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Required - GenLayer Wallet
GENLAYER_WALLET_ADDRESS=0x1234567890123456789012345678901234567890
GENLAYER_PRIVATE_KEY=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

# Required - Vercel
VERCEL_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxx

# Required - VPS
VPS_HOST=123.456.789.012
VPS_USER=root
VPS_PASSWORD=your-vps-password

# Required - CryptoRank
CRYPTORANK_API_KEY=your-cryptorank-api-key

# Optional - Database (auto-generated if empty)
POSTGRES_PASSWORD=

# Optional - Push Notifications
ONESIGNAL_APP_ID=
ONESIGNAL_API_KEY=
```

---

## Security Notes

⚠️ **IMPORTANT:**

1. **Never commit .env.deploy to git** (it's in .gitignore)
2. **Keep your tokens secret** - they have full access to your accounts
3. **Rotate tokens regularly** - especially if you think they're compromised
4. **Use token scopes** - only give minimum required permissions
5. **Delete tokens** when you're done deploying

---

## Quick Setup

```bash
cd /home/sudodave/ghostmarket

# Copy the template
cp .env.deploy.example .env.deploy

# Edit and add your credentials
nano .env.deploy

# Run deployment
./scripts/deploy-all.sh
```

---

## Troubleshooting

### "Invalid GitHub token"
- Make sure you copied the entire token
- Check that `repo` scope is enabled
- Try generating a new token

### "GenLayer account not found"
- Run `genlayer account list` to see your accounts
- Make sure you exported the correct account
- Check you have testnet tokens: `genlayer account balance --network testnet`

### "Vercel authentication failed"
- Try leaving `VERCEL_TOKEN` empty and use interactive login
- Or generate a new token with "Full Account" scope

### "Permission denied"
- Make sure the script is executable: `chmod +x scripts/deploy-all.sh`
- Check file permissions on .env.deploy: `chmod 600 .env.deploy`

---

**Ready to deploy?**

1. Get your credentials using the guides above
2. Add them to `.env.deploy`
3. Run `./scripts/deploy-all.sh`
4. Watch the magic happen! ✨
