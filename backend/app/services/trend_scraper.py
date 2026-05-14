import httpx
import asyncio
from typing import List, Dict
from datetime import datetime, timedelta

class TrendScraperService:
    """Service to scrape trends from public APIs"""
    
    def __init__(self):
        self.client = httpx.AsyncClient(timeout=30.0)
        self.cache = {}
        self.cache_ttl = 300  # 5 minutes
    
    async def scrape_all(self) -> List[Dict]:
        """Scrape trends from all sources"""
        results = await asyncio.gather(
            self.scrape_hackernews(),
            self.scrape_coingecko(),
            self.scrape_github_trending(),
            return_exceptions=True
        )
        
        trends = []
        for result in results:
            if isinstance(result, list):
                trends.extend(result)
        
        return trends
    
    async def scrape_hackernews(self) -> List[Dict]:
        """Scrape trending stories from Hacker News"""
        try:
            # Get top stories
            response = await self.client.get(
                "https://hacker-news.firebaseio.com/v0/topstories.json"
            )
            story_ids = response.json()[:30]  # Top 30 stories
            
            # Fetch story details
            stories = []
            for story_id in story_ids[:10]:  # Limit to 10 for now
                story_response = await self.client.get(
                    f"https://hacker-news.firebaseio.com/v0/item/{story_id}.json"
                )
                story = story_response.json()
                
                if story and story.get("type") == "story":
                    # Calculate velocity based on score and time
                    score = story.get("score", 0)
                    time_posted = story.get("time", 0)
                    hours_old = (datetime.now().timestamp() - time_posted) / 3600
                    
                    # Velocity: score per hour, normalized to 0-100
                    velocity = min(100, int((score / max(hours_old, 1)) * 2))
                    
                    stories.append({
                        "name": story.get("title", "")[:255],
                        "description": f"HN Score: {score}, Comments: {story.get('descendants', 0)}",
                        "category": "tech",
                        "platform": "hackernews",
                        "evidence_url": story.get("url", f"https://news.ycombinator.com/item?id={story_id}"),
                        "velocity": velocity,
                        "raw_data": {
                            "score": score,
                            "comments": story.get("descendants", 0),
                            "author": story.get("by", ""),
                            "time": time_posted
                        }
                    })
            
            return stories
        except Exception as e:
            print(f"Error scraping Hacker News: {e}")
            return []
    
    async def scrape_coingecko(self) -> List[Dict]:
        """Scrape trending coins from CoinGecko"""
        try:
            # Get trending coins (no API key needed for this endpoint)
            response = await self.client.get(
                "https://api.coingecko.com/api/v3/search/trending"
            )
            data = response.json()
            
            trends = []
            for item in data.get("coins", [])[:10]:
                coin = item.get("item", {})
                
                # Calculate velocity based on market cap rank and price change
                rank = coin.get("market_cap_rank", 1000)
                velocity = max(0, min(100, int((1000 - rank) / 10)))
                
                trends.append({
                    "name": coin.get("name", ""),
                    "description": f"Symbol: {coin.get('symbol', '')}, Rank: #{rank}",
                    "category": "crypto",
                    "platform": "coingecko",
                    "evidence_url": f"https://www.coingecko.com/en/coins/{coin.get('id', '')}",
                    "velocity": velocity,
                    "raw_data": {
                        "symbol": coin.get("symbol", ""),
                        "rank": rank,
                        "price_btc": coin.get("price_btc", 0),
                        "score": coin.get("score", 0)
                    }
                })
            
            return trends
        except Exception as e:
            print(f"Error scraping CoinGecko: {e}")
            return []
    
    async def scrape_github_trending(self) -> List[Dict]:
        """Scrape trending repositories from GitHub"""
        try:
            # Using a public GitHub trending API
            response = await self.client.get(
                "https://api.github.com/search/repositories",
                params={
                    "q": "created:>2024-01-01",
                    "sort": "stars",
                    "order": "desc",
                    "per_page": 10
                }
            )
            data = response.json()
            
            trends = []
            for repo in data.get("items", []):
                stars = repo.get("stargazers_count", 0)
                created_at = datetime.fromisoformat(repo.get("created_at", "").replace("Z", "+00:00"))
                days_old = (datetime.now(created_at.tzinfo) - created_at).days
                
                # Velocity: stars per day, normalized to 0-100
                velocity = min(100, int((stars / max(days_old, 1)) / 10))
                
                trends.append({
                    "name": repo.get("full_name", ""),
                    "description": repo.get("description", "")[:500],
                    "category": "tech",
                    "platform": "github",
                    "evidence_url": repo.get("html_url", ""),
                    "velocity": velocity,
                    "raw_data": {
                        "stars": stars,
                        "forks": repo.get("forks_count", 0),
                        "language": repo.get("language", ""),
                        "created_at": repo.get("created_at", "")
                    }
                })
            
            return trends
        except Exception as e:
            print(f"Error scraping GitHub: {e}")
            return []
    
    async def calculate_cross_platform_correlation(self, trends: List[Dict]) -> List[Dict]:
        """Calculate correlation between trends across platforms"""
        # Group trends by similar names/topics
        trend_groups = {}
        
        for trend in trends:
            name_lower = trend["name"].lower()
            words = set(name_lower.split())
            
            # Find matching group
            matched = False
            for group_key, group_trends in trend_groups.items():
                group_words = set(group_key.split())
                # If 2+ words match, consider it the same trend
                if len(words & group_words) >= 2:
                    group_trends.append(trend)
                    matched = True
                    break
            
            if not matched:
                trend_groups[name_lower] = [trend]
        
        # Boost velocity for trends appearing on multiple platforms
        for group_trends in trend_groups.values():
            if len(group_trends) > 1:
                boost = min(30, len(group_trends) * 10)
                for trend in group_trends:
                    trend["velocity"] = min(100, trend["velocity"] + boost)
                    trend["cross_platform"] = True
        
        return trends
    
    async def close(self):
        """Close the HTTP client"""
        await self.client.aclose()
