# { "Depends": "py-genlayer:latest" }

from genlayer import *
from dataclasses import dataclass

@allow_storage
@dataclass
class StakeInfo:
    user: Address
    amount: u256
    staked_at: u256
    rewards: u256

@allow_storage
@dataclass
class Proposal:
    id: u256
    proposer: Address
    title: str
    description: str
    votes_for: u256
    votes_against: u256
    executed: bool
    created_at: u256

class GHOSTToken(gl.Contract):
    name: str
    symbol: str
    total_supply: u256
    owner: Address
    
    balances: TreeMap[Address, u256]
    stakes: TreeMap[Address, StakeInfo]
    proposals: TreeMap[u256, Proposal]
    proposal_votes: TreeMap[str, bool]  # "proposal_id:user" -> voted
    proposal_count: u256
    
    total_staked: u256
    reward_rate: u256  # APY percentage

    def __init__(self, initial_supply: u256):
        self.name = "GHOST Token"
        self.symbol = "GHOST"
        self.total_supply = initial_supply
        self.owner = gl.message.sender_address
        self.balances[self.owner] = initial_supply
        self.proposal_count = 0
        self.total_staked = 0
        self.reward_rate = 10  # 10% APY

    @gl.public.view
    def balance_of(self, account: Address) -> u256:
        return self.balances.get(account, 0)

    @gl.public.write
    def transfer(self, to: Address, amount: u256):
        sender = gl.message.sender_address
        if self.balances.get(sender, 0) < amount:
            raise gl.UserError("Insufficient balance")
        
        self.balances[sender] = self.balances.get(sender, 0) - amount
        self.balances[to] = self.balances.get(to, 0) + amount

    @gl.public.write
    def stake_tokens(self, amount: u256):
        user = gl.message.sender_address
        if self.balances.get(user, 0) < amount:
            raise gl.UserError("Insufficient balance")
        
        self.balances[user] = self.balances.get(user, 0) - amount
        
        if user in self.stakes:
            stake = self.stakes[user]
            stake.amount += amount
            self.stakes[user] = stake
        else:
            self.stakes[user] = StakeInfo(
                user=user,
                amount=amount,
                staked_at=gl.message.block_timestamp,
                rewards=0
            )
        
        self.total_staked += amount

    @gl.public.write
    def unstake_tokens(self, amount: u256):
        user = gl.message.sender_address
        if user not in self.stakes:
            raise gl.UserError("No stake found")
        
        stake = self.stakes[user]
        if stake.amount < amount:
            raise gl.UserError("Insufficient staked amount")
        
        # Calculate rewards
        time_staked = gl.message.block_timestamp - stake.staked_at
        rewards = (stake.amount * self.reward_rate * time_staked) // (365 * 24 * 3600 * 100)
        
        stake.amount -= amount
        stake.rewards += rewards
        self.stakes[user] = stake
        
        self.balances[user] = self.balances.get(user, 0) + amount + rewards
        self.total_staked -= amount

    @gl.public.write
    def create_proposal(self, title: str, description: str) -> u256:
        user = gl.message.sender_address
        if user not in self.stakes or self.stakes[user].amount < 100:
            raise gl.UserError("Must stake 100+ tokens to create proposal")
        
        proposal_id = self.proposal_count
        self.proposals[proposal_id] = Proposal(
            id=proposal_id,
            proposer=user,
            title=title,
            description=description,
            votes_for=0,
            votes_against=0,
            executed=False,
            created_at=gl.message.block_timestamp
        )
        self.proposal_count += 1
        return proposal_id

    @gl.public.write
    def vote_on_proposal(self, proposal_id: u256, vote_for: bool):
        user = gl.message.sender_address
        if user not in self.stakes:
            raise gl.UserError("Must stake tokens to vote")
        
        vote_key = f"{proposal_id}:{user}"
        if vote_key in self.proposal_votes:
            raise gl.UserError("Already voted")
        
        proposal = self.proposals[proposal_id]
        stake_amount = self.stakes[user].amount
        
        if vote_for:
            proposal.votes_for += stake_amount
        else:
            proposal.votes_against += stake_amount
        
        self.proposals[proposal_id] = proposal
        self.proposal_votes[vote_key] = True

    @gl.public.view
    def get_stake_info(self, user: Address) -> dict:
        if user not in self.stakes:
            return {"amount": 0, "rewards": 0}
        
        stake = self.stakes[user]
        return {
            "amount": stake.amount,
            "staked_at": stake.staked_at,
            "rewards": stake.rewards
        }

    @gl.public.view
    def get_proposal(self, proposal_id: u256) -> dict:
        proposal = self.proposals[proposal_id]
        return {
            "id": proposal.id,
            "title": proposal.title,
            "description": proposal.description,
            "votes_for": proposal.votes_for,
            "votes_against": proposal.votes_against,
            "executed": proposal.executed
        }
