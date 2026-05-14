from fastapi import APIRouter

router = APIRouter()

@router.get("/trend/{trend_id}/timeline")
async def get_trend_timeline(trend_id: int):
    return {"data": []}

@router.get("/heatmap")
async def get_heatmap(category: str = None):
    return {"data": []}

@router.get("/velocity")
async def get_velocity_chart():
    return {"data": []}
