#!/bin/bash

# Quick Deployment Status Checker
# Get your Vercel URL and deployment status

echo "🚀 Quick Deployment Status Check"
echo "================================="

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Checking latest commits...${NC}"
echo "Latest 3 commits:"
git log --oneline -3

echo
echo -e "${BLUE}Checking Git status...${NC}"
git status --porcelain

echo
echo -e "${BLUE}Checking deployment configuration...${NC}"
echo "GitHub Actions workflow file:"
if [ -f ".github/workflows/deploy.yml" ]; then
    echo -e "${GREEN}✅ .github/workflows/deploy.yml exists${NC}"
else
    echo -e "${RED}❌ .github/workflows/deploy.yml missing${NC}"
fi

echo
echo "Environment template:"
if [ -f ".env.example" ]; then
    echo -e "${GREEN}✅ .env.example exists${NC}"
    echo "Environment variables configured:"
    grep -E "^[A-Z_]+=" .env.example | sed 's/=.*/=***/' | head -10
else
    echo -e "${RED}❌ .env.example missing${NC}"
fi

echo
echo -e "${YELLOW}🔗 Next Steps:${NC}"
echo "1. Go to: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions"
echo "2. Look for the latest workflow run"
echo "3. Check if it's completed successfully"
echo "4. Copy the Vercel URL from the deployment logs"
echo "5. Run: ./verify-live-site.sh"
echo

echo -e "${BLUE}📊 Expected Vercel URL format:${NC}"
echo "https://hamlite-web3-dodgeball-[hash].vercel.app"
echo "or"
echo "https://hamlite-web3-dodgeball.vercel.app"
echo

echo -e "${GREEN}✅ Status check complete!${NC}"
echo -e "${YELLOW}Go check GitHub Actions now!${NC}"
