from fastapi import APIRouter, HTTPException, Query
from typing import List, Optional
from pydantic import BaseModel

from app.services.trend_scraper import TrendScraperService

router = APIRouter()

class TrendResponse(BaseModel):
    id: int
    name: str
    description: str
    category: str
    platform: str
    velocity: int
    confidence: int
    status: str
    validated: bool
    votes_up: int
    votes_down: int
    created_at: int

class TrendSubmitRequest(BaseModel):
    name: str
    description: str
    category: str
    platform: str
    evidence_url: str
    velocity: int

@router.get("/", response_model=List[TrendResponse])
async def get_trends(
    category: Optional[str] = None,
    platform: Optional[str] = None,
    status: Optional[str] = None,
    limit: int = Query(50, le=100),
    offset: int = Query(0, ge=0)
):
    """Get all trends with optional filtering"""
    # TODO: Implement database query with filters
    # For now, return mock data
    return []

@router.get("/feed", response_model=List[TrendResponse])
async def get_trend_feed(
    limit: int = Query(20, le=50),
    offset: int = Query(0, ge=0)
):
    """Get personalized trend feed"""
    # TODO: Implement personalized feed based on user preferences
    return []

@router.get("/{trend_id}", response_model=TrendResponse)
async def get_trend(trend_id: int):
    """Get specific trend details"""
    # TODO: Implement database query
    raise HTTPException(status_code=404, detail="Trend not found")

@router.post("/submit")
async def submit_trend(request: TrendSubmitRequest):
    """Submit a new trend for validation"""
    # TODO: Implement contract interaction to submit trend
    return {"message": "Trend submitted for validation", "trend_id": 0}

@router.get("/scrape/now")
async def scrape_trends_now():
    """Manually trigger trend scraping (admin only)"""
    scraper = TrendScraperService()
    try:
        trends = await scraper.scrape_all()
        trends = await scraper.calculate_cross_platform_correlation(trends)
        return {
            "message": f"Scraped {len(trends)} trends",
            "trends": trends[:10]  # Return first 10 for preview
        }
    finally:
        await scraper.close()
