# Hamlite Web3 Dodgeball 🎮⚡

A Web3-enabled dodgeball game built with React and deployed on the Abstract blockchain network.

## 🚀 Features

- **Web3 Integration**: Connect your wallet and play on-chain
- **Abstract Network**: Built on Abstract's high-performance blockchain
- **IPFS Storage**: Game assets stored on IPFS via Pinata
- **Modern UI**: Built with React and Vite for optimal performance

## 🛠️ Tech Stack

- **Frontend**: React 18 + Vite
- **Blockchain**: Abstract Network (Ethereum L2)
- **Web3**: Ethers.js v6
- **Storage**: IPFS via Pinata
- **Deployment**: Vercel
- **CI/CD**: GitHub Actions

## 🏗️ Development

```bash
# Install dependencies
npm install

# Start development server
npm run dev

# Build for production
npm run build

# Run tests
npm test

# Lint code
npm run lint
```

## 🔧 Environment Variables

Create a `.env` file based on `.env.example`:

```bash
VITE_ABS_RPC_URL=https://rpc.abstract.xyz
VITE_PINATA_API_KEY=your-pinata-api-key
VITE_PINATA_SECRET_API_KEY=your-pinata-secret-key
```

## 📦 Deployment

This project uses GitHub Actions for automated deployment to Vercel. Set up the following secrets in your repository:

- `VERCEL_TOKEN`
- `VITE_ABS_RPC_URL`
- `VITE_PINATA_API_KEY`
- `VITE_PINATA_SECRET_API_KEY`

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Abstract Network for blockchain infrastructure
- Pinata for IPFS storage solutions
- Vercel for deployment platform