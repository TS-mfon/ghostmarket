# 🎯 GhostMarket DApp - Complete Implementation Plan

## 📊 Project Overview

**GhostMarket** is an AI-powered predictive demand marketplace on GenLayer that detects emerging trends before they go mainstream.

**Deployed Contracts:**
- **GhostMarketCore**: `0x624cB58A8462D096E9Ca3e699e4EC09C886beE2C`
- **GHOST Token**: `0x091aEd6a8AC7015E9D191D6Ea4375eE75001F332`
- **Network**: GenLayer Studio (Chain ID: 61999)
- **RPC**: https://studio.genlayer.com/api
- **Explorer**: https://genlayer-explorer.vercel.app

---

## 🏗️ Architecture

### Smart Contracts (GenLayer)

#### GhostMarketCore.py
**Purpose**: Main marketplace logic with AI-powered validation

**Key Features:**
- ✅ Trend submission with AI validation
- ✅ Multi-validator consensus (5 validators)
- ✅ Binary predictions (explode/fade)
- ✅ Reputation system with tiers
- ✅ War rooms (discussion spaces)
- ✅ Voting and comments
- ✅ Prediction resolution with rewards

**Storage Structure:**
```python
trends: TreeMap[u256, Trend]
predictions: TreeMap[u256, Prediction]
reputations: TreeMap[Address, UserReputation]
war_rooms: TreeMap[u256, WarRoom]
comments: TreeMap[u256, Comment]
```

**Main Methods:**
- `submit_trend()` - Submit trend with AI validation
- `create_prediction()` - Make binary prediction
- `resolve_prediction()` - AI-powered outcome check
- `vote_on_trend()` - Upvote/downvote
- `create_war_room()` - Create discussion room
- `add_comment()` - Post comments

#### GHOSTToken.py
**Purpose**: Platform token with staking and governance

**Features:**
- ✅ ERC-20 compatible
- ✅ Staking with 10% APY
- ✅ Governance proposals
- ✅ Voting system

---

### Backend (FastAPI)

**Location**: `/backend`

**Services:**
1. **TrendScraperService** (`services/trend_scraper.py`)
   - Scrapes Hacker News, CryptoRank, GitHub
   - Calculates velocity and momentum
   - Cross-platform correlation

2. **AnalyticsService** (`services/analytics_service.py`)
   - Trend timelines
   - Category heatmaps
   - Velocity charts

3. **NotificationService** (`services/notification_service.py`)
   - OneSignal integration
   - Push notifications for events

**API Endpoints:**
- `/api/v1/trends` - Trend CRUD
- `/api/v1/predictions` - Prediction management
- `/api/v1/reputation` - Reputation & leaderboard
- `/api/v1/war-rooms` - War room management
- `/api/v1/votes` - Voting system
- `/api/v1/analytics` - Analytics data

**Database**: PostgreSQL with pgvector
**Cache**: Redis

---

### Frontend (Next.js 14)

**Location**: `/frontend`

**Pages:**
1. **Homepage** (`/`)
   - Hero section with gradient text
   - Feature highlights
   - Call to action

2. **Feed** (`/feed`)
   - Infinite scroll trend cards
   - Filter by category
   - Prediction buttons
   - Real-time velocity display

3. **Dashboard** (`/dashboard`)
   - User stats (predictions, win rate, reputation)
   - Prediction history
   - Reputation tier display
   - Earnings tracker

4. **Analytics** (`/analytics`)
   - Trend timeline charts
   - Velocity charts
   - Category distribution

5. **War Rooms** (`/war-room/[id]`)
   - Real-time chat interface
   - Member list
   - Message history

**Components:**
- `PredictionModal` - Binary prediction interface
- `WalletConnect` - Wallet connection
- `TrendTimeline` - Timeline chart
- `VelocityChart` - Velocity visualization

