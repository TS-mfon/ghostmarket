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

## 2. GenLayer Private Key (Required)

**What it's for:** Deploying smart contracts

**How to get it:**

```bash
# If you already have a GenLayer account
genlayer account export

# If you need to create one
genlayer account create

# Then export it
genlayer account export
```

**Copy the private key shown**

**Add to .env.deploy:**
```bash
GENLAYER_PRIVATE_KEY=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

**Important:** Make sure your account has testnet tokens!
- Get them from: https://faucet.genlayer.com

---

## 3. Vercel Token (Required)

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

## 5. Optional: External Services

### CoinGecko API (for real trend data)

1. Go to: https://www.coingecko.com/en/api/pricing
2. Sign up for free tier
3. Get your API key

```bash
COINGECKO_API_KEY=CG-xxxxxxxxxxxxxxxxxxxxxxxx
```

### OneSignal (for push notifications)

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
# Required
GITHUB_USERNAME=yourusername
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GENLAYER_PRIVATE_KEY=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
VERCEL_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxx

# Optional - Backend
RAILWAY_TOKEN=
RENDER_API_KEY=
VPS_HOST=
VPS_USER=
VPS_SSH_KEY_PATH=

# Optional - Services
COINGECKO_API_KEY=
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
