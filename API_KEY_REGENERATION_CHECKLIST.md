# 🔄 API Key Regeneration Checklist

## ⚠️ URGENT: Complete This Checklist Before Deployment

### **1. Pinata API Keys** ❌ **COMPROMISED - REGENERATE NOW**
- [ ] **Login to Pinata**: https://pinata.cloud/keys
- [ ] **Delete old API key**: `ccdd628d6e4744b23601`
- [ ] **Generate new API key** with these permissions:
  - [x] `pinFileToIPFS`
  - [x] `pinJSONToIPFS`
  - [x] `userPinList`
  - [x] `userPinPolicy`
- [ ] **Copy new API key**: `NEW_PINATA_API_KEY_HERE`
- [ ] **Copy new secret**: `NEW_PINATA_SECRET_HERE`

### **2. Airtable API Key** ❌ **COMPROMISED - REGENERATE NOW**
- [ ] **Login to Airtable**: https://airtable.com/developers/web/api/introduction
- [ ] **Revoke old token**: `pato1OJSu3Jmsh1k2...`
- [ ] **Create new personal access token** with these scopes:
  - [x] `data.records:read`
  - [x] `data.records:write`
  - [x] `schema.bases:read`
- [ ] **Copy new token**: `NEW_AIRTABLE_TOKEN_HERE`
- [ ] **Get base ID from your Airtable URL**: `appXXXXXXXXXXXXXX`

### **3. Vercel Token** ✅ **GENERATE NEW**
- [ ] **Login to Vercel**: https://vercel.com/account/tokens
- [ ] **Create new token** with these permissions:
  - [x] `Deploy`
  - [x] `Read and Write`
- [ ] **Copy new token**: `NEW_VERCEL_TOKEN_HERE`

### **4. Abstract Network RPC** ✅ **PUBLIC ENDPOINT**
- [ ] **RPC URL**: `https://rpc.abstract.xyz`
- [ ] **Chain ID**: `11124` (0x2B6C)
- [ ] **Currency**: `ETH`

---

## 🔐 GitHub Secrets Setup

### **Method 1: Web Interface (Recommended)**
1. Go to: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/settings/secrets/actions
2. Click "New repository secret"
3. Add each secret:

| Secret Name | Value | Status |
|-------------|-------|---------|
| `VERCEL_TOKEN` | [Your NEW Vercel token] | ⏳ Pending |
| `VITE_ABS_RPC_URL` | `https://rpc.abstract.xyz` | ⏳ Pending |
| `VITE_PINATA_API_KEY` | [Your NEW Pinata API key] | ⏳ Pending |
| `VITE_PINATA_SECRET_API_KEY` | [Your NEW Pinata secret] | ⏳ Pending |
| `VITE_AIRTABLE_API_KEY` | [Your NEW Airtable token] | ⏳ Pending |
| `VITE_AIRTABLE_BASE_ID` | [Your Airtable base ID] | ⏳ Pending |

### **Method 2: GitHub CLI**
```bash
gh auth login
gh secret set VERCEL_TOKEN
gh secret set VITE_ABS_RPC_URL
gh secret set VITE_PINATA_API_KEY
gh secret set VITE_PINATA_SECRET_API_KEY
gh secret set VITE_AIRTABLE_API_KEY
gh secret set VITE_AIRTABLE_BASE_ID
```

---

## 🧪 Testing Deployment

### **1. Test Commit**
```bash
git add .
git commit -m "🚀 test: trigger secure deployment"
git push origin main
```

### **2. Monitor Deployment**
- **GitHub Actions**: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions
- **Expected build time**: ~2-3 minutes
- **Expected bundle size**: ~410KB

### **3. Verify Live Site**
- **Vercel URL**: Will be provided after deployment
- **Test wallet connection**: MetaMask integration
- **Test game functionality**: Dodgeball gameplay
- **Test Web3 features**: Abstract Network switching

---

## ✅ Post-Deployment Verification

### **Web3 Integration**
- [ ] MetaMask connects successfully
- [ ] Network switches to Abstract
- [ ] Wallet address displays correctly
- [ ] Game starts and functions properly

### **IPFS Integration**
- [ ] Pinata connection works
- [ ] File uploads (if applicable)
- [ ] Metadata storage functions

### **Database Integration**
- [ ] Airtable connection established
- [ ] Player data can be stored
- [ ] Game results are recorded

---

## 🔒 Security Verification

### **Confirm Secrets Are Secure**
- [ ] All old API keys have been revoked
- [ ] New API keys have minimal required permissions
- [ ] GitHub Secrets are properly configured
- [ ] No API keys are exposed in code or logs

### **Test Access Control**
- [ ] API keys work with expected permissions
- [ ] Unauthorized access is blocked
- [ ] Rate limiting is properly configured

---

## 📊 Success Metrics

### **Deployment Success**
- [ ] GitHub Actions workflow completes successfully
- [ ] Build generates without errors
- [ ] Vercel deployment succeeds
- [ ] Live site loads without errors

### **Functionality Success**
- [ ] All Web3 features work
- [ ] Game plays smoothly
- [ ] Database operations succeed
- [ ] IPFS storage functions

---

## 🆘 Troubleshooting

If deployment fails:
1. Check GitHub Actions logs for specific errors
2. Verify all secrets are set correctly
3. Test API keys individually
4. Consult `DEPLOYMENT_TROUBLESHOOTING.md`
5. Review `GITHUB_SECRETS_SECURITY_GUIDE.md`

---

## 📞 Support Resources

- **GitHub Actions**: https://github.com/JohnnyButtersfingers/hamlite-web3-dodgeball/actions
- **Vercel Dashboard**: https://vercel.com/dashboard
- **Pinata Dashboard**: https://pinata.cloud/pinmanager
- **Airtable Base**: https://airtable.com/
- **Abstract Network**: https://docs.abs.xyz/

---

**✅ Mark each item as complete before proceeding to the next step!**
