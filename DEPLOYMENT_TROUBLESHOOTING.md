# 🚀 Deployment Troubleshooting Guide

## ✅ Local Build Status
- **Build**: ✅ Successful
- **Lint**: ✅ Successful
- **Dependencies**: ✅ All installed
- **Test**: ✅ All checks passed

## 🔧 GitHub Actions Troubleshooting

### 1. Check GitHub Actions Status
Visit your repository's Actions tab:
```
https://github.com/YOUR_USERNAME/hamlite-web3-dodgeball/actions
```

### 2. Required GitHub Secrets
Go to your repository settings → Secrets and variables → Actions, and ensure these secrets are set:

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `VERCEL_TOKEN` | Vercel API token | [Generate at vercel.com/account/tokens](https://vercel.com/account/tokens) |
| `VITE_ABS_RPC_URL` | Abstract Network RPC URL | Use: `https://rpc.abstract.xyz` |
| `VITE_PINATA_API_KEY` | Pinata API key | [Get from pinata.cloud](https://pinata.cloud/keys) |
| `VITE_PINATA_SECRET_API_KEY` | Pinata secret key | [Get from pinata.cloud](https://pinata.cloud/keys) |
| `VITE_AIRTABLE_API_KEY` | Airtable API key | [Get from airtable.com/developers](https://airtable.com/developers/web/api/introduction) |
| `VITE_AIRTABLE_BASE_ID` | Airtable base ID | From your Airtable base URL |

### 3. Common Issues & Solutions

#### Issue: "Error: No token provided"
**Solution**: Ensure `VERCEL_TOKEN` is set in GitHub Secrets
```bash
# Test your token locally (optional)
vercel --token YOUR_TOKEN_HERE
```

#### Issue: "Build failed"
**Solution**: Check environment variables are set
- Verify all 4 secrets are configured
- Ensure secret names match exactly (case-sensitive)

#### Issue: "Permission denied"
**Solution**: Check token permissions
- Generate a new Vercel token with proper scopes
- Ensure token has deployment permissions

#### Issue: "Module not found"
**Solution**: Dependencies issue
- The workflow uses `npm ci` which should work
- Check if package-lock.json is committed

### 4. Manual Deployment Test
If GitHub Actions fails, test manual deployment:

```bash
# 1. Install Vercel CLI
npm install -g vercel

# 2. Login to Vercel
vercel login

# 3. Deploy
vercel --prod
```

### 5. Debug Steps

1. **Check latest commit**:
   ```bash
   git log --oneline -1
   ```

2. **Check GitHub Actions logs**:
   - Go to Actions tab
   - Click on the failed workflow
   - Check each step for errors

3. **Test locally**:
   ```bash
   npm ci
   npm run build
   npm run lint
   ```

4. **Check Vercel project**:
   - Go to vercel.com dashboard
   - Check if project exists
   - Verify domain settings

### 6. Workflow File
The deployment workflow is configured in `.github/workflows/deploy.yml`:
- Triggers on push to main branch
- Builds the project with environment variables
- Deploys to Vercel

### 7. Contact Support
If issues persist:
1. Check GitHub Actions logs for specific errors
2. Verify all secrets are correctly set
3. Test manual deployment
4. Share specific error messages for targeted help

## 🎯 Next Steps
1. ✅ Set up GitHub Secrets (4 required)
2. ✅ Push changes to trigger deployment
3. ✅ Monitor deployment status
4. ✅ Test live application

## 📞 Getting Help
If you encounter specific errors, please share:
- GitHub Actions log output
- Error messages
- Screenshots of secret configuration
- Any other relevant details

The project is **ready for deployment** - just needs proper secrets configuration!
