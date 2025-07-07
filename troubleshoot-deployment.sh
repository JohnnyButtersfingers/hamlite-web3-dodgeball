#!/bin/bash

# 🔍 Comprehensive Deployment Troubleshooting Tool
echo "🔍 Hamlite Web3 Dodgeball - Deployment Troubleshooting"
echo "===================================================="
echo "Date: $(date)"
echo "User: $(whoami)"
echo ""

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo "✅ $2"
    else
        echo "❌ $2"
    fi
}

# Check local environment
echo "📋 Local Environment Check:"
echo "Node version: $(node --version)"
echo "NPM version: $(npm --version)"
echo "Git version: $(git --version)"

# Check if we're in correct directory
if [ ! -f "package.json" ]; then
    echo "❌ Not in project root directory"
    echo "Please run this script from the hamlite-web3-dodgeball directory"
    exit 1
fi

echo "✅ Running from project root"
echo ""

# Check package.json
echo "📦 Package.json Verification:"
echo "Project name: $(node -p "require('./package.json').name")"
echo "Project version: $(node -p "require('./package.json').version")"
echo "Node scripts available: $(node -p "Object.keys(require('./package.json').scripts).join(', ')")"
echo ""

# Check critical files
echo "📁 Critical Files Check:"
critical_files=(
    "src/App.jsx"
    "src/main.jsx" 
    "src/index.css"
    "src/App.css"
    "src/components/GameArena.jsx"
    "vite.config.js"
    ".eslintrc.cjs"
    ".github/workflows/deploy.yml"
    "index.html"
    ".env.example"
)

for file in "${critical_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
    fi
done
echo ""

# Check dependencies
echo "📦 Dependencies Check:"
if [ -f "package-lock.json" ]; then
    echo "✅ package-lock.json exists"
else
    echo "⚠️ package-lock.json missing - run npm install"
fi

if [ -d "node_modules" ]; then
    echo "✅ node_modules directory exists"
    echo "Dependencies installed: $(ls node_modules | wc -l) packages"
else
    echo "❌ node_modules missing - run npm install"
fi
echo ""

# Test build locally
echo "🏗️ Local Build Test:"
if npm run build > /tmp/build.log 2>&1; then
    echo "✅ Local build successful"
    if [ -d "dist" ]; then
        echo "Build output size: $(du -sh dist/ | cut -f1)"
        echo "Files in dist: $(find dist -type f | wc -l)"
    fi
else
    echo "❌ Local build failed"
    echo "Build error log:"
    cat /tmp/build.log
fi
echo ""

# Test linting
echo "🔍 Linting Test:"
if npm run lint > /tmp/lint.log 2>&1; then
    echo "✅ Linting passed"
else
    echo "❌ Linting failed"
    echo "Lint error log:"
    cat /tmp/lint.log
fi
echo ""

# Check environment template
echo "🔑 Environment Variables Check:"
if [ -f ".env.example" ]; then
    echo "✅ .env.example exists"
    echo "Required environment variables:"
    while IFS= read -r line; do
        if [[ $line == VITE_* ]]; then
            echo "  • $line"
        fi
    done < .env.example
else
    echo "❌ .env.example not found"
fi
echo ""

# Git repository status
echo "📊 Git Repository Status:"
echo "Repository URL: $(git config --get remote.origin.url)"
echo "Current branch: $(git branch --show-current)"
echo "Latest commit: $(git log --oneline -1)"
echo "Uncommitted changes: $(git status --porcelain | wc -l)"
echo ""

# Check GitHub CLI availability
echo "🔧 GitHub CLI Status:"
if command -v gh &> /dev/null; then
    echo "✅ GitHub CLI available"
    if gh auth status &> /dev/null; then
        echo "✅ GitHub CLI authenticated"
    else
        echo "⚠️ GitHub CLI not authenticated - run 'gh auth login'"
    fi
else
    echo "⚠️ GitHub CLI not installed"
    echo "Install from: https://cli.github.com/"
fi
echo ""

# Network connectivity test
echo "🌐 Network Connectivity Test:"
services=("github.com" "vercel.com" "api.pinata.cloud" "api.airtable.com" "rpc.abstract.xyz")

for service in "${services[@]}"; do
    if ping -c 1 "$service" &> /dev/null; then
        echo "✅ $service: reachable"
    else
        echo "❌ $service: unreachable"
    fi
