# 🚀 AUTOMATED DEPLOYMENT - START HERE

## Quick Deploy (3 Steps)

### Step 1: Get Your Credentials

You need 3 things:

1. **GitHub Token** - https://github.com/settings/tokens
   - Click "Generate new token (classic)"
   - Select: `repo` and `workflow`
   - Copy the token

2. **GenLayer Private Key**
   ```bash
   genlayer account export
   ```
   - Copy the private key shown
   - Make sure you have testnet tokens: https://faucet.genlayer.com

3. **Vercel Token** - https://vercel.com/account/tokens
   - Click "Create Token"
   - Select "Full Account"
   - Copy the token

**Need help?** See `CREDENTIALS_GUIDE.md` for detailed instructions.

---

### Step 2: Create .env.deploy File

```bash
cd /home/sudodave/ghostmarket

# Copy the template
cp .env.deploy.example .env.deploy

# Edit and add your credentials
nano .env.deploy
```

**Minimum required:**
```bash
GITHUB_USERNAME=your-username
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
GENLAYER_PRIVATE_KEY=0xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
VERCEL_TOKEN=xxxxxxxxxxxxxxxxxxxxxxxxxx
```

Save and close (Ctrl+X, then Y, then Enter)

---

### Step 3: Run Deployment

```bash
./scripts/deploy-all.sh
```

**That's it!** The script will:
- ✅ Create GitHub repo and push code
- ✅ Deploy contracts to GenLayer testnet
- ✅ Deploy frontend to Vercel
- ✅ Test the deployment
- ✅ Give you all the URLs

**Time:** ~5-10 minutes

---

## What You'll Get

After deployment completes, you'll have:

- 🌐 **Live Website** - Your Vercel URL
- 📝 **GitHub Repo** - https://github.com/YOUR_USERNAME/ghostmarket
- 🔗 **Smart Contracts** - Deployed on GenLayer testnet
- ✅ **Tested** - All pages verified working

---

## Troubleshooting

### "genlayer command not found"
```bash
pip install genlayer
```

### "No testnet tokens"
Get free tokens: https://faucet.genlayer.com

### "GitHub token invalid"
- Make sure you selected `repo` scope
- Try generating a new token

### "Vercel deployment failed"
- Check your token has "Full Account" scope
- Or leave VERCEL_TOKEN empty for interactive login

### Script fails
- Check all credentials are correct in .env.deploy
- Make sure no extra spaces or quotes
- Run with debug: `bash -x scripts/deploy-all.sh`

---

## After Deployment

1. **Visit your site** - Use the Vercel URL from the output
2. **Test features:**
   - Homepage loads
   - Feed shows trends
   - Wallet connect works
   - Prediction modal opens
3. **Share your URL!**

---

## Security

⚠️ **IMPORTANT:**
- `.env.deploy` contains sensitive credentials
- It's in `.gitignore` (won't be pushed to GitHub)
- Keep it safe and never share it
- Delete it after deployment if you want

---

## Manual Deployment

If you prefer to deploy manually, see:
- `DEPLOY_GUIDE.md` - Detailed step-by-step guide
- `DEPLOY_NOW.md` - Quick manual deployment

---

## Need Help?

1. Check `CREDENTIALS_GUIDE.md` for credential help
2. Check `DEPLOY_GUIDE.md` for detailed instructions
3. Check the error message from the script
4. Make sure all prerequisites are installed

---

**Ready? Let's deploy!** 🚀

```bash
./scripts/deploy-all.sh
```
