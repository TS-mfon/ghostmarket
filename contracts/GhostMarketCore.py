# { "Depends": "py-genlayer:latest" }

from genlayer import *
from dataclasses import dataclass

@allow_storage
@dataclass
class Trend:
    id: u256
    name: str
    description: str
    category: str  # crypto, tech, startup, meme, ai
    platform: str  # hackernews, coingecko, github
    evidence_url: str
    velocity: u256  # momentum score 0-100
    confidence: u256  # AI confidence 0-100
    status: str  # early, trending, mainstream, faded
    created_at: u256
    validated: bool
    votes_up: u256
    votes_down: u256

@allow_storage
@dataclass
class Prediction:
    id: u256
    user: Address
    trend_id: u256
    prediction_type: str  # explode, fade
    confidence: u256  # 0-100
    stake_amount: u256
    timeframe_days: u256
    created_at: u256
    resolved: bool
    outcome: str  # correct, incorrect, pending
    reward: u256

@allow_storage
@dataclass
class UserReputation:
    user: Address
    score: u256
    total_predictions: u256
    correct_predictions: u256
    last_activity: u256
    tier: str  # newbie, explorer, hunter, elite

@allow_storage
@dataclass
class WarRoom:
    id: u256
    trend_id: u256
    name: str
    access_type: str  # open, staked
    stake_requirement: u256
    member_count: u256
    created_at: u256

@allow_storage
@dataclass
class Comment:
    id: u256
    user: Address
    trend_id: u256
    war_room_id: u256
    content: str
    parent_id: u256  # 0 for top-level
    votes: u256
    created_at: u256