**Theme**: Dark cyberpunk
- Colors: Cyan (#00ffff), Magenta (#ff00ff), Green (#00ff00)
- Effects: Glassmorphism, neon glow, gradients

---

## 🔄 User Flows

### 1. Browse Trends
```
User visits /feed
→ Sees trending topics from HN, CryptoRank, GitHub
→ Each trend shows: velocity, confidence, status
→ Can filter by category (crypto, tech, AI)
```

### 2. Make Prediction
```
User clicks "Predict Explode" or "Predict Fade"
→ Modal opens with:
   - Binary choice (Explode/Fade)
   - Confidence slider (0-100%)
   - Timeframe selector (1-90 days)
   - Reward calculation
→ Submit prediction (calls contract)
→ Stake calculated based on confidence
```

### 3. Prediction Resolution
```
After timeframe elapses:
→ Anyone can call resolve_prediction()
→ AI checks current trend status
→ Compares with prediction
→ Distributes rewards if correct
→ Updates reputation
```

### 4. Reputation System
```
Tiers:
- Newbie: 0-99 points
- Explorer: 100-499 points
- Hunter: 500-999 points
- Elite: 1000+ points

Earn points:
- Correct predictions: +reward amount
- Early predictions: 2x multiplier
- High confidence correct: bonus

Lose points:
- Incorrect predictions: -stake/2
```

### 5. War Rooms
```
User creates war room for trend
→ Sets access type (open/staked)
→ Members can chat in real-time
→ Discuss predictions and analysis
→ Share insights
```

---

## 🎨 Design System

### Colors
```css
--cyber-dark: #0a0a0f
--cyber-darker: #12121a
--cyber-cyan: #00ffff
--cyber-magenta: #ff00ff
--cyber-green: #00ff00
```

### Components
- **Glow Cards**: Glassmorphism with animated borders
- **Neon Buttons**: Gradient borders with glow effect
- **Gradient Text**: Cyan to magenta gradient
- **Pulse Indicators**: Animated dots for live data

### Animations
- Fade in on scroll
- Slide up on mount
- Pulse glow on hover
- Smooth transitions

---

## 🔌 Integration Points

### GenLayer Integration
```typescript
// Contract calls
const contract = new Contract(CORE_ADDRESS, ABI, provider)
await contract.submit_trend(name, description, category, platform, url, velocity)
await contract.create_prediction(trendId, type, confidence, timeframe)
```

### CryptoRank API
```typescript
// Fetch trending coins
GET https://api.cryptorank.io/v1/currencies
Headers: { "api-key": CRYPTORANK_API_KEY }
```

### OneSignal Notifications
```typescript
// Send notification
POST https://onesignal.com/api/v1/notifications
Body: { app_id, include_external_user_ids, contents }
```

---

## 📈 Data Flow

### Trend Submission
```
1. User submits trend via frontend
2. Backend validates and calls contract
3. Contract fetches evidence URL
4. AI analyzes authenticity
5. Validators reach consensus
6. Trend stored on-chain
7. Backend indexes in database
8. Frontend updates feed
```

### Prediction Flow
```
1. User makes prediction
2. Contract calculates stake
3. Stores prediction on-chain
4. Updates user reputation
5. Backend tracks in database
6. After timeframe:
   - AI checks outcome
   - Distributes rewards
   - Updates reputation
   - Sends notification
```

---

## 🔐 Security

### Smart Contract
- Input validation on all methods
- Access control (owner-only functions)
- Reentrancy protection
- Error handling with prefixes

### Backend
- JWT authentication
- Rate limiting (60 req/min)
- Input sanitization
- SQL injection protection
- CORS configuration

### Frontend
- Environment variables for secrets
- Secure wallet connection
- XSS protection
- HTTPS only

---

## 🚀 Deployment

### Contracts
- **Network**: GenLayer Studio (gasless)
- **Deployed**: ✅ Both contracts live
- **Verification**: Check on explorer

### Backend
- **Platform**: VPS (172.236.110.179)
- **Services**: Docker Compose
- **Database**: PostgreSQL + pgvector
- **Cache**: Redis

### Frontend
- **Platform**: Vercel
- **Build**: Next.js static export
- **CDN**: Vercel Edge Network

---

## 📊 Metrics & Analytics

### Track
- Total trends submitted
- Prediction accuracy rate
- User reputation distribution
- Most active categories
- War room engagement
- Token staking volume

### Display
- Real-time velocity charts
- Trend timeline evolution
- Category heatmaps
- User leaderboards
- Platform statistics

---

## 🔮 Future Enhancements

### Phase 2
- [ ] Mobile app (React Native)
- [ ] Advanced ML predictions
- [ ] NFT achievement badges
- [ ] Cross-chain bridge
- [ ] DAO governance

### Phase 3
- [ ] Trend marketplace
- [ ] Prediction pools
- [ ] Social features (follow, share)
- [ ] API for developers
- [ ] White-label solution

---

## 📝 Development Guidelines

### Code Style
- TypeScript for frontend
- Python for backend/contracts
- ESLint + Prettier
- Type safety everywhere

### Git Workflow
- Main branch: production
- Feature branches: feature/name
- Commit format: "type: description"
- PR reviews required

### Testing
- Unit tests for contracts
- Integration tests for API
- E2E tests for frontend
- Load testing for backend

---

## 🆘 Troubleshooting

### Contract Issues
- Check transaction on explorer
- Verify gas/consensus
- Check validator votes
- Review error messages

### Backend Issues
- Check Docker logs: `docker-compose logs`
- Verify database connection
- Check Redis status
- Review API responses

### Frontend Issues
- Check browser console
- Verify environment variables
- Check network requests
- Review build logs

---

## 📞 Support

- **Contracts**: https://genlayer-explorer.vercel.app
- **API Docs**: http://YOUR_VPS:8000/docs
- **GitHub**: https://github.com/TS-mfon/ghostmarket

---

## ✅ Current Status

**Completed:**
- ✅ Smart contracts deployed
- ✅ Backend API implemented
- ✅ Frontend UI built
- ✅ Database schema created
- ✅ Trend scraper working
- ✅ Analytics service ready
- ✅ Notification system setup

**Pending:**
- ⏳ VPS backend deployment
- ⏳ Frontend Vercel deployment
- ⏳ Contract address configuration
- ⏳ End-to-end testing
- ⏳ Production launch

---

**Last Updated**: 2026-05-14
**Version**: 1.0.0
**Status**: Ready for deployment
