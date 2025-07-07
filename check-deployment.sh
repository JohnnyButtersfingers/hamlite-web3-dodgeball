#!/bin/bash

# 🔍 Deployment Status Checker
echo "🔍 Checking deployment status..."
echo "=================================="

# Check if GitHub Actions workflow exists
if [[ -f ".github/workflows/deploy.yml" ]]; then
    echo "✅ GitHub Actions workflow exists"
else
    echo "❌ GitHub Actions workflow missing"
    exit 1
fi

# Check recent commits
echo ""
echo "📝 Recent commits:"
git log --oneline -3

# Check if changes are pushed
echo ""
echo "🔄 Git status:"
git status

# Check if build works
echo ""
echo "🏗️ Testing build..."
if npm run build > /dev/null 2>&1; then
    echo "✅ Build successful"
else
    echo "❌ Build failed"
    echo "Run: npm run build"
    exit 1
fi

# Check if lint passes
echo ""
echo "🔍 Testing lint..."
if npm run lint > /dev/null 2>&1; then
    echo "✅ Lint successful"
else
    echo "❌ Lint failed"
    echo "Run: npm run lint"
    exit 1
fi

echo ""
echo "🎉 Local checks passed!"
echo ""
echo "📋 Next steps:"
echo "1. Go to: https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball/settings/secrets/actions"
echo "2. Set these secrets:"
echo "   - VERCEL_TOKEN"
echo "   - VITE_ABS_RPC_URL"
echo "   - VITE_PINATA_API_KEY"
echo "   - VITE_PINATA_SECRET_API_KEY"
echo "   - VITE_AIRTABLE_API_KEY"
echo "   - VITE_AIRTABLE_BASE_ID"
echo ""
echo "3. Monitor deployment:"
echo "   https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball/actions"
echo ""
echo "4. If deployment fails, check DEPLOYMENT_TROUBLESHOOTING.md"
echo "5. ⚠️  SECURITY: See GITHUB_SECRETS_SECURITY_GUIDE.md for proper setup"
