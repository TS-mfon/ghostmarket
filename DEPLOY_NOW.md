# 🚀 YOUR DEPLOYMENT INSTRUCTIONS

## ✅ What's Ready

Your GhostMarket project is **100% complete** and committed to git. Here's what you need to do to deploy:

---

## 📋 Step-by-Step Deployment

### STEP 1: Push to GitHub (5 minutes)

```bash
# 1. Create a new repository on GitHub
# Go to: https://github.com/new
# Name it: ghostmarket
# Make it public or private
# DO NOT initialize with README (we already have one)

# 2. Add GitHub as remote and push
cd /home/sudodave/ghostmarket

git remote add origin https://github.com/YOUR_USERNAME/ghostmarket.git
git push -u origin main
```

**✅ Checkpoint:** Your code should now be visible on GitHub

---

### STEP 2: Deploy Contracts to GenLayer (10 minutes)

**Prerequisites:**
- GenLayer CLI installed: `pip install genlayer`
- GenLayer wallet configured
- Testnet tokens in your wallet

```bash
cd /home/sudodave/ghostmarket

# Option A: Use the automated script
./scripts/deploy-contracts.sh

# Option B: Deploy manually
genlayer deploy contracts/GhostMarketCore.py --network testnet
genlayer deploy contracts/GHOSTToken.py --network testnet --args 1000000000000000000000000
```

**Save the contract addresses!** You'll need them for the next steps.

Example output:
```
✅ GhostMarketCore deployed at: 0xABC123...
✅ GHOST Token deployed at: 0xDEF456...
```

**✅ Checkpoint:** Contracts are deployed and you have the addresses

---

### STEP 3: Deploy Frontend to Vercel (5 minutes)

**Option A: Via Vercel Dashboard (Easiest)**

1. Go to https://vercel.com/new
2. Click "Import Git Repository"
3. Select your `ghostmarket` repository
4. Configure:
   - **Framework Preset:** Next.js
   - **Root Directory:** `frontend`
   - **Build Command:** `npm run build`
   - **Output Directory:** `.next`

5. Add Environment Variables (click "Environment Variables"):
   ```
   NEXT_PUBLIC_API_URL=http://localhost:8000
   NEXT_PUBLIC_CONTRACT_ADDRESS=<your-core-contract-address>
   NEXT_PUBLIC_TOKEN_ADDRESS=<your-token-contract-address>
   NEXT_PUBLIC_CHAIN_ID=genlayer-testnet
   NEXT_PUBLIC_RPC_URL=https://testnet-rpc.genlayer.com
   ```

6. Click "Deploy"

**Option B: Via Vercel CLI**

```bash
# Install Vercel CLI
npm i -g vercel

# Login to Vercel
vercel login

# Deploy
cd /home/sudodave/ghostmarket/frontend
vercel --prod

# Follow the prompts and add environment variables when asked
```

**✅ Checkpoint:** Frontend is live at `https://your-app.vercel.app`

---

### STEP 4: Test the Deployment (5 minutes)

```bash
cd /home/sudodave/ghostmarket

# Run the test script
./scripts/test-deployment.sh

# When prompted, enter your Vercel URL
# Example: https://ghostmarket.vercel.app
```

**Manual Testing:**

1. Visit your Vercel URL
2. Check these pages work:
   - ✅ Homepage (/)
   - ✅ Feed (/feed)
   - ✅ Dashboard (/dashboard)
   - ✅ Analytics (/analytics)
3. Click "Connect Wallet" - modal should open
4. Try clicking "Predict Explode" on a trend - modal should open

**✅ Checkpoint:** All pages load and UI works

---

### STEP 5: Deploy Backend (Optional - 15 minutes)

**If you want the backend running:**

**Option A: Use Railway.app (Easiest)**

