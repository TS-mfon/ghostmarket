from fastapi import APIRouter
from typing import List
from pydantic import BaseModel

router = APIRouter()

class PredictionRequest(BaseModel):
    trend_id: int
    prediction_type: str
    confidence: int
    timeframe_days: int

@router.post("/")
async def create_prediction(request: PredictionRequest):
    return {"message": "Prediction created", "prediction_id": 0}

@router.get("/user/{user_address}")
async def get_user_predictions(user_address: str):
    return []

@router.get("/trend/{trend_id}")
async def get_trend_predictions(trend_id: int):
    return []
