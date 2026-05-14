from pydantic_settings import BaseSettings
from typing import List

class Settings(BaseSettings):
    # Database
    DATABASE_URL: str = "postgresql://ghostmarket:ghostmarket_dev@localhost:5432/ghostmarket"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # GenLayer
    GENLAYER_RPC_URL: str = "https://testnet-rpc.genlayer.com"
    GENLAYER_CONTRACT_ADDRESS: str = ""
    
    # JWT
    JWT_SECRET: str = "dev_secret_change_in_production"
    JWT_ALGORITHM: str = "HS256"
    JWT_EXPIRATION_HOURS: int = 24
    
    # API Keys
    CRYPTORANK_API_KEY: str = ""
    ONESIGNAL_APP_ID: str = ""
    ONESIGNAL_API_KEY: str = ""
    
    # CORS
    CORS_ORIGINS: List[str] = [
        "http://localhost:3000",
        "http://localhost:3001",
        "https://ghostmarket.vercel.app"
    ]
    
    # Rate Limiting
    RATE_LIMIT_PER_MINUTE: int = 60
    
    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()
