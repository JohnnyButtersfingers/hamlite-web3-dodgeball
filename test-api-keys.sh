#!/bin/bash

# 🔑 API Key Testing Tool
echo "🔑 API Key Testing Tool"
echo "======================"
echo "Date: $(date)"
echo ""

# Function to test API with timeout
test_api() {
    local url="$1"
    local description="$2"
    local headers="$3"
    local data="$4"
    
    echo -n "Testing $description... "
    
    if [ -n "$data" ]; then
        # POST request with data
        response=$(curl -s -w "%{http_code}" -X POST -H "$headers" -d "$data" "$url" --max-time 10)
    else
        # GET request
        response=$(curl -s -w "%{http_code}" -H "$headers" "$url" --max-time 10)
    fi
    
    http_code="${response: -3}"
    body="${response%???}"
    
    if [[ "$http_code" =~ ^2[0-9][0-9]$ ]]; then
        echo "✅ OK (HTTP $http_code)"
        return 0
    else
        echo "❌ FAILED (HTTP $http_code)"
        if [ -n "$body" ] && [ ${#body} -lt 200 ]; then
            echo "   Response: $body"
        fi
        return 1
    fi
}

# Test Abstract Network RPC (public endpoint)
echo "🌐 Testing Abstract Network RPC:"
test_api "https://rpc.abstract.xyz" "Abstract Network RPC" \
    "Content-Type: application/json" \
    '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

if [ $? -eq 0 ]; then
    echo "   ✅ Abstract Network is accessible"
else
    echo "   ❌ Abstract Network connection failed"
fi
echo ""

# Test Pinata API (requires environment variables)
echo "📌 Testing Pinata API:"
if [ -n "$VITE_PINATA_API_KEY" ] && [ -n "$VITE_PINATA_SECRET_API_KEY" ]; then
    echo "Using provided API keys..."
    test_api "https://api.pinata.cloud/data/testAuthentication" "Pinata Authentication" \
        "pinata_api_key: $VITE_PINATA_API_KEY\r\npinata_secret_api_key: $VITE_PINATA_SECRET_API_KEY"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Pinata API keys are valid"
        
        # Test file listing
        echo "   Testing file listing..."
        test_api "https://api.pinata.cloud/data/pinList?status=pinned" "Pinata File List" \
            "pinata_api_key: $VITE_PINATA_API_KEY\r\npinata_secret_api_key: $VITE_PINATA_SECRET_API_KEY"
    else
        echo "   ❌ Pinata API authentication failed"
        echo "   💡 Regenerate your Pinata API keys at: https://pinata.cloud/keys"
    fi
else
    echo "⚠️ Pinata API keys not provided"
    echo "   Set VITE_PINATA_API_KEY and VITE_PINATA_SECRET_API_KEY environment variables"
    echo "   Or add them to GitHub Secrets"
fi
echo ""

# Test Airtable API (requires environment variable)
echo "📊 Testing Airtable API:"
if [ -n "$VITE_AIRTABLE_API_KEY" ]; then
    echo "Using provided API key..."
    test_api "https://api.airtable.com/v0/meta/whoami" "Airtable Authentication" \
        "Authorization: Bearer $VITE_AIRTABLE_API_KEY"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Airtable API key is valid"
        
        # Test base access if base ID is provided
        if [ -n "$VITE_AIRTABLE_BASE_ID" ]; then
            echo "   Testing base access..."
            test_api "https://api.airtable.com/v0/meta/bases/$VITE_AIRTABLE_BASE_ID/tables" "Airtable Base Access" \
                "Authorization: Bearer $VITE_AIRTABLE_API_KEY"
            
            if [ $? -eq 0 ]; then
                echo "   ✅ Airtable base is accessible"
            else
                echo "   ❌ Airtable base access failed"
                echo "   💡 Check your VITE_AIRTABLE_BASE_ID"
            fi
        else
            echo "   ⚠️ VITE_AIRTABLE_BASE_ID not provided - cannot test base access"
        fi
    else
        echo "   ❌ Airtable API authentication failed"
        echo "   💡 Regenerate your Airtable API key at: https://airtable.com/developers/web/api/introduction"
    fi
else
    echo "⚠️ Airtable API key not provided"
    echo "   Set VITE_AIRTABLE_API_KEY environment variable"
    echo "   Or add it to GitHub Secrets"
fi
echo ""

# Test Vercel API (requires environment variable)
echo "🚀 Testing Vercel API:"
if [ -n "$VERCEL_TOKEN" ]; then
    echo "Using provided token..."
    test_api "https://api.vercel.com/v2/user" "Vercel Authentication" \
        "Authorization: Bearer $VERCEL_TOKEN"
    
    if [ $? -eq 0 ]; then
        echo "   ✅ Vercel token is valid"
        
        # Test deployments access
        echo "   Testing deployments access..."
        test_api "https://api.vercel.com/v6/deployments" "Vercel Deployments" \
            "Authorization: Bearer $VERCEL_TOKEN"
    else
        echo "   ❌ Vercel token authentication failed"
        echo "   💡 Generate new token at: https://vercel.com/account/tokens"
    fi
else
    echo "⚠️ Vercel token not provided"
    echo "   Set VERCEL_TOKEN environment variable"
    echo "   Or add it to GitHub Secrets"
fi
echo ""

# Network connectivity summary
echo "🌐 Network Connectivity Summary:"
services=("api.pinata.cloud" "api.airtable.com" "api.vercel.com" "rpc.abstract.xyz")
failed_services=()

for service in "${services[@]}"; do
    if ping -c 1 "$service" &> /dev/null; then
        echo "✅ $service: reachable"
    else
        echo "❌ $service: unreachable"
        failed_services+=("$service")
    fi
done

if [ ${#failed_services[@]} -gt 0 ]; then
    echo ""
    echo "⚠️ Network Issues Detected:"
    for service in "${failed_services[@]}"; do
        echo "   • $service is not reachable"
    done
    echo "   💡 Check your internet connection or firewall settings"
fi
echo ""

# Summary and recommendations
echo "🎯 API Testing Summary:"
echo "======================"

if [ -z "$VITE_PINATA_API_KEY" ] || [ -z "$VITE_PINATA_SECRET_API_KEY" ]; then
    echo "❌ Pinata API keys missing"
fi

if [ -z "$VITE_AIRTABLE_API_KEY" ]; then
    echo "❌ Airtable API key missing"
fi

if [ -z "$VERCEL_TOKEN" ]; then
    echo "❌ Vercel token missing"
fi

echo ""
echo "📋 Next Steps:"
echo "1. Regenerate any failed API keys"
echo "2. Add all API keys to GitHub Secrets"
echo "3. Test deployment after adding secrets"
echo "4. Monitor GitHub Actions for any errors"
echo ""

echo "🔗 API Management Links:"
echo "• Pinata: https://pinata.cloud/keys"
echo "• Airtable: https://airtable.com/developers/web/api/introduction"
echo "• Vercel: https://vercel.com/account/tokens"
echo "• Abstract: https://docs.abs.xyz/"
echo ""

echo "💡 Usage Examples:"
echo "Test with environment variables:"
echo "VITE_PINATA_API_KEY=your_key VITE_PINATA_SECRET_API_KEY=your_secret ./test-api-keys.sh"
echo ""
echo "Or export them first:"
echo "export VITE_PINATA_API_KEY=your_key"
echo "export VITE_PINATA_SECRET_API_KEY=your_secret"
echo "export VITE_AIRTABLE_API_KEY=your_key"
echo "export VERCEL_TOKEN=your_token"
echo "./test-api-keys.sh"
