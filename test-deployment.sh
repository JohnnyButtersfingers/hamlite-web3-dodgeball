#!/bin/bash

# Test deployment script to verify build and deployment readiness
echo "🧪 Testing deployment readiness..."

# Check if all required files exist
echo "📁 Checking project structure..."
required_files=(
  "package.json"
  "vite.config.js"
  "index.html"
  "src/main.jsx"
  "src/App.jsx"
  ".github/workflows/deploy.yml"
  ".env.example"
)

for file in "${required_files[@]}"; do
  if [[ -f "$file" ]]; then
    echo "✅ $file exists"
  else
    echo "❌ $file is missing"
    exit 1
  fi
done

# Test npm install
echo "📦 Testing npm install..."
if npm ci; then
  echo "✅ npm install successful"
else
  echo "❌ npm install failed"
  exit 1
fi

# Test build
echo "🏗️ Testing build..."
if npm run build; then
  echo "✅ Build successful"
else
  echo "❌ Build failed"
  exit 1
fi

# Test lint
echo "🔍 Testing lint..."
if npm run lint; then
  echo "✅ Lint successful"
else
  echo "❌ Lint failed"
  exit 1
fi

# Check if dist directory was created
if [[ -d "dist" ]]; then
  echo "✅ dist directory created"
  echo "📊 Build output:"
  ls -la dist/
else
  echo "❌ dist directory not created"
  exit 1
fi

echo "🎉 All tests passed! Project is ready for deployment."
echo ""
echo "📋 Next steps:"
echo "1. Ensure GitHub Secrets are set:"
echo "   - VERCEL_TOKEN"
echo "   - VITE_ABS_RPC_URL"
echo "   - VITE_PINATA_API_KEY"
echo "   - VITE_PINATA_SECRET_API_KEY"
echo ""
echo "2. Push changes to trigger GitHub Actions:"
echo "   git push origin main"
echo ""
echo "3. Monitor deployment at: https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball/actions"
