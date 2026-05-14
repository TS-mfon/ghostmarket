from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class WarRoomRequest(BaseModel):
    trend_id: int
    name: str
    access_type: str
    stake_requirement: int = 0

@router.post("/")
async def create_war_room(request: WarRoomRequest):
    return {"war_room_id": 0}

@router.post("/{war_room_id}/join")
async def join_war_room(war_room_id: int):
    return {"message": "Joined war room"}

@router.post("/{war_room_id}/comments")
async def post_comment(war_room_id: int, content: str):
    return {"comment_id": 0}

@router.get("/{war_room_id}/comments")
async def get_comments(war_room_id: int):
    return []
