import pytest
from httpx import AsyncClient
from app.main import app

@pytest.mark.asyncio
async def test_get_trends():
    """Test getting trends from API"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/api/v1/trends/")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)

@pytest.mark.asyncio
async def test_create_trend():
    """Test creating a trend"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        payload = {
            "name": "Test Trend",
            "description": "Test description",
            "category": "tech",
            "platform": "hackernews",
            "evidence_url": "https://example.com",
            "velocity": 75
        }
        response = await client.post("/api/v1/trends/", json=payload)
        assert response.status_code in [200, 201]

@pytest.mark.asyncio
async def test_get_reputation():
    """Test getting user reputation"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/api/v1/reputation/0x1234567890123456789012345678901234567890")
        assert response.status_code in [200, 404]

@pytest.mark.asyncio
async def test_leaderboard():
    """Test getting leaderboard"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        response = await client.get("/api/v1/reputation/leaderboard")
        assert response.status_code == 200
        data = response.json()
        assert isinstance(data, list)
