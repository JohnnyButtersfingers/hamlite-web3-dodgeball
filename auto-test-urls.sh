#!/bin/bash

# Auto-Test Common Vercel URLs
# This script tests common Vercel URL patterns for your project

echo "🔍 Auto-Testing Common Vercel URLs"
echo "=================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Get project name from package.json
PROJECT_NAME=$(grep '"name"' package.json | cut -d'"' -f4)
echo -e "${BLUE}Project name: $PROJECT_NAME${NC}"

# Common Vercel URL patterns
POSSIBLE_URLS=(
    "https://hamlite-web3-dodgeball.vercel.app"
    "https://hamlite-web3-dodgeball-git-main.vercel.app"
    "https://hamlite-web3-dodgeball-johnnybuttersfingers.vercel.app"
    "https://$PROJECT_NAME.vercel.app"
    "https://$PROJECT_NAME-git-main.vercel.app"
)

echo -e "${BLUE}Testing common URL patterns...${NC}"
echo

FOUND_URL=""

for url in "${POSSIBLE_URLS[@]}"; do
    echo -e "${BLUE}Testing: $url${NC}"
    
    if curl -s --head "$url" --max-time 10 | head -n 1 | grep -q "200\|301\|302"; then
        echo -e "${GREEN}✅ FOUND: $url${NC}"
        FOUND_URL="$url"
        break
    else
        echo -e "${RED}❌ Not found: $url${NC}"
    fi
done

echo
echo "=================================="

if [ -n "$FOUND_URL" ]; then
    echo -e "${GREEN}🎉 SUCCESS! Found your live site:${NC}"
    echo -e "${GREEN}$FOUND_URL${NC}"
    echo
    echo -e "${BLUE}Running quick verification...${NC}"
    
    # Quick content check
    CONTENT=$(curl -s "$FOUND_URL" --max-time 10 2>/dev/null)
    
    if echo "$CONTENT" | grep -qi "hamlite\|dodgeball"; then
        echo -e "${GREEN}✅ Game content detected${NC}"
    else
        echo -e "${YELLOW}⚠️  Game content not detected${NC}"
    fi
    
    if echo "$CONTENT" | grep -qi "connect"; then
        echo -e "${GREEN}✅ Wallet connection UI detected${NC}"
    else
        echo -e "${YELLOW}⚠️  Wallet connection UI not detected${NC}"
    fi
    
    if echo "$CONTENT" | grep -q "script"; then
        echo -e "${GREEN}✅ JavaScript application detected${NC}"
    else
        echo -e "${YELLOW}⚠️  JavaScript application not detected${NC}"
    fi
    
    echo
    echo -e "${GREEN}🎯 Your live site is ready!${NC}"
    echo -e "${BLUE}Next steps:${NC}"
    echo "1. Open $FOUND_URL in your browser"
    echo "2. Test wallet connection with MetaMask"
    echo "3. Try playing the game"
    echo "4. Run full verification: ./verify-live-site.sh"
    echo
else
    echo -e "${RED}❌ No live site found at common URLs${NC}"
    echo
    echo -e "${YELLOW}🔍 Manual steps:${NC}"
    echo "1. Check GitHub Actions: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions"
    echo "2. Look for deployment logs with the actual URL"
    echo "3. Check your Vercel dashboard: https://vercel.com/dashboard"
    echo "4. Run: ./verify-live-site.sh with your actual URL"
fi

echo
echo "=================================="
echo -e "${GREEN}✅ Auto-test complete!${NC}"
