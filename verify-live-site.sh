#!/bin/bash

# Verify Live Site - Hamlite Web3 Dodgeball
# This script tests the live deployment on Vercel

echo "🔍 Verifying Live Site Deployment..."
echo "=================================="

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to check URL status
check_url() {
    local url=$1
    local description=$2
    
    echo -e "${BLUE}Checking: $description${NC}"
    
    if curl -s --head "$url" | head -n 1 | grep -q "200 OK"; then
        echo -e "${GREEN}✅ $description - OK${NC}"
        return 0
    else
        echo -e "${RED}❌ $description - Failed${NC}"
        return 1
    fi
}

# Function to check content
check_content() {
    local url=$1
    local expected=$2
    local description=$3
    
    echo -e "${BLUE}Checking: $description${NC}"
    
    if curl -s "$url" | grep -q "$expected"; then
        echo -e "${GREEN}✅ $description - Found expected content${NC}"
        return 0
    else
        echo -e "${RED}❌ $description - Content not found${NC}"
        return 1
    fi
}

# Get the Vercel URL (you'll need to replace this with your actual URL)
echo -e "${YELLOW}Note: Replace YOUR_VERCEL_URL with your actual Vercel deployment URL${NC}"
echo -e "${YELLOW}You can find this in the GitHub Actions logs or Vercel dashboard${NC}"
echo

# Example checks (uncomment and modify when you have the URL)
# VERCEL_URL="https://your-project-name.vercel.app"
# 
# echo "Testing main site..."
# check_url "$VERCEL_URL" "Main site accessibility"
# 
# echo
# echo "Testing specific content..."
# check_content "$VERCEL_URL" "Hamlite Web3 Dodgeball" "Game title presence"
# check_content "$VERCEL_URL" "Connect Wallet" "Wallet connection button"
# 
# echo
# echo "Testing API endpoints..."
# check_url "$VERCEL_URL/api/health" "API health check" 2>/dev/null || echo -e "${YELLOW}⚠️  API health endpoint not found (may be expected)${NC}"

echo
echo "🎯 Manual Verification Steps:"
echo "=============================="
echo "1. Visit your Vercel URL in a browser"
echo "2. Test wallet connection with MetaMask"
echo "3. Try starting a game"
echo "4. Check browser console for any errors"
echo "5. Test on mobile device"
echo

echo "🔧 If issues found, run:"
echo "========================"
echo "./troubleshoot-deployment.sh"
echo

echo "✅ Verification script ready!"
echo "Replace YOUR_VERCEL_URL with your actual URL and run again for automated tests."
