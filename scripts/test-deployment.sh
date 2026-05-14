#!/bin/bash

# GhostMarket Testing Script
# Tests the deployed application

set -e

echo "🧪 Testing GhostMarket Deployment"
echo "=================================="

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counter
PASSED=0
FAILED=0

# Function to test
test_endpoint() {
    local name=$1
    local url=$2
    local expected_status=${3:-200}
    
    echo -n "Testing $name... "
    
    status=$(curl -s -o /dev/null -w "%{http_code}" "$url" || echo "000")
    
    if [ "$status" = "$expected_status" ]; then
        echo -e "${GREEN}✓ PASSED${NC} (HTTP $status)"
        ((PASSED++))
    else
        echo -e "${RED}✗ FAILED${NC} (HTTP $status, expected $expected_status)"
        ((FAILED++))
    fi
}

# Get URLs from user
echo ""
read -p "Enter your Vercel frontend URL (e.g., https://ghostmarket.vercel.app): " FRONTEND_URL
read -p "Enter your backend URL (or press Enter to skip): " BACKEND_URL

echo ""
echo "Testing Frontend..."
echo "-------------------"

# Test frontend pages
test_endpoint "Homepage" "$FRONTEND_URL"
test_endpoint "Feed Page" "$FRONTEND_URL/feed"
test_endpoint "Dashboard" "$FRONTEND_URL/dashboard"
test_endpoint "Analytics" "$FRONTEND_URL/analytics"

if [ -n "$BACKEND_URL" ]; then
    echo ""
    echo "Testing Backend..."
    echo "------------------"
    
    # Test backend endpoints
    test_endpoint "Health Check" "$BACKEND_URL/health"
    test_endpoint "API Docs" "$BACKEND_URL/docs"
    test_endpoint "Trends API" "$BACKEND_URL/api/v1/trends/"
    test_endpoint "Reputation API" "$BACKEND_URL/api/v1/reputation/leaderboard"
fi

# Summary
echo ""
echo "=================================="
echo "Test Summary"
echo "=================================="
echo -e "${GREEN}Passed: $PASSED${NC}"
echo -e "${RED}Failed: $FAILED${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ Some tests failed. Check the output above.${NC}"
    exit 1
fi
