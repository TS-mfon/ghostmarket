from datetime import datetime, timedelta
from typing import List, Dict, Any
import asyncpg

class AnalyticsService:
    def __init__(self, db_pool: asyncpg.Pool):
        self.db = db_pool

    async def get_trend_timeline(self, trend_id: int, days: int = 30) -> List[Dict[str, Any]]:
        """Get trend evolution over time"""
        query = """
            SELECT 
                DATE(created_at) as date,
                AVG(velocity) as avg_velocity,
                COUNT(*) as data_points
            FROM trends
            WHERE id = $1 AND created_at >= NOW() - INTERVAL '%s days'
            GROUP BY DATE(created_at)
            ORDER BY date
        """
        rows = await self.db.fetch(query, trend_id, days)
        return [dict(row) for row in rows]

    async def get_category_heatmap(self) -> List[Dict[str, Any]]:
        """Get trend distribution by category"""
        query = """
            SELECT 
                category,
                COUNT(*) as count,
                AVG(velocity) as avg_velocity,
                AVG(confidence) as avg_confidence
            FROM trends
            WHERE created_at >= NOW() - INTERVAL '7 days'
            GROUP BY category
            ORDER BY count DESC
        """
        rows = await self.db.fetch(query)
        return [dict(row) for row in rows]

    async def get_velocity_chart(self, trend_id: int, hours: int = 24) -> List[Dict[str, Any]]:
        """Get real-time velocity changes"""
        query = """
            SELECT 
                DATE_TRUNC('hour', created_at) as hour,
                AVG(velocity) as velocity
            FROM trends
            WHERE id = $1 AND created_at >= NOW() - INTERVAL '%s hours'
            GROUP BY hour
            ORDER BY hour
        """
        rows = await self.db.fetch(query, trend_id, hours)
        return [dict(row) for row in rows]

    async def get_platform_stats(self) -> List[Dict[str, Any]]:
        """Get stats by platform"""
        query = """
            SELECT 
                platform,
                COUNT(*) as total_trends,
                AVG(velocity) as avg_velocity
            FROM trends
            GROUP BY platform
        """
        rows = await self.db.fetch(query)
        return [dict(row) for row in rows]
