import pytest
from genlayer.py.testing import VMContext
from contracts.GhostMarketCore import GhostMarketCore

@pytest.fixture
def vm():
    return VMContext()

@pytest.fixture
def contract(vm):
    return GhostMarketCore()

def test_submit_trend(contract, vm):
    """Test trend submission"""
    vm.mock_web_response("https://news.ycombinator.com/item?id=123", "AI coding tools discussion")
    vm.mock_llm_response({"confidence": 85, "authentic": True, "reasoning": "Strong evidence"})
    
    trend_id = contract.submit_trend(
        "AI Coding Assistants",
        "New wave of AI coding tools",
        "tech",
        "hackernews",
        "https://news.ycombinator.com/item?id=123",
        75
    )
    
    assert trend_id == 0
    assert contract.trend_count == 1
    trend = contract.trends[0]
    assert trend.name == "AI Coding Assistants"
    assert trend.validated == True

def test_create_prediction(contract, vm):
    """Test prediction creation"""
    vm.mock_web_response("https://news.ycombinator.com/item?id=123", "AI coding tools")
    vm.mock_llm_response({"confidence": 85, "authentic": True, "reasoning": "Valid"})
    
    trend_id = contract.submit_trend("AI Tools", "Description", "tech", "hackernews", "https://news.ycombinator.com/item?id=123", 75)
    
    vm.set_sender("0x1234567890123456789012345678901234567890")
    prediction_id = contract.create_prediction(trend_id, "explode", 80, 7)
    
    assert prediction_id == 0
    assert contract.prediction_count == 1
    prediction = contract.predictions[0]
    assert prediction.prediction_type == "explode"
    assert prediction.confidence == 80
    assert prediction.stake_amount == 8

def test_vote_on_trend(contract, vm):
    """Test voting on trends"""
    vm.mock_web_response("https://news.ycombinator.com/item?id=123", "AI coding tools")
    vm.mock_llm_response({"confidence": 85, "authentic": True, "reasoning": "Valid"})
    
    trend_id = contract.submit_trend("AI Tools", "Description", "tech", "hackernews", "https://news.ycombinator.com/item?id=123", 75)
    
    vm.set_sender("0x1234567890123456789012345678901234567890")
    contract.vote_on_trend(trend_id, "up")
    
    trend = contract.trends[trend_id]
    assert trend.votes_up == 1
    assert trend.votes_down == 0

def test_create_war_room(contract, vm):
    """Test war room creation"""
    vm.mock_web_response("https://news.ycombinator.com/item?id=123", "AI coding tools")
    vm.mock_llm_response({"confidence": 85, "authentic": True, "reasoning": "Valid"})
    
    trend_id = contract.submit_trend("AI Tools", "Description", "tech", "hackernews", "https://news.ycombinator.com/item?id=123", 75)
    
    war_room_id = contract.create_war_room(trend_id, "AI Discussion", "open", 0)
    
    assert war_room_id == 0
    assert contract.war_room_count == 1
    war_room = contract.war_rooms[0]
    assert war_room.name == "AI Discussion"
    assert war_room.access_type == "open"

def test_reputation_tracking(contract, vm):
    """Test reputation system"""
    vm.mock_web_response("https://news.ycombinator.com/item?id=123", "AI coding tools")
    vm.mock_llm_response({"confidence": 85, "authentic": True, "reasoning": "Valid"})
    
    trend_id = contract.submit_trend("AI Tools", "Description", "tech", "hackernews", "https://news.ycombinator.com/item?id=123", 75)
    
    user = "0x1234567890123456789012345678901234567890"
    vm.set_sender(user)
    contract.create_prediction(trend_id, "explode", 80, 7)
    
    rep = contract.reputations[user]
    assert rep.total_predictions == 1
    assert rep.tier == "newbie"
