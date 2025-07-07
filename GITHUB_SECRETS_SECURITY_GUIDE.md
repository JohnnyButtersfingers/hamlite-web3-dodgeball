# 🔐 GitHub Secrets Security Guide

## ⚠️ IMMEDIATE SECURITY ACTION REQUIRED

**The API keys mentioned in your request have been publicly exposed and should be considered compromised.** You must **regenerate all API keys immediately** before setting up GitHub Secrets.

## 🔄 Step 1: Regenerate All API Keys

### **Pinata API Keys**
1. Go to [Pinata.cloud](https://pinata.cloud) → Account → API Keys
2. **Delete the existing API key** (ccdd628d6e4744b23601)
3. **Generate a new API key** with appropriate permissions
4. **Copy the new API key and secret** securely

### **Airtable API Key**
1. Go to [Airtable.com](https://airtable.com) → Account → Developer Hub
2. **Revoke the existing API key** (pato1OJSu3Jmsh1k2...)
3. **Generate a new personal access token**
4. **Copy the new token** securely

### **Vercel Token**
1. Go to [Vercel.com](https://vercel.com) → Account → Tokens
2. **Create a new deployment token**
3. **Copy the token** securely

## 🔑 Step 2: Set Up GitHub Secrets

### **Navigate to Repository Settings**
1. Go to your repository: `https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball`
2. Click **Settings** tab
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**

### **Add Required Secrets**

| Secret Name | Description | Where to Get |
|-------------|-------------|--------------|
| `VITE_ABS_RPC_URL` | Abstract Network RPC | Use: `https://rpc.abstract.xyz` |
| `VITE_PINATA_API_KEY` | Pinata API Key | [Pinata Dashboard](https://pinata.cloud/keys) |
| `VITE_PINATA_SECRET_API_KEY` | Pinata Secret Key | [Pinata Dashboard](https://pinata.cloud/keys) |
| `VITE_AIRTABLE_API_KEY` | Airtable API Key | [Airtable Developer Hub](https://airtable.com/developers/web/api/introduction) |
| `VITE_AIRTABLE_BASE_ID` | Airtable Base ID | From your Airtable base URL |
| `VERCEL_TOKEN` | Vercel Deployment Token | [Vercel Account Tokens](https://vercel.com/account/tokens) |

### **Secret Setup Instructions**

#### **1. VITE_ABS_RPC_URL**
```
Name: VITE_ABS_RPC_URL
Value: https://rpc.abstract.xyz
```

#### **2. VITE_PINATA_API_KEY** (⚠️ Use NEW key)
```
Name: VITE_PINATA_API_KEY
Value: [YOUR_NEW_PINATA_API_KEY]
```

#### **3. VITE_PINATA_SECRET_API_KEY** (⚠️ Use NEW secret)
```
Name: VITE_PINATA_SECRET_API_KEY
Value: [YOUR_NEW_PINATA_SECRET_KEY]
```

#### **4. VITE_AIRTABLE_API_KEY** (⚠️ Use NEW key)
```
Name: VITE_AIRTABLE_API_KEY
Value: [YOUR_NEW_AIRTABLE_API_KEY]
```

#### **5. VITE_AIRTABLE_BASE_ID**
```
Name: VITE_AIRTABLE_BASE_ID
Value: [YOUR_AIRTABLE_BASE_ID]
```

#### **6. VERCEL_TOKEN**
```
Name: VERCEL_TOKEN
Value: [YOUR_VERCEL_TOKEN]
```

## 📋 Step 3: Verify GitHub Actions Workflow

Your GitHub Actions workflow will automatically inject these secrets during deployment. The workflow is configured in `.github/workflows/deploy.yml`.

## 🔍 Step 4: Test Deployment

After adding all secrets:

1. **Push a commit** to trigger the workflow
2. **Monitor the deployment** at: `https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball/actions`
3. **Check for any errors** in the workflow logs
4. **Verify the live site** works with all integrations

## 📊 Expected Functionality

With these secrets properly configured, your application will support:

### **Web3 Features**
- ✅ Abstract Network blockchain connection
- ✅ Smart contract interactions
- ✅ Wallet integration (MetaMask)

### **IPFS Storage**
- ✅ NFT metadata storage via Pinata
- ✅ Game assets and images
- ✅ Decentralized file storage

### **Database Integration**
- ✅ Player data storage in Airtable
- ✅ Match results and statistics
- ✅ XP and progression tracking
- ✅ Leaderboard functionality

## 🔐 Security Best Practices

### **Do:**
- ✅ Always regenerate compromised API keys
- ✅ Use GitHub Secrets for all sensitive data
- ✅ Set appropriate permissions for API keys
- ✅ Regularly rotate API keys (monthly/quarterly)
- ✅ Monitor API usage for unusual activity

### **Don't:**
- ❌ Share API keys in public messages/code
- ❌ Commit secrets to version control
- ❌ Use the same API keys across environments
- ❌ Give excessive permissions to API keys

## 🚨 Emergency Response

If you suspect API keys have been compromised:

1. **Immediately revoke** all compromised keys
2. **Generate new keys** with minimal required permissions
3. **Update GitHub Secrets** with new keys
4. **Monitor accounts** for unauthorized usage
5. **Review logs** for any suspicious activity

## 📞 Support

If you encounter issues:

1. **Check GitHub Actions logs** for specific error messages
2. **Verify all secrets are set correctly**
3. **Test API keys individually** with their respective services
4. **Consult service documentation** for troubleshooting

## 🎯 Final Checklist

Before considering setup complete:

- [ ] All old API keys have been revoked
- [ ] New API keys have been generated
- [ ] All 6 GitHub Secrets have been added
- [ ] GitHub Actions workflow runs successfully
- [ ] Live application connects to all services
- [ ] All integrations are working properly

---

**Remember: Security is paramount in Web3 development. Never share API keys publicly, and always use secure methods for credential management.**
