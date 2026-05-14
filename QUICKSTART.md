# 🚀 GhostMarket Quick Start Guide

Get GhostMarket running locally in 5 minutes!

## Prerequisites

- Node.js 18+ and npm
- Python 3.11+
- Docker and Docker Compose
- Git

## Step 1: Clone and Configure

```bash
# Clone the repository
git clone <your-repo-url> ghostmarket
cd ghostmarket

# Copy environment template
cp .env.example .env

# Edit .env (optional for local dev - defaults work)
nano .env
```

## Step 2: Start Infrastructure

```bash
# Start PostgreSQL and Redis
docker-compose up -d

# Wait for services to be ready (about 10 seconds)
docker-compose ps
```

## Step 3: Setup Backend

```bash
cd backend

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Run database migrations
alembic upgrade head

# Start backend server
uvicorn app.main:app --reload
```

Backend will be running at `http://localhost:8000`

## Step 4: Setup Frontend

Open a new terminal:

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Frontend will be running at `http://localhost:3000`

## Step 5: Test the Platform

1. Open `http://localhost:3000` in your browser
2. Click "Feed" to see the trend feed
3. Click "Connect Wallet" (mock wallet for local dev)
4. Try making a prediction on a trend
5. Check your dashboard at `/dashboard`

## API Documentation

Visit `http://localhost:8000/docs` for interactive API documentation (Swagger UI)

## Running Tests

```bash
# Backend tests
cd backend
pytest

# With coverage
pytest --cov=app tests/
```

## Deploying Contracts (Optional)

If you want to deploy to GenLayer testnet:

```bash
# Install GenLayer CLI
pip install genlayer

# Deploy GhostMarketCore
genlayer deploy contracts/GhostMarketCore.py --network testnet

# Deploy GHOST Token (1 million initial supply)
genlayer deploy contracts/GHOSTToken.py --network testnet --args 1000000000000000000000000

# Update .env with contract addresses
GENLAYER_CONTRACT_ADDRESS=<your-contract-address>
```

## Troubleshooting

### Database Connection Error
```bash
# Check if PostgreSQL is running
docker-compose ps

# Restart services
docker-compose restart
```

### Port Already in Use
```bash
# Backend (8000)
lsof -ti:8000 | xargs kill -9

# Frontend (3000)
lsof -ti:3000 | xargs kill -9
```

### Module Not Found
```bash
# Backend
cd backend
pip install -r requirements.txt

# Frontend
cd frontend
rm -rf node_modules package-lock.json
npm install
```

## Development Workflow

### Making Changes

1. **Contracts**: Edit `contracts/*.py`, then lint with `genvm-lint check`
2. **Backend**: Edit `backend/app/**/*.py`, server auto-reloads
3. **Frontend**: Edit `frontend/**/*.tsx`, hot reload enabled

### Adding Dependencies

```bash
# Backend
cd backend
pip install <package>
pip freeze > requirements.txt

# Frontend
cd frontend
npm install <package>
```

### Database Migrations

```bash
cd backend

# Create migration
alembic revision --autogenerate -m "description"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1
```

## Environment Variables

Key variables for local development:

```bash
# Database
DATABASE_URL=postgresql://ghostmarket:ghostmarket_dev@localhost:5432/ghostmarket

# Redis
REDIS_URL=redis://localhost:6379/0

# GenLayer (optional for local dev)
GENLAYER_RPC_URL=https://testnet-rpc.genlayer.com
GENLAYER_CONTRACT_ADDRESS=<your-contract-address>

# JWT (change in production!)
JWT_SECRET=dev_secret_change_in_production

# Frontend
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## Project Structure

```
ghostmarket/
├── contracts/          # GenLayer intelligent contracts
├── backend/           # FastAPI backend
│   ├── app/          # Application code
│   └── tests/        # Backend tests
├── frontend/         # Next.js frontend
│   ├── app/         # Pages (App Router)
│   └── components/  # Reusable components
├── db/              # Database schema
└── docker-compose.yml
```

## Next Steps

1. **Explore the Code**: Check out `contracts/GhostMarketCore.py` for intelligent contract logic
2. **Read the Docs**: See `README.md` for full documentation
3. **Deploy**: Follow `DEPLOYMENT.md` for production deployment
4. **Customize**: Modify the cyberpunk theme in `frontend/tailwind.config.ts`

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Stop all services
docker-compose down

# Reset database
docker-compose down -v
docker-compose up -d

# Lint contracts
genvm-lint check contracts/GhostMarketCore.py

# Format Python code
black backend/app

# Format TypeScript code
cd frontend && npm run lint
```

## Getting Help

- **Documentation**: See `README.md` and `PROJECT_SUMMARY.md`
- **Deployment**: See `DEPLOYMENT.md`
- **API Docs**: `http://localhost:8000/docs`
- **GenLayer Docs**: https://docs.genlayer.com

---

**Happy Building! 👻**

*Questions? Check the README or open an issue.*
