import { useState, useEffect } from 'react'
import { ethers } from 'ethers'

import GameArena from './components/GameArena'
import HamsterSports from './components/HamsterSports'

import './App.css'

function App() {
  const [account, setAccount] = useState(null)
  const [provider, setProvider] = useState(null)
  const [isConnecting, setIsConnecting] = useState(false)
  const [isConnected, setIsConnected] = useState(false)
  const [networkName, setNetworkName] = useState('')
  const [gameMode, setGameMode] = useState('hamster-sports') // New: Game mode selection

  const connectWallet = async () => {
    if (window.ethereum) {
      try {
        setIsConnecting(true)
        const accounts = await window.ethereum.request({
          method: 'eth_requestAccounts',
        })
        setAccount(accounts[0])
        
        const provider = new ethers.BrowserProvider(window.ethereum)
        setProvider(provider)
        
        // Get network info
        const network = await provider.getNetwork()
        setNetworkName(network.name)
        setIsConnected(true)
        
        // Try to switch to Abstract Network
        await switchToAbstractNetwork()
      } catch (error) {
        console.error('Error connecting wallet:', error)
        alert('Error connecting wallet. Please try again.')
      } finally {
        setIsConnecting(false)
      }
    } else {
      alert('Please install a Web3 wallet (MetaMask, Abstract Wallet, or compatible) to play this game!')
    }
  }

  const switchToAbstractNetwork = async () => {
    try {
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: '0x28c58' }], // Abstract Mainnet
      })
      setNetworkName('Abstract')
    } catch (switchError) {
      if (switchError.code === 4902) {
        try {
          await window.ethereum.request({
            method: 'wallet_addEthereumChain',
            params: [{
              chainId: '0x28c58',
              chainName: 'Abstract',
              nativeCurrency: {
                name: 'ETH',
                symbol: 'ETH',
                decimals: 18
              },
              rpcUrls: [import.meta.env.VITE_ABS_RPC_URL || 'https://rpc.abstract.xyz'],
              blockExplorerUrls: ['https://explorer.abstract.xyz']
            }]
          })
          setNetworkName('Abstract')
        } catch (addError) {
          console.error('Error adding Abstract network:', addError)
        }
      }
    }
  }

  const disconnectWallet = () => {
    setAccount(null)
    setProvider(null)
    setIsConnected(false)
    setNetworkName('')
  }

  useEffect(() => {
    // Check if wallet is already connected
    if (window.ethereum) {
      window.ethereum.request({ method: 'eth_accounts' })
        .then(accounts => {
          if (accounts.length > 0) {
            setAccount(accounts[0])
            const provider = new ethers.BrowserProvider(window.ethereum)
            setProvider(provider)
            setIsConnected(true)
            
            // Get network info
            provider.getNetwork().then(network => {
              setNetworkName(network.name)
            })
          }
        })
        .catch(console.error)
    }
  }, [])

  return (
    <div className="App">
      <header className="App-header">
        <h1>🐹 Hamlite Hamster Sports Arena</h1>
        <p>Predict. Play. Win. on Abstract Network</p>
        
        {!isConnected ? (
          <div className="connect-section">
            <button 
              onClick={connectWallet} 
              className="connect-btn"
              disabled={isConnecting}
            >
              {isConnecting ? 'Connecting...' : 'Connect to Play'}
            </button>
            <p className="info-text">
              Connect your Abstract wallet to predict hamster sports matches and earn XP!
            </p>
            <div className="features">
              <div className="feature">
                <span className="feature-icon">🐹</span>
                <span>4-Team Hamster Battles</span>
              </div>
              <div className="feature">
                <span className="feature-icon">�</span>
                <span>Prediction System</span>
              </div>
              <div className="feature">
                <span className="feature-icon">🏆</span>
                <span>MVP Voting & XP</span>
              </div>
              <div className="feature">
                <span className="feature-icon">🎲</span>
                <span>Provably Fair RNG</span>
              </div>
            </div>
          </div>
        ) : (
          <div className="game-section">
            <div className="wallet-info">
              <span>Connected: {account?.slice(0, 6)}...{account?.slice(-4)}</span>
              <span>Network: {networkName}</span>
              <button onClick={disconnectWallet} className="disconnect-btn">
                Disconnect
              </button>
            </div>
            
            {/* Game Mode Selection */}
            <div className="game-mode-selector">
              <button 
                className={`mode-btn ${gameMode === 'hamster-sports' ? 'active' : ''}`}
                onClick={() => setGameMode('hamster-sports')}
              >
                🐹 Hamster Sports
              </button>
              <button 
                className={`mode-btn ${gameMode === 'classic-dodgeball' ? 'active' : ''}`}
                onClick={() => setGameMode('classic-dodgeball')}
              >
                🏐 Classic Dodgeball
              </button>
            </div>

            {/* Render Selected Game Mode */}
            {gameMode === 'hamster-sports' ? (
              <HamsterSports account={account} provider={provider} />
            ) : (
              <GameArena account={account} provider={provider} />
            )}
          </div>
        )}
        
        <footer className="footer">
          <p>Built with React, Vite, and Ethers.js</p>
          <p>Hamster Sports powered by Abstract Network</p>
        </footer>
      </header>
    </div>
  )
}

export default App