done
echo ""

# Check GitHub Actions workflow
echo "🚀 GitHub Actions Workflow Check:"
workflow_file=".github/workflows/deploy.yml"
if [ -f "$workflow_file" ]; then
    echo "✅ Workflow file exists"
    echo "Workflow triggers on: $(grep -A 5 "on:" "$workflow_file" | grep -E "push:|pull_request:" | tr -d ' ')"
    echo "Environment variables used:"
    grep -o "VITE_[A-Z_]*" "$workflow_file" | sort | uniq | while read var; do
        echo "  • $var"
    done
else
    echo "❌ GitHub Actions workflow missing"
fi
echo ""

# Abstract Network RPC test
echo "🌐 Abstract Network RPC Test:"
rpc_url="https://rpc.abstract.xyz"
if curl -s -X POST -H "Content-Type: application/json" \
   -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
   "$rpc_url" | grep -q "result"; then
    echo "✅ Abstract Network RPC: responsive"
else
    echo "❌ Abstract Network RPC: not responding"
fi
echo ""

# GitHub repository secrets check (requires authenticated gh CLI)
echo "🔐 GitHub Secrets Status:"
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    repo_url=$(git config --get remote.origin.url)
    repo_name=$(basename "$repo_url" .git)
    repo_owner=$(basename "$(dirname "$repo_url")" | sed 's/.*://g')
    
    echo "Checking secrets for: $repo_owner/$repo_name"
    
    required_secrets=(
        "VERCEL_TOKEN"
        "VITE_ABS_RPC_URL"
        "VITE_PINATA_API_KEY"
        "VITE_PINATA_SECRET_API_KEY"
        "VITE_AIRTABLE_API_KEY"
        "VITE_AIRTABLE_BASE_ID"
    )
    
    for secret in "${required_secrets[@]}"; do
        if gh secret list | grep -q "$secret"; then
            echo "✅ $secret: set"
        else
            echo "❌ $secret: missing"
        fi
    done
else
    echo "⚠️ Cannot check secrets - GitHub CLI not available or not authenticated"
    echo "Manual check: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[/:]//; s/.git$//')/settings/secrets/actions"
fi
echo ""

# Recent GitHub Actions runs (requires authenticated gh CLI)
echo "📊 Recent GitHub Actions Runs:"
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    echo "Last 5 workflow runs:"
    gh run list --limit 5 --json status,conclusion,createdAt,displayTitle 2>/dev/null | \
    jq -r '.[] | "\(.status) \(.conclusion // "N/A") \(.createdAt) \(.displayTitle)"' 2>/dev/null || \
    echo "No recent runs or jq not available"
else
    echo "⚠️ Cannot check runs - GitHub CLI not available"
    echo "Manual check: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[/:]//; s/.git$//')/actions"
fi
echo ""

# Summary
echo "🎯 Troubleshooting Summary:"
echo "=========================="
echo "Local build: $([ -f dist/index.html ] && echo "✅ Working" || echo "❌ Failed")"
echo "Local lint: $(npm run lint &>/dev/null && echo "✅ Passing" || echo "❌ Failing")"
echo "Git status: $([ "$(git status --porcelain | wc -l)" -eq 0 ] && echo "✅ Clean" || echo "⚠️ Uncommitted changes")"
echo "Network: $(ping -c 1 github.com &>/dev/null && echo "✅ Connected" || echo "❌ Issues")"
echo ""

echo "🔗 Useful Links:"
echo "==============="
repo_path=$(git config --get remote.origin.url | sed 's/.*github.com[/:]//; s/.git$//')
echo "• Repository: https://github.com/$repo_path"
echo "• GitHub Actions: https://github.com/$repo_path/actions"
echo "• Secrets Settings: https://github.com/$repo_path/settings/secrets/actions"
echo "• Vercel Dashboard: https://vercel.com/dashboard"
echo ""

echo "✅ Troubleshooting Complete!"
echo ""
echo "Next steps:"
echo "1. If local tests pass but deployment fails, check GitHub Secrets"
echo "2. If GitHub Actions fails, check the workflow logs"
echo "3. If network issues, check your internet connection"
echo "4. If API errors, verify and regenerate API keys"
