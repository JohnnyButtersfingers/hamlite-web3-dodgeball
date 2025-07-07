#!/bin/bash

# 🔐 Secure GitHub Secrets Setup Script
echo "🔐 GitHub Secrets Security Setup"
echo "================================="
echo ""
echo "⚠️  SECURITY ALERT: This script will guide you through secure secret setup"
echo "⚠️  DO NOT run this script with actual API keys as arguments!"
echo ""

# Check if user provided any arguments (which would be insecure)
if [ $# -gt 0 ]; then
    echo "❌ ERROR: Do not pass API keys as command line arguments!"
    echo "❌ This is insecure and exposes your keys in shell history."
    echo ""
    echo "✅ Instead, follow these secure steps:"
    echo "1. Read GITHUB_SECRETS_SECURITY_GUIDE.md"
    echo "2. Regenerate all API keys first"
    echo "3. Add secrets manually via GitHub web interface"
    echo ""
    exit 1
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo "🔍 Checking prerequisites..."
if ! command_exists git; then
    echo "❌ Git is not installed"
    exit 1
fi

if ! command_exists gh; then
    echo "⚠️  GitHub CLI (gh) is not installed"
    echo "   You'll need to add secrets manually via web interface"
    echo "   Install: https://cli.github.com/"
    MANUAL_SETUP=true
else
    echo "✅ GitHub CLI is available"
    MANUAL_SETUP=false
fi

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a git repository"
    echo "   Please run this script from the project root"
    exit 1
fi

# Get repository information
REPO_URL=$(git config --get remote.origin.url)
if [ -z "$REPO_URL" ]; then
    echo "❌ Could not determine repository URL"
    exit 1
fi

# Extract repo name and owner
REPO_NAME=$(basename "$REPO_URL" .git)
REPO_OWNER=$(basename "$(dirname "$REPO_URL")" | sed 's/.*://g')

echo "✅ Repository: $REPO_OWNER/$REPO_NAME"
echo ""

# Required secrets
declare -A SECRETS=(
    ["VERCEL_TOKEN"]="Vercel deployment token"
    ["VITE_ABS_RPC_URL"]="Abstract Network RPC URL"
    ["VITE_PINATA_API_KEY"]="Pinata API key"
    ["VITE_PINATA_SECRET_API_KEY"]="Pinata secret key"
    ["VITE_AIRTABLE_API_KEY"]="Airtable API key"
    ["VITE_AIRTABLE_BASE_ID"]="Airtable base ID"
)

echo "📋 Required GitHub Secrets:"
echo "=========================="
for secret in "${!SECRETS[@]}"; do
    echo "• $secret - ${SECRETS[$secret]}"
done
echo ""

# Check current status
echo "🔍 Checking current deployment status..."
if npm run build > /dev/null 2>&1; then
    echo "✅ Build successful"
else
    echo "❌ Build failed - check your code"
    exit 1
fi

if npm run lint > /dev/null 2>&1; then
    echo "✅ Lint successful"
else
    echo "❌ Lint failed - check your code"
    exit 1
fi

echo ""
echo "🚨 SECURITY REQUIREMENTS:"
echo "========================"
echo "1. ⚠️  NEVER share API keys in public messages, code, or chat"
echo "2. ⚠️  REGENERATE all API keys that were previously exposed"
echo "3. ⚠️  Use GitHub Secrets for all sensitive configuration"
echo "4. ⚠️  Set minimal permissions for all API keys"
echo "5. ⚠️  Regularly rotate API keys (monthly/quarterly)"
echo ""

# Provide setup instructions
if [ "$MANUAL_SETUP" = true ]; then
    echo "📋 Manual Setup Instructions:"
    echo "============================="
    echo "1. Go to: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
    echo "2. Click 'New repository secret'"
    echo "3. Add each secret with the following names:"
    echo ""
    for secret in "${!SECRETS[@]}"; do
        echo "   Secret name: $secret"
        echo "   Description: ${SECRETS[$secret]}"
        echo "   Value: [Generate new secure value]"
        echo ""
    done
else
    echo "🤖 GitHub CLI Setup:"
    echo "==================="
    echo "You can use GitHub CLI to add secrets securely:"
    echo ""
    echo "gh auth login  # Login to GitHub"
    echo "gh secret set VERCEL_TOKEN  # Will prompt for value"
    echo "gh secret set VITE_ABS_RPC_URL  # Will prompt for value"
    echo "gh secret set VITE_PINATA_API_KEY  # Will prompt for value"
    echo "gh secret set VITE_PINATA_SECRET_API_KEY  # Will prompt for value"
    echo "gh secret set VITE_AIRTABLE_API_KEY  # Will prompt for value"
    echo "gh secret set VITE_AIRTABLE_BASE_ID  # Will prompt for value"
    echo ""
fi

echo "🔗 Useful Links:"
echo "==============="
echo "• Vercel Tokens: https://vercel.com/account/tokens"
echo "• Pinata API Keys: https://pinata.cloud/keys"
echo "• Airtable API: https://airtable.com/developers/web/api/introduction"
echo "• GitHub Secrets: https://github.com/$REPO_OWNER/$REPO_NAME/settings/secrets/actions"
echo "• GitHub Actions: https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo ""

echo "✅ Next Steps:"
echo "============="
echo "1. Read GITHUB_SECRETS_SECURITY_GUIDE.md"
echo "2. Regenerate ALL API keys that were previously exposed"
echo "3. Add secrets to GitHub via web interface or CLI"
echo "4. Test deployment by pushing a commit"
echo "5. Monitor deployment logs for any issues"
echo ""

echo "🎯 Testing:"
echo "=========="
echo "After setting up secrets, test deployment:"
echo "git add ."
echo "git commit -m 'test: trigger deployment'"
echo "git push origin main"
echo ""

echo "📊 Monitor deployment:"
echo "https://github.com/$REPO_OWNER/$REPO_NAME/actions"
echo ""

echo "✅ Setup script complete!"
echo "⚠️  Remember: Security first - never expose API keys publicly!"
