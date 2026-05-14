# 🚀 GhostMarket - Deployed Contracts & Info

## ✅ Deployed Smart Contracts

### GhostMarketCore
- **Address**: `0x624cB58A8462D096E9Ca3e699e4EC09C886beE2C`
- **Network**: GenLayer Studio
- **Chain ID**: 61999
- **Explorer**: https://genlayer-explorer.vercel.app/contract/0x624cB58A8462D096E9Ca3e699e4EC09C886beE2C
- **Transaction**: `0x047c4603e45678e7c03075fcdbbc1836bbadbf0049800dc443283ef14a178484`

### GHOST Token
- **Address**: `0x091aEd6a8AC7015E9D191D6Ea4375eE75001F332`
- **Network**: GenLayer Studio
- **Chain ID**: 61999
- **Explorer**: https://genlayer-explorer.vercel.app/contract/0x091aEd6a8AC7015E9D191D6Ea4375eE75001F332
- **Initial Supply**: 1,000,000 GHOST

## 🌐 Network Details

```javascript
{
  alias: 'studionet',
  name: 'Genlayer Studio Network',
  chainId: '61999',
  rpc: 'https://studio.genlayer.com/api',
  mainContract: '0xb7278A61aa25c888815aFC32Ad3cC52fF24fE575',
  explorer: 'https://genlayer-explorer.vercel.app'
}
```

## 🔑 Environment Variables

### Backend (.env)
```bash
GENLAYER_RPC_URL=https://studio.genlayer.com/api
GENLAYER_CONTRACT_ADDRESS=0x624cB58A8462D096E9Ca3e699e4EC09C886beE2C
GENLAYER_TOKEN_ADDRESS=0x091aEd6a8AC7015E9D191D6Ea4375eE75001F332
```

### Frontend (.env.local)
```bash
NEXT_PUBLIC_CONTRACT_ADDRESS=0x624cB58A8462D096E9Ca3e699e4EC09C886beE2C
NEXT_PUBLIC_TOKEN_ADDRESS=0x091aEd6a8AC7015E9D191D6Ea4375eE75001F332
NEXT_PUBLIC_CHAIN_ID=61999
NEXT_PUBLIC_RPC_URL=https://studio.genlayer.com/api
```

## 📊 Contract Features

### GhostMarketCore
- ✅ Trend submission with AI validation
- ✅ Binary predictions (explode/fade)
- ✅ Reputation system (4 tiers)
- ✅ War rooms for discussions
- ✅ Voting and comments
- ✅ Prediction resolution with rewards

### GHOST Token
- ✅ ERC-20 compatible
- ✅ Staking with 10% APY
- ✅ Governance proposals
- ✅ Voting system

## 🔗 Quick Links

- **GitHub**: https://github.com/TS-mfon/ghostmarket
- **Explorer**: https://genlayer-explorer.vercel.app
- **Studio**: https://studio.genlayer.com
- **Documentation**: See DAPP_PLAN.md

## 📝 Next Steps

1. **Deploy Backend to VPS**
   - See DEPLOY_SIMPLE.md
   - VPS: 172.236.110.179

2. **Deploy Frontend to Vercel**
   - Update env variables with contract addresses
   - Run: `vercel --prod`

3. **Test Integration**
   - Submit test trend
   - Make test prediction
   - Check on explorer

## 🎯 Contract Methods

### Main Methods
```python
# Trends
submit_trend(name, description, category, platform, evidence_url, velocity)
get_trend(trend_id)
get_trend_count()

# Predictions
create_prediction(trend_id, prediction_type, confidence, timeframe_days)
resolve_prediction(prediction_id)
get_prediction(prediction_id)

# Reputation
get_reputation(user_address)
get_leaderboard()

# War Rooms
create_war_room(trend_id, name, access_type, stake_requirement)
join_war_room(war_room_id)
add_comment(war_room_id, trend_id, content, parent_id)

# Voting
vote_on_trend(trend_id, vote_type)
```

## 🔐 Deployed By

- **Wallet**: `0xEd9EDd8586b20524CafA4F568413C504C9B03172`
- **Network**: GenLayer Studio (gasless)
- **Date**: 2026-05-14

---

**Status**: ✅ Contracts Deployed & Verified
**Version**: 1.0.0
