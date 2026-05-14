from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from contextlib import asynccontextmanager

from app.core.config import settings
from app.api.v1 import trends, predictions, reputation, war_rooms, votes, analytics

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    print("🚀 GhostMarket API starting...")
    yield
    # Shutdown
    print("👋 GhostMarket API shutting down...")

app = FastAPI(
    title="GhostMarket API",
    description="AI-powered predictive demand marketplace",
    version="1.0.0",
    lifespan=lifespan
)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(trends.router, prefix="/api/v1/trends", tags=["trends"])
app.include_router(predictions.router, prefix="/api/v1/predictions", tags=["predictions"])
app.include_router(reputation.router, prefix="/api/v1/reputation", tags=["reputation"])
app.include_router(war_rooms.router, prefix="/api/v1/war-rooms", tags=["war-rooms"])
app.include_router(votes.router, prefix="/api/v1/votes", tags=["votes"])
app.include_router(analytics.router, prefix="/api/v1/analytics", tags=["analytics"])

@app.get("/")
async def root():
    return {
        "message": "GhostMarket API",
        "version": "1.0.0",
        "docs": "/docs"
    }

@app.get("/health")
async def health():
    return {"status": "healthy"}
