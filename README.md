# 👻 GhostMarket

**AI-Powered Predictive Demand Marketplace on GenLayer**

Detect emerging trends before they go mainstream. Make predictions, earn rewards, and build reputation in the ultimate trend-hunting platform.

![GhostMarket](https://img.shields.io/badge/GenLayer-Intelligent%20Contracts-00ffff) ![Status](https://img.shields.io/badge/Status-Complete-00ff00)

## 🚀 Features

### Core Platform
- **🔮 AI-Powered Trend Validation**: Multi-validator consensus using GenLayer's intelligent contracts
- **📊 Real-Time Trend Detection**: Scrapes Hacker News, CoinGecko, GitHub for emerging signals
- **🎯 Binary Predictions**: Bet on trends to "explode" or "fade" with confidence staking
- **🏆 Reputation System**: Earn reputation through accurate predictions (Newbie → Explorer → Hunter → Elite)
- **💬 War Rooms**: Stake-gated discussion rooms for trend analysis
- **📈 Analytics Dashboard**: Track trend evolution, velocity charts, and heatmaps
- **🪙 GHOST Token**: Stake, earn rewards, and participate in governance

### Technical Highlights
- **Intelligent Contracts**: GenLayer smart contracts with AI validation and web data access
- **Modern Stack**: Next.js 14, FastAPI, PostgreSQL with pgvector, Redis
- **Cyberpunk UI**: Dark theme with neon accents, glassmorphism, and smooth animations
- **Real-Time Updates**: WebSocket support for live war room chat
- **Full Testing**: Unit tests, integration tests, and E2E coverage

## 📁 Project Structure

```
ghostmarket/
├── contracts/              # GenLayer intelligent contracts
│   ├── GhostMarketCore.py # Main contract (trend validation, predictions, reputation)
│   └── GHOSTToken.py      # Token contract (staking, governance)
├── backend/               # FastAPI backend
│   ├── app/
│   │   ├── api/v1/       # REST API endpoints
│   │   ├── services/     # Business logic (scraper, analytics, notifications)
│   │   └── core/         # Config and utilities
│   └── tests/            # Backend tests
├── frontend/             # Next.js 14 frontend
│   ├── app/             # Pages (feed, dashboard, analytics, war rooms)
│   └── components/      # Reusable components (modals, charts, wallet)
├── db/                  # Database schema and migrations
└── .github/workflows/   # CI/CD pipeline
```

## 🛠️ Tech Stack

**Blockchain**
- GenLayer Testnet (Intelligent Contracts)
- Python SDK for contract development

**Backend**
- FastAPI (Python web framework)
- PostgreSQL + pgvector (vector similarity search)
- Redis (caching and rate limiting)
- APScheduler (background jobs)
- OneSignal (push notifications)

**Frontend**
- Next.js 14 (React framework with App Router)
- TypeScript
- Tailwind CSS (cyberpunk theme)
- Framer Motion (animations)
- Radix UI (accessible components)
- Recharts (data visualization)

**DevOps**
- Docker & Docker Compose
- GitHub Actions (CI/CD)
- Nginx (reverse proxy)
- Vercel (frontend hosting)

## 🚀 Quick Start

### Prerequisites
- Node.js 18+
- Python 3.11+
- Docker & Docker Compose
- GenLayer CLI (`pip install genlayer`)

### 1. Clone and Setup

```bash
git clone <your-repo-url> ghostmarket
cd ghostmarket
cp .env.example .env
# Edit .env with your configuration
```

### 2. Start Local Development

```bash
# Start database and Redis
docker-compose up -d

# Install backend dependencies
cd backend
pip install -r requirements.txt

# Run database migrations
alembic upgrade head

# Start backend
uvicorn app.main:app --reload

# In another terminal, start frontend
cd ../frontend
npm install
npm run dev
```

Visit `http://localhost:3000` to see the app!

### 3. Deploy Intelligent Contracts

```bash
# Deploy GhostMarketCore
genlayer deploy contracts/GhostMarketCore.py --network testnet

# Deploy GHOST Token
genlayer deploy contracts/GHOSTToken.py --network testnet --args 1000000000000000000000000

# Update .env with contract addresses
```

## 📖 Usage

### For Users

1. **Connect Wallet**: Click "Connect Wallet" in the navbar
2. **Browse Trends**: Visit `/feed` to see emerging trends
3. **Make Predictions**: Click "Predict Explode" or "Predict Fade" on any trend
4. **Join War Rooms**: Discuss trends with other hunters
5. **Track Performance**: View your stats on `/dashboard`

### For Developers

**Run Tests**
```bash
# Backend tests
cd backend
pytest

# Frontend tests (if added)
cd frontend
npm test
```

**Lint Contracts**
```bash
genvm-lint check contracts/GhostMarketCore.py
genvm-lint check contracts/GHOSTToken.py
```

**API Documentation**
Visit `http://localhost:8000/docs` for interactive API docs

## 🎨 Design System

The platform uses a **dark cyberpunk aesthetic**:

- **Colors**: 
  - Cyber Cyan: `#00ffff`
  - Cyber Magenta: `#ff00ff`
  - Cyber Green: `#00ff00`
  - Dark backgrounds: `#0a0a0f`, `#12121a`

- **Effects**:
  - Glassmorphism cards
  - Neon glow on hover
  - Smooth animations with Framer Motion
  - Gradient text and borders

## 🔐 Security

- JWT authentication for API endpoints
- Rate limiting (60 requests/minute)
- Input validation with Pydantic
- SQL injection protection with parameterized queries
- CORS configuration for production
- Secure password hashing with bcrypt

## 📊 Intelligent Contract Architecture

### GhostMarketCore.py

**Key Methods:**
- `submit_trend()`: Submit trend with AI validation
- `create_prediction()`: Make binary prediction with confidence staking
- `resolve_prediction()`: AI-powered outcome validation and reward distribution
- `vote_on_trend()`: Upvote/downvote trends
- `create_war_room()`: Create discussion rooms
- `add_comment()`: Post comments with threading

**Consensus Pattern:**
Uses `gl.vm.run_nondet_unsafe()` with custom validator functions for:
- Trend authenticity validation (confidence scores within 20 points)
- Prediction outcome verification (must agree on correctness)
- Error handling with `[EXPECTED]`, `[TRANSIENT]`, `[LLM_ERROR]` patterns

### GHOSTToken.py

**Features:**
- ERC-20 compatible (transfer, balance_of, approve, transfer_from)
- Staking with 10% APY rewards
- Governance proposals and voting
- Cooldown period for unstaking

## 🚢 Deployment

See [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed deployment instructions:

1. **VPS Setup**: Docker, Nginx, SSL certificates
2. **Database**: PostgreSQL with pgvector extension
3. **Backend**: FastAPI with Gunicorn
4. **Frontend**: Vercel deployment
5. **Contracts**: GenLayer testnet deployment
6. **CI/CD**: GitHub Actions pipeline

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

MIT License - see LICENSE file for details

## 🙏 Acknowledgments

- Built on [GenLayer](https://genlayer.com) - The blockchain for intelligent contracts
- Trend data from Hacker News, CoinGecko, and GitHub
- UI inspiration from cyberpunk aesthetics

## 📞 Support

- Documentation: [docs.ghostmarket.io](https://docs.ghostmarket.io)
- Discord: [Join our community](https://discord.gg/ghostmarket)
- Twitter: [@GhostMarketAI](https://twitter.com/GhostMarketAI)

---

**Built with 👻 by the GhostMarket team**

*See what the world wants before it knows.*
