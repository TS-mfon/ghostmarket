#!/bin/bash

# GhostMarket Contract Deployment Script
# This script deploys both contracts to GenLayer testnet

set -e

echo "🚀 Deploying GhostMarket Contracts to GenLayer Testnet"
echo "======================================================="

# Check if genlayer CLI is installed
if ! command -v genlayer &> /dev/null; then
    echo "❌ GenLayer CLI not found. Install with: pip install genlayer"
    exit 1
fi

# Deploy GhostMarketCore
echo ""
echo "📝 Deploying GhostMarketCore..."
CORE_ADDRESS=$(genlayer deploy contracts/GhostMarketCore.py --network testnet --json | jq -r '.contract_address')

if [ -z "$CORE_ADDRESS" ]; then
    echo "❌ Failed to deploy GhostMarketCore"
    exit 1
fi

echo "✅ GhostMarketCore deployed at: $CORE_ADDRESS"

# Deploy GHOST Token (1 million initial supply)
echo ""
echo "📝 Deploying GHOST Token..."
TOKEN_ADDRESS=$(genlayer deploy contracts/GHOSTToken.py --network testnet --args 1000000000000000000000000 --json | jq -r '.contract_address')

if [ -z "$TOKEN_ADDRESS" ]; then
    echo "❌ Failed to deploy GHOST Token"
    exit 1
fi

echo "✅ GHOST Token deployed at: $TOKEN_ADDRESS"

# Update .env file
echo ""
echo "📝 Updating .env file..."
if [ -f .env ]; then
    sed -i "s|GENLAYER_CONTRACT_ADDRESS=.*|GENLAYER_CONTRACT_ADDRESS=$CORE_ADDRESS|g" .env
    sed -i "s|GENLAYER_TOKEN_ADDRESS=.*|GENLAYER_TOKEN_ADDRESS=$TOKEN_ADDRESS|g" .env
else
    cp .env.example .env
    sed -i "s|GENLAYER_CONTRACT_ADDRESS=|GENLAYER_CONTRACT_ADDRESS=$CORE_ADDRESS|g" .env
    echo "GENLAYER_TOKEN_ADDRESS=$TOKEN_ADDRESS" >> .env
fi

echo "✅ .env file updated"

# Display summary
echo ""
echo "🎉 Deployment Complete!"
echo "======================================================="
echo "GhostMarketCore: $CORE_ADDRESS"
echo "GHOST Token:     $TOKEN_ADDRESS"
echo ""
echo "Next steps:"
echo "1. Update frontend/.env.local with these addresses"
echo "2. Deploy backend to your VPS"
echo "3. Deploy frontend to Vercel"
echo ""
echo "Contract URLs:"
echo "https://testnet-explorer.genlayer.com/contract/$CORE_ADDRESS"
echo "https://testnet-explorer.genlayer.com/contract/$TOKEN_ADDRESS"
