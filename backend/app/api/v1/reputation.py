from fastapi import APIRouter

router = APIRouter()

@router.get("/user/{user_address}")
async def get_user_reputation(user_address: str):
    return {"score": 0, "tier": "newbie"}

@router.get("/leaderboard")
async def get_leaderboard(limit: int = 50):
    return []
