-- Enable pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    address VARCHAR(66) UNIQUE NOT NULL,
    username VARCHAR(50),
    email VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Trends table
CREATE TABLE trends (
    id SERIAL PRIMARY KEY,
    contract_trend_id INTEGER UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL,
    platform VARCHAR(50) NOT NULL,
    evidence_url TEXT NOT NULL,
    velocity INTEGER NOT NULL,
    confidence INTEGER NOT NULL,
    status VARCHAR(20) NOT NULL,
    validated BOOLEAN DEFAULT FALSE,
    votes_up INTEGER DEFAULT 0,
    votes_down INTEGER DEFAULT 0,
    embedding vector(1536),  -- For similarity search
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Predictions table
CREATE TABLE predictions (
    id SERIAL PRIMARY KEY,
    contract_prediction_id INTEGER UNIQUE NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    trend_id INTEGER REFERENCES trends(id) ON DELETE CASCADE,
    prediction_type VARCHAR(10) NOT NULL,
    confidence INTEGER NOT NULL,
    stake_amount DECIMAL(18, 8) NOT NULL,
    timeframe_days INTEGER NOT NULL,
    resolved BOOLEAN DEFAULT FALSE,
    outcome VARCHAR(20) DEFAULT 'pending',
    reward DECIMAL(18, 8) DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- War rooms table
CREATE TABLE war_rooms (
    id SERIAL PRIMARY KEY,
    contract_war_room_id INTEGER UNIQUE NOT NULL,
    trend_id INTEGER REFERENCES trends(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL,
    access_type VARCHAR(20) NOT NULL,
    stake_requirement INTEGER DEFAULT 0,
    member_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- War room members table
CREATE TABLE war_room_members (
    id SERIAL PRIMARY KEY,
    war_room_id INTEGER REFERENCES war_rooms(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(war_room_id, user_id)
);

-- Comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    contract_comment_id INTEGER UNIQUE NOT NULL,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    trend_id INTEGER REFERENCES trends(id) ON DELETE CASCADE,
    war_room_id INTEGER REFERENCES war_rooms(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    parent_id INTEGER REFERENCES comments(id) ON DELETE CASCADE,
    votes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Votes table
CREATE TABLE votes (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    trend_id INTEGER REFERENCES trends(id) ON DELETE CASCADE,
    vote_type VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, trend_id)
);

-- Notifications table
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    read BOOLEAN DEFAULT FALSE,
    data JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Analytics events table
CREATE TABLE analytics_events (
    id SERIAL PRIMARY KEY,
    trend_id INTEGER REFERENCES trends(id) ON DELETE CASCADE,
    event_type VARCHAR(50) NOT NULL,
    value INTEGER,
    metadata JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for performance
CREATE INDEX idx_trends_category ON trends(category);
CREATE INDEX idx_trends_platform ON trends(platform);
CREATE INDEX idx_trends_status ON trends(status);
CREATE INDEX idx_trends_created_at ON trends(created_at DESC);
CREATE INDEX idx_trends_velocity ON trends(velocity DESC);
CREATE INDEX idx_trends_embedding ON trends USING ivfflat (embedding vector_cosine_ops);

CREATE INDEX idx_predictions_user_id ON predictions(user_id);
CREATE INDEX idx_predictions_trend_id ON predictions(trend_id);
CREATE INDEX idx_predictions_resolved ON predictions(resolved);
CREATE INDEX idx_predictions_created_at ON predictions(created_at DESC);

CREATE INDEX idx_war_rooms_trend_id ON war_rooms(trend_id);
CREATE INDEX idx_war_room_members_user_id ON war_room_members(user_id);

CREATE INDEX idx_comments_trend_id ON comments(trend_id);
CREATE INDEX idx_comments_war_room_id ON comments(war_room_id);
CREATE INDEX idx_comments_parent_id ON comments(parent_id);

CREATE INDEX idx_votes_user_id ON votes(user_id);
CREATE INDEX idx_votes_trend_id ON votes(trend_id);

CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_read ON notifications(read);

CREATE INDEX idx_analytics_events_trend_id ON analytics_events(trend_id);
CREATE INDEX idx_analytics_events_created_at ON analytics_events(created_at DESC);
