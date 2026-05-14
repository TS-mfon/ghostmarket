from typing import List, Dict, Any
import httpx
from app.core.config import settings

class NotificationService:
    def __init__(self):
        self.app_id = settings.ONESIGNAL_APP_ID
        self.api_key = settings.ONESIGNAL_API_KEY
        self.base_url = "https://onesignal.com/api/v1"

    async def send_notification(
        self,
        user_ids: List[str],
        title: str,
        message: str,
        data: Dict[str, Any] = None
    ):
        """Send push notification via OneSignal"""
        async with httpx.AsyncClient() as client:
            payload = {
                "app_id": self.app_id,
                "include_external_user_ids": user_ids,
                "headings": {"en": title},
                "contents": {"en": message},
                "data": data or {}
            }
            headers = {
                "Authorization": f"Basic {self.api_key}",
                "Content-Type": "application/json"
            }
            response = await client.post(
                f"{self.base_url}/notifications",
                json=payload,
                headers=headers
            )
            return response.json()

    async def notify_new_trend(self, user_id: str, trend_name: str, category: str):
        """Notify user about new trend in their category"""
        await self.send_notification(
            [user_id],
            "🔥 New Trend Alert",
            f"New {category} trend detected: {trend_name}",
            {"type": "new_trend", "category": category}
        )

    async def notify_prediction_resolved(
        self, user_id: str, trend_name: str, outcome: str, reward: float
    ):
        """Notify user about prediction outcome"""
        emoji = "🎉" if outcome == "correct" else "😔"
        await self.send_notification(
            [user_id],
            f"{emoji} Prediction Resolved",
            f"Your prediction on {trend_name} was {outcome}. Reward: {reward} GHOST",
            {"type": "prediction_resolved", "outcome": outcome}
        )

    async def notify_war_room_activity(self, user_ids: List[str], room_name: str, activity: str):
        """Notify war room members about activity"""
        await self.send_notification(
            user_ids,
            "💬 War Room Activity",
            f"New activity in {room_name}: {activity}",
            {"type": "war_room_activity"}
        )

    async def notify_reputation_milestone(self, user_id: str, new_tier: str, reputation: int):
        """Notify user about reputation milestone"""
        await self.send_notification(
            [user_id],
            "🏆 Reputation Milestone",
            f"Congratulations! You've reached {new_tier} tier with {reputation} reputation",
            {"type": "reputation_milestone", "tier": new_tier}
        )
