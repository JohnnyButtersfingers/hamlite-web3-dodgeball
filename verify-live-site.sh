#!/bin/bash

# Verify Live Site - Hamlite Web3 Dodgecho -e "${YELLOW}🔗 GitHub Actions: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions${NC}"
echo -e "${YELLOW}📊 Vercel Dashboard: https://vercel.com/dashboard${NC}"all
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

# Get the Vercel URL from user input or GitHub Actions
echo -e "${BLUE}🔍 Getting Vercel URL for testing...${NC}"
echo -e "${YELLOW}You can find your URL in:${NC}"
echo -e "${YELLOW}🔗 GitHub Actions: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions${NC}"
echo -e "${YELLOW}� Vercel Dashboard: https://vercel.com/dashboard${NC}"
echo

# Try to get URL from user input
echo -e "${BLUE}Enter your Vercel URL (or press Enter to skip automated tests):${NC}"
read -p "URL: " VERCEL_URL

if [ -z "$VERCEL_URL" ]; then
    echo -e "${YELLOW}⚠️  No URL provided. Skipping automated tests.${NC}"
    echo -e "${YELLOW}Manual verification steps will be shown below.${NC}"
else
    echo -e "${GREEN}✅ Testing URL: $VERCEL_URL${NC}"
    echo "=================================================================="
    
    # Test 1: Basic connectivity
    echo -e "${BLUE}🔍 Test 1: Basic Site Accessibility${NC}"
    if check_url "$VERCEL_URL" "Main site accessibility"; then
        SITE_ACCESSIBLE=true
    else
        SITE_ACCESSIBLE=false
        echo -e "${RED}❌ Site is not accessible. Check deployment status.${NC}"
    fi
    
    # Test 2: Content verification (only if site is accessible)
    if [ "$SITE_ACCESSIBLE" = true ]; then
        echo
        echo -e "${BLUE}🔍 Test 2: Content Verification${NC}"
        
        # Get page content
        CONTENT=$(curl -s "$VERCEL_URL" 2>/dev/null)
        
        if echo "$CONTENT" | grep -qi "hamlite\|dodgeball"; then
            echo -e "${GREEN}✅ Game title found${NC}"
        else
            echo -e "${RED}❌ Game title not found${NC}"
        fi
        
        if echo "$CONTENT" | grep -qi "connect"; then
            echo -e "${GREEN}✅ Wallet connection UI found${NC}"
        else
            echo -e "${RED}❌ Wallet connection UI not found${NC}"
        fi
        
        if echo "$CONTENT" | grep -qi "react\|vite"; then
            echo -e "${GREEN}✅ React/Vite application detected${NC}"
        else
            echo -e "${YELLOW}⚠️  React/Vite markers not found${NC}"
        fi
        
        # Test 3: JavaScript and CSS loading
        echo
        echo -e "${BLUE}🔍 Test 3: Asset Loading${NC}"
        
        if echo "$CONTENT" | grep -q "script.*js"; then
            echo -e "${GREEN}✅ JavaScript files detected${NC}"
        else
            echo -e "${RED}❌ JavaScript files not detected${NC}"
        fi
        
        if echo "$CONTENT" | grep -q "stylesheet\|css"; then
            echo -e "${GREEN}✅ CSS files detected${NC}"
        else
            echo -e "${RED}❌ CSS files not detected${NC}"
        fi
        
        # Test 4: Mobile responsiveness
        echo
        echo -e "${BLUE}🔍 Test 4: Mobile Responsiveness${NC}"
        
        if echo "$CONTENT" | grep -q "viewport"; then
            echo -e "${GREEN}✅ Mobile viewport meta tag found${NC}"
        else
            echo -e "${RED}❌ Mobile viewport meta tag missing${NC}"
        fi
        
        # Test 5: Security headers
        echo
        echo -e "${BLUE}🔍 Test 5: Security Headers${NC}"
        
        HEADERS=$(curl -s -I "$VERCEL_URL" 2>/dev/null)
        
        if echo "$HEADERS" | grep -qi "x-frame-options"; then
            echo -e "${GREEN}✅ X-Frame-Options header found${NC}"
        else
            echo -e "${YELLOW}⚠️  X-Frame-Options header not found${NC}"
        fi
        
        if echo "$HEADERS" | grep -qi "content-security-policy"; then
            echo -e "${GREEN}✅ Content-Security-Policy header found${NC}"
        else
            echo -e "${YELLOW}⚠️  Content-Security-Policy header not found${NC}"
        fi
        
        echo
        echo -e "${GREEN}🎉 Automated verification complete!${NC}"
    fi
    
    echo "=================================================================="
fi

echo
echo "🎯 Manual Verification Steps:"
echo "=============================="
echo "1. 🌐 Visit your Vercel URL in a browser"
echo "2. 🦊 Test wallet connection with MetaMask"
echo "3. 🎮 Try starting a game and verify gameplay"
echo "4. 🔧 Check browser console for any errors (F12)"
echo "5. 📱 Test on mobile device for responsiveness"
echo "6. 🚀 Test Abstract Network switching"
echo "7. 💾 Verify IPFS and Airtable integrations work"
echo

echo "🔧 Web3 Testing Checklist:"
echo "========================="
echo "✅ Wallet connects without errors"
echo "✅ Network switches to Abstract testnet"
echo "✅ Game starts and runs smoothly"
echo "✅ Score system updates correctly"
echo "✅ Health bars display properly"
echo "✅ Mobile touch controls work"
echo "✅ No console errors in browser"
echo

echo "🚨 Common Issues & Solutions:"
echo "============================"
echo "❌ Site won't load → Check GitHub Actions deployment status"
echo "❌ Wallet won't connect → Ensure MetaMask is installed and unlocked"
echo "❌ Game won't start → Check browser console for JavaScript errors"
echo "❌ Mobile issues → Test viewport and touch event handling"
echo "❌ Performance issues → Check network tab for slow loading assets"
echo

echo "🔧 If issues found, run:"
echo "========================"
echo "./troubleshoot-deployment.sh      # Comprehensive diagnostics"
echo "./check-deployment.sh             # Quick deployment status"
echo "./test-api-keys.sh                # Verify API key configuration"
echo

echo "📊 Performance Benchmarks:"
echo "========================="
echo "🎯 Page load time: <3 seconds"
echo "🎯 Game startup: <2 seconds"
echo "🎯 Wallet connection: <5 seconds"
echo "🎯 Mobile responsiveness: All screen sizes"
echo "🎯 Cross-browser: Chrome, Firefox, Safari, Edge"
echo

echo "✅ Verification script ready!"
echo "Run this script after deployment completes for full testing."
