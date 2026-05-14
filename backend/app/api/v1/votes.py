from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class VoteRequest(BaseModel):
    trend_id: int
    vote_type: str

@router.post("/")
async def vote_on_trend(request: VoteRequest):
    return {"message": "Vote recorded"}

@router.get("/trend/{trend_id}")
async def get_trend_votes(trend_id: int):
    return {"votes_up": 0, "votes_down": 0}