1. Go to https://railway.app
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your `ghostmarket` repository
4. Configure:
   - **Root Directory:** `backend`
   - **Start Command:** `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
5. Add environment variables from `.env.example`
6. Add PostgreSQL and Redis from Railway marketplace
7. Deploy

**Option B: Use Render.com**

1. Go to https://render.com
2. New → Web Service
3. Connect your GitHub repo
4. Configure:
   - **Root Directory:** `backend`
   - **Build Command:** `pip install -r requirements.txt`
   - **Start Command:** `uvicorn app.main:app --host 0.0.0.0 --port $PORT`
5. Add environment variables
6. Add PostgreSQL and Redis from Render
7. Deploy

**Option C: Use Your VPS**

See `DEPLOYMENT.md` for detailed VPS setup instructions.

**After backend is deployed:**

Update Vercel environment variable:
```
NEXT_PUBLIC_API_URL=https://your-backend-url.com
```

Then redeploy frontend in Vercel dashboard.

**✅ Checkpoint:** Backend is running and frontend can connect to it

---

## 🔐 How to Provide Credentials Securely

**DO NOT share credentials in chat!** Instead:

### For GenLayer Deployment:
- Use your local GenLayer CLI with your wallet
- Run the deployment script from your machine
- I've prepared the script, you just need to run it

### For GitHub:
- Use your GitHub account to create the repo
- Use git commands I provided to push
- No credentials needed from me

### For Vercel:
- Use your Vercel account
- Connect via GitHub (OAuth)
- Or use Vercel CLI with `vercel login`
- No credentials needed from me

### For Backend Hosting:
- Use Railway/Render/VPS with your account
- Connect via GitHub or deploy manually
- Add environment variables in their dashboard

**I've prepared all the code and scripts - you just need to run them with your accounts!**

---

## 📊 Deployment Checklist

- [ ] Code pushed to GitHub
- [ ] GhostMarketCore contract deployed
- [ ] GHOST Token contract deployed
- [ ] Contract addresses saved
- [ ] Frontend deployed to Vercel
- [ ] Environment variables configured in Vercel
- [ ] Frontend loads correctly
- [ ] All pages accessible
- [ ] Wallet connect works
- [ ] (Optional) Backend deployed
- [ ] (Optional) Backend URL updated in Vercel

---

## 🧪 Testing Checklist

After deployment, test these:

### Frontend Tests
- [ ] Homepage loads with hero section
- [ ] Feed page shows trend cards
- [ ] Dashboard displays stats
- [ ] Analytics shows charts
- [ ] War room page loads
- [ ] Wallet connect modal opens
- [ ] Prediction modal opens
- [ ] Navigation works
- [ ] Mobile responsive

### Contract Tests (if you want to test contracts)
```bash
# Test getting trend count
genlayer call <CONTRACT_ADDRESS> get_trend_count --network testnet

# Test submitting a trend (will take a few minutes due to consensus)
genlayer call <CONTRACT_ADDRESS> submit_trend \
  --args "Test Trend" "Testing the contract" "tech" "hackernews" "https://news.ycombinator.com" 75 \
  --network testnet
```

---

## 🆘 Troubleshooting

### "GenLayer CLI not found"
```bash
pip install genlayer
```

### "No testnet tokens"
Visit GenLayer faucet: https://faucet.genlayer.com

### "Vercel build failed"
Check the build logs in Vercel dashboard. Common issues:
- Missing environment variables
- TypeScript errors (run `npm run build` locally first)

### "Frontend shows errors"
- Check browser console
- Verify environment variables in Vercel
- Make sure contract addresses are correct

### "Can't push to GitHub"
```bash
# Make sure you created the repo on GitHub first
# Then check your remote:
git remote -v

# If wrong, update it:
git remote set-url origin https://github.com/YOUR_USERNAME/ghostmarket.git
```

---

## 📞 What to Do Next

1. **Run the deployment steps above**
2. **Test everything works**
3. **Share your deployed URL!**

If you encounter any issues:
- Check the error messages
- Review the relevant section in `DEPLOY_GUIDE.md`
- Check logs (Vercel dashboard, GenLayer explorer)

---

## 🎉 Success Criteria

Your deployment is successful when:

✅ GitHub repo is public/accessible
✅ Contracts are deployed and visible on GenLayer explorer
✅ Frontend is live on Vercel
✅ All pages load without errors
✅ UI looks good (cyberpunk theme visible)
✅ Wallet connect modal works
✅ No console errors in browser

---

**You're ready to deploy! Follow the steps above and let me know if you hit any issues.** 🚀

The code is 100% complete - you just need to run the deployment commands with your accounts.