class GhostMarketCore(gl.Contract):
    owner: Address
    trend_count: u256
    prediction_count: u256
    war_room_count: u256
    comment_count: u256
    
    trends: TreeMap[u256, Trend]
    predictions: TreeMap[u256, Prediction]
    reputations: TreeMap[Address, UserReputation]
    war_rooms: TreeMap[u256, WarRoom]
    comments: TreeMap[u256, Comment]
    
    user_predictions: TreeMap[str, DynArray[u256]]  # "user_address" -> [prediction_ids]
    trend_predictions: TreeMap[u256, DynArray[u256]]  # trend_id -> [prediction_ids]
    war_room_members: TreeMap[str, bool]  # "war_room_id:user_address" -> is_member
    user_votes: TreeMap[str, str]  # "trend_id:user_address" -> "up" or "down"

    def __init__(self):
        self.owner = gl.message.sender_address
        self.trend_count = 0
        self.prediction_count = 0
        self.war_room_count = 0
        self.comment_count = 0

    @gl.public.write
    def submit_trend(
        self,
        name: str,
        description: str,
        category: str,
        platform: str,
        evidence_url: str,
        velocity: u256
    ) -> u256:
        """Submit a new trend for validation"""
        if not name or not evidence_url:
            raise gl.UserError("Name and evidence URL required")
        
        trend_id = self.trend_count
        
        # AI validation with multi-validator consensus
        confidence = self._validate_trend_with_consensus(
            name, description, evidence_url, platform, velocity
        )
        
        # Determine status based on velocity
        status = "early"
        if velocity > 70:
            status = "trending"
        elif velocity > 90:
            status = "mainstream"
        
        self.trends[trend_id] = Trend(
            id=trend_id,
            name=name,
            description=description,
            category=category,
            platform=platform,
            evidence_url=evidence_url,
            velocity=velocity,
            confidence=confidence,
            status=status,
            created_at=gl.message.block_timestamp,
            validated=confidence > 70,
            votes_up=0,
            votes_down=0
        )
        
        self.trend_count += 1
        return trend_id

    def _validate_trend_with_consensus(
        self,
        name: str,
        description: str,
        evidence_url: str,
        platform: str,
        velocity: u256
    ) -> u256:
        """Multi-validator consensus for trend validation"""
        
        def leader_fn() -> dict:
            # Fetch evidence from URL
            evidence = gl.get_webpage(evidence_url, mode="text")
            
            prompt = f"""Analyze this trend for authenticity and momentum:

Trend: {name}
Description: {description}
Platform: {platform}
Reported Velocity: {velocity}

Evidence from {evidence_url}:
{evidence[:2000]}

Evaluate:
1. Is this trend authentic (not fake/manipulated)?
2. Does the evidence support the velocity claim?
3. Is there genuine momentum?

Return JSON with:
- confidence: 0-100 (how confident this is a real trend)
- authentic: boolean
- reasoning: brief explanation
"""
            
            result = gl.nondet.exec_prompt(prompt, response_format="json")
            
            if not isinstance(result, dict):
                raise gl.UserError("Invalid AI response")
            
            confidence = int(result.get("confidence", 0))
            authentic = bool(result.get("authentic", False))
            
            if not authentic:
                confidence = min(confidence, 30)
            
            return {
                "confidence": max(0, min(100, confidence)),
                "authentic": authentic,
                "reasoning": str(result.get("reasoning", ""))[:500]
            }
        
        def validator_fn(leaders_res: gl.vm.Result) -> bool:
            if not isinstance(leaders_res, gl.vm.Return):
                return False
            
            try:
                candidate = leader_fn()
            except Exception:
                return False
            
            leader = leaders_res.calldata
            
            # Validators agree if confidence scores are within 20 points
            leader_conf = int(leader.get("confidence", 0))
            candidate_conf = int(candidate.get("confidence", 0))
            
            return abs(leader_conf - candidate_conf) <= 20
        
        result = gl.vm.run_nondet_unsafe(leader_fn, validator_fn)
        return result["confidence"]

    @gl.public.write
    def create_prediction(
        self,
        trend_id: u256,
        prediction_type: str,
        confidence: u256,
        timeframe_days: u256
    ) -> u256:
        """Create a prediction on a trend"""
        if trend_id >= self.trend_count:
            raise gl.UserError("Trend does not exist")
        
        if prediction_type not in ["explode", "fade"]:
            raise gl.UserError("Invalid prediction type")
        
        if confidence > 100:
            raise gl.UserError("Confidence must be 0-100")
        
        if timeframe_days == 0 or timeframe_days > 90:
            raise gl.UserError("Timeframe must be 1-90 days")
        
        user = gl.message.sender_address
        prediction_id = self.prediction_count
        
        # Calculate stake based on confidence (higher confidence = higher stake)
        stake_amount = (confidence * 10) // 100  # 0-10 tokens
        
        self.predictions[prediction_id] = Prediction(
            id=prediction_id,
            user=user,
            trend_id=trend_id,
            prediction_type=prediction_type,
            confidence=confidence,
            stake_amount=stake_amount,
            timeframe_days=timeframe_days,
            created_at=gl.message.block_timestamp,
            resolved=False,
            outcome="pending",
            reward=0
        )
        
        # Track user predictions
        user_key = str(user)
        if user_key not in self.user_predictions:
            self.user_predictions[user_key] = DynArray[u256]()
        self.user_predictions[user_key].append(prediction_id)
        
        # Track trend predictions
        if trend_id not in self.trend_predictions:
            self.trend_predictions[trend_id] = DynArray[u256]()
        self.trend_predictions[trend_id].append(prediction_id)
        
        self.prediction_count += 1
        
        # Initialize reputation if needed
        if user not in self.reputations:
            self.reputations[user] = UserReputation(
                user=user,
                score=0,
                total_predictions=0,
                correct_predictions=0,
                last_activity=gl.message.block_timestamp,
                tier="newbie"
            )
        
        # Update reputation activity
        rep = self.reputations[user]
        rep.total_predictions += 1
        rep.last_activity = gl.message.block_timestamp
        self.reputations[user] = rep
        
        return prediction_id

    @gl.public.write
    def resolve_prediction(self, prediction_id: u256) -> dict:
        """Resolve a prediction and distribute rewards"""
        if prediction_id >= self.prediction_count:
            raise gl.UserError("[EXPECTED] Prediction does not exist")
        
        prediction = self.predictions[prediction_id]
        
        if prediction.resolved:
            raise gl.UserError("[EXPECTED] Prediction already resolved")
        
        # Check if timeframe has elapsed
        elapsed_days = (gl.message.block_timestamp - prediction.created_at) // 86400
        if elapsed_days < prediction.timeframe_days:
            raise gl.UserError("[EXPECTED] Timeframe not elapsed")
        
        trend = self.trends[prediction.trend_id]
        
        # Determine outcome with AI consensus
        outcome_data = self._check_prediction_outcome(
            trend.name,
            trend.evidence_url,
            prediction.prediction_type,
            trend.velocity
        )
        
        is_correct = outcome_data["correct"]
        
        # Calculate reward
        reward = 0
        if is_correct:
            base_reward = prediction.stake_amount * 2
            confidence_multiplier = (prediction.confidence * 15) // 1000
            timeframe_multiplier = 10 if prediction.timeframe_days <= 7 else 5
            reward = (base_reward * (10 + confidence_multiplier)) // timeframe_multiplier
        
        # Update prediction
        prediction.resolved = True
        prediction.outcome = "correct" if is_correct else "incorrect"
        prediction.reward = reward
        self.predictions[prediction_id] = prediction
        
        # Update reputation
        rep = self.reputations[prediction.user]
        if is_correct:
            rep.correct_predictions += 1
            rep.score += reward
        else:
            rep.score = max(0, rep.score - (prediction.stake_amount // 2))
        
        # Update tier
        win_rate = (rep.correct_predictions * 100) // max(1, rep.total_predictions)
        if rep.score >= 1000 and win_rate >= 70:
            rep.tier = "elite"
        elif rep.score >= 500 and win_rate >= 60:
            rep.tier = "hunter"
        elif rep.score >= 100:
            rep.tier = "explorer"
        else:
            rep.tier = "newbie"
        
        self.reputations[prediction.user] = rep
        
        return {
            "outcome": prediction.outcome,
            "reward": reward,
            "new_reputation": rep.score
        }
    
    def _check_prediction_outcome(
        self,
        trend_name: str,
        evidence_url: str,
        prediction_type: str,
        initial_velocity: u256
    ) -> dict:
        """Check if prediction was correct using AI consensus"""
        
        ERROR_LLM = "[LLM_ERROR]"
        ERROR_TRANSIENT = "[TRANSIENT]"
        
        def leader_fn() -> dict:
            try:
                current_evidence = gl.get_webpage(evidence_url, mode="text")
            except Exception as e:
                raise gl.UserError(f"{ERROR_TRANSIENT} Failed to fetch evidence: {str(e)}")
            
            prompt = f"""Evaluate if this trend prediction was correct:

Trend: {trend_name}
Initial Velocity: {initial_velocity}
Prediction: Will {prediction_type}

Current Evidence:
{current_evidence[:2000]}

Did the trend {prediction_type}? 
- "explode" means significant growth/adoption
- "fade" means decline/loss of interest

Return JSON with:
- correct: boolean (was prediction accurate?)
- current_velocity: 0-100 (current momentum)
- reasoning: brief explanation
"""
            
            result = gl.nondet.exec_prompt(prompt, response_format="json")
            
            if not isinstance(result, dict):
                raise gl.UserError(f"{ERROR_LLM} Non-dict response")
            
            correct = result.get("correct")
            if not isinstance(correct, bool):
                raise gl.UserError(f"{ERROR_LLM} Missing or invalid 'correct' field")
            
            current_velocity = result.get("current_velocity", 50)
            try:
                current_velocity = max(0, min(100, int(current_velocity)))
            except (ValueError, TypeError):
                current_velocity = 50
            
            return {
                "correct": correct,
                "current_velocity": current_velocity,
                "reasoning": str(result.get("reasoning", ""))[:500]
            }
        
        def validator_fn(leaders_res: gl.vm.Result) -> bool:
            leader_msg = leaders_res.message if hasattr(leaders_res, 'message') else ''
            
            if not isinstance(leaders_res, gl.vm.Return):
                try:
                    leader_fn()
                    return False
                except gl.UserError as e:
                    validator_msg = str(e)
                    if validator_msg.startswith(ERROR_TRANSIENT) and leader_msg.startswith(ERROR_TRANSIENT):
                        return True
                    return False
                except Exception:
                    return False
            
            try:
                candidate = leader_fn()
            except Exception:
                return False
            
            leader = leaders_res.calldata
            
            # Must agree on correctness
            if leader.get("correct") != candidate.get("correct"):
                return False
            
            # Velocity should be within 25 points
            leader_vel = int(leader.get("current_velocity", 50))
            candidate_vel = int(candidate.get("current_velocity", 50))
            
            return abs(leader_vel - candidate_vel) <= 25
        
        return gl.vm.run_nondet_unsafe(leader_fn, validator_fn)

    @gl.public.write
    def vote_on_trend(self, trend_id: u256, vote_type: str):
        """Vote on a trend (upvote/downvote)"""
        if trend_id >= self.trend_count:
            raise gl.UserError("Trend does not exist")
        
        if vote_type not in ["up", "down"]:
            raise gl.UserError("Invalid vote type")
        
        user = gl.message.sender_address
        vote_key = f"{trend_id}:{user}"
        
        # Check if already voted
        if vote_key in self.user_votes:
            raise gl.UserError("Already voted on this trend")
        
        self.user_votes[vote_key] = vote_type
        
        trend = self.trends[trend_id]
        if vote_type == "up":
            trend.votes_up += 1
        else:
            trend.votes_down += 1
        self.trends[trend_id] = trend

    @gl.public.write
    def create_war_room(
        self,
        trend_id: u256,
        name: str,
        access_type: str,
        stake_requirement: u256
    ) -> u256:
        """Create a war room for trend discussion"""
        if trend_id >= self.trend_count:
            raise gl.UserError("Trend does not exist")
        
        if access_type not in ["open", "staked"]:
            raise gl.UserError("Invalid access type")
        
        war_room_id = self.war_room_count
        
        self.war_rooms[war_room_id] = WarRoom(
            id=war_room_id,
            trend_id=trend_id,
            name=name,
            access_type=access_type,
            stake_requirement=stake_requirement,
            member_count=1,
            created_at=gl.message.block_timestamp
        )
        
        # Creator automatically joins
        member_key = f"{war_room_id}:{gl.message.sender_address}"
        self.war_room_members[member_key] = True
        
        self.war_room_count += 1
        return war_room_id

    @gl.public.write
    def join_war_room(self, war_room_id: u256):
        """Join a war room"""
        if war_room_id >= self.war_room_count:
            raise gl.UserError("War room does not exist")
        
        user = gl.message.sender_address
        member_key = f"{war_room_id}:{user}"
        
        if member_key in self.war_room_members:
            raise gl.UserError("Already a member")
        
        war_room = self.war_rooms[war_room_id]
        
        # Check access requirements
        if war_room.access_type == "staked":
            if user not in self.reputations:
                raise gl.UserError("Insufficient reputation")
            
            rep = self.reputations[user]
            if rep.score < war_room.stake_requirement:
                raise gl.UserError("Insufficient reputation to join")
        
        self.war_room_members[member_key] = True
        war_room.member_count += 1
        self.war_rooms[war_room_id] = war_room

    @gl.public.write
    def add_comment(
        self,
        trend_id: u256,
        war_room_id: u256,
        content: str,
        parent_id: u256
    ) -> u256:
        """Add a comment to a trend or war room"""
        if trend_id >= self.trend_count:
            raise gl.UserError("Trend does not exist")
        
        if war_room_id > 0 and war_room_id >= self.war_room_count:
            raise gl.UserError("War room does not exist")
        
        # Check war room membership if applicable
        if war_room_id > 0:
            member_key = f"{war_room_id}:{gl.message.sender_address}"
            if member_key not in self.war_room_members:
                raise gl.UserError("Not a war room member")
        
        comment_id = self.comment_count
        
        self.comments[comment_id] = Comment(
            id=comment_id,
            user=gl.message.sender_address,
            trend_id=trend_id,
            war_room_id=war_room_id,
            content=content[:1000],  # Limit length
            parent_id=parent_id,
            votes=0,
            created_at=gl.message.block_timestamp
        )
        
        self.comment_count += 1
        return comment_id

    @gl.public.view
    def get_trend(self, trend_id: u256) -> dict:
        """Get trend details"""
        if trend_id >= self.trend_count:
            raise gl.UserError("Trend does not exist")
        
        trend = self.trends[trend_id]
        return {
            "id": trend.id,
            "name": trend.name,
            "description": trend.description,
            "category": trend.category,
            "platform": trend.platform,
            "velocity": trend.velocity,
            "confidence": trend.confidence,
            "status": trend.status,
            "validated": trend.validated,
            "votes_up": trend.votes_up,
            "votes_down": trend.votes_down,
            "created_at": trend.created_at
        }

    @gl.public.view
    def get_all_trends(self) -> list:
        """Get all trends"""
        result = []
        for i in range(self.trend_count):
            trend = self.trends[i]
            result.append({
                "id": trend.id,
                "name": trend.name,
                "category": trend.category,
                "velocity": trend.velocity,
                "confidence": trend.confidence,
                "status": trend.status,
                "validated": trend.validated
            })
        return result

    @gl.public.view
    def get_user_predictions(self, user: Address) -> list:
        """Get all predictions for a user"""
        user_key = str(user)
        if user_key not in self.user_predictions:
            return []
        
        result = []
        for pred_id in self.user_predictions[user_key]:
            pred = self.predictions[pred_id]
            result.append({
                "id": pred.id,
                "trend_id": pred.trend_id,
                "prediction_type": pred.prediction_type,
                "confidence": pred.confidence,
                "stake_amount": pred.stake_amount,
                "outcome": pred.outcome,
                "reward": pred.reward
            })
        return result

    @gl.public.view
    def get_user_reputation(self, user: Address) -> dict:
        """Get user reputation"""
        if user not in self.reputations:
            return {
                "score": 0,
                "total_predictions": 0,
                "correct_predictions": 0,
                "tier": "newbie"
            }
        
        rep = self.reputations[user]
        return {
            "score": rep.score,
            "total_predictions": rep.total_predictions,
            "correct_predictions": rep.correct_predictions,
            "tier": rep.tier,
            "last_activity": rep.last_activity
        }

    @gl.public.view
    def get_war_room(self, war_room_id: u256) -> dict:
        """Get war room details"""
        if war_room_id >= self.war_room_count:
            raise gl.UserError("War room does not exist")
        
        wr = self.war_rooms[war_room_id]
        return {
            "id": wr.id,
            "trend_id": wr.trend_id,
            "name": wr.name,
            "access_type": wr.access_type,
            "stake_requirement": wr.stake_requirement,
            "member_count": wr.member_count
        }
