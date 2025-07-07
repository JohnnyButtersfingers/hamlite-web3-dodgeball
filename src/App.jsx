import { useState, useEffect } from 'react'
import { ethers } from 'ethers'

import GameArena from './components/GameArena'

import './App.css'

function App() {
  const [account, setAccount] = useState(null)
  const [provider, setProvider] = useState(null)
  const [isConnecting, setIsConnecting] = useState(false)
  const [isConnected, setIsConnected] = useState(false)
  const [networkName, setNetworkName] = useState('')

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
        <h1>🏐 Hamlite Web3 Dodgeball</h1>
        <p>Decentralized Dodgeball Game on Abstract Network</p>
        
        {!isConnected ? (
          <div className="connect-section">
            <button 
              onClick={connectWallet} 
              className="connect-btn"
              disabled={isConnecting}
            >
              {isConnecting ? 'Connecting...' : 'Connect Abstract Wallet'}
            </button>
            <p className="info-text">
              Connect your Abstract wallet (MetaMask, Abstract Wallet, or compatible) to start playing!
            </p>
            <div className="features">
              <div className="feature">
                <span className="feature-icon">🎮</span>
                <span>Interactive Gameplay</span>
              </div>
              <div className="feature">
                <span className="feature-icon">🏆</span>
                <span>Score System</span>
              </div>
              <div className="feature">
                <span className="feature-icon">🔗</span>
                <span>Web3 Integration</span>
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
            <GameArena account={account} provider={provider} />
          </div>
        )}
        
        <footer className="footer">
          <p>Built with React, Vite, and Ethers.js</p>
          <p>Deployed on Abstract Network</p>
        </footer>
      </header>
    </div>
  )
}

export default App
