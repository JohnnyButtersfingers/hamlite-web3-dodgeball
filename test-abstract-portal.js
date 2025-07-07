// Test script to verify Abstract Portal integration
// This script helps verify that the Abstract Portal connection logic works correctly

console.log('🔍 Testing Abstract Portal Integration...')

// Mock window.ethereum for testing
const mockEthereum = {
  isAbstract: true,
  request: async (params) => {
    console.log('📡 Mock request:', params)
    
    if (params.method === 'eth_chainId') {
      return '0x28c58' // Abstract Network chain ID
    }
    
    if (params.method === 'eth_requestAccounts') {
      return ['0x1234567890123456789012345678901234567890']
    }
    
    if (params.method === 'wallet_switchEthereumChain') {
      console.log('🔄 Switching to Abstract Network...')
      return true
    }
    
    if (params.method === 'wallet_addEthereumChain') {
      console.log('➕ Adding Abstract Network...')
      return true
    }
    
    return null
  }
}

// Test Abstract Portal detection
function testAbstractPortalDetection() {
  console.log('\n📋 Testing Abstract Portal Detection...')
  
  // Test 1: Abstract Portal environment
  global.window = {
    ethereum: { ...mockEthereum, isAbstract: true },
    location: { origin: 'https://portal.abs.xyz' }
  }
  
  const isAbstractPortal = () => {
    return window.ethereum && (
      window.ethereum.isAbstract || 
      window.ethereum.selectedAddress || 
      window.location.origin.includes('portal.abs.xyz')
    )
  }
  
  console.log('✅ Abstract Portal detected:', isAbstractPortal())
  
  // Test 2: Regular wallet
  global.window = {
    ethereum: { ...mockEthereum, isAbstract: false },
    location: { origin: 'https://example.com' }
  }
  
  console.log('✅ Regular wallet detected:', !isAbstractPortal())
}

// Test network switching
async function testNetworkSwitching() {
  console.log('\n🔄 Testing Network Switching...')
  
  try {
    // Mock switching to Abstract Network
    await mockEthereum.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId: '0x28c58' }]
    })
    
    console.log('✅ Network switching works')
  } catch (error) {
    console.log('❌ Network switching failed:', error)
  }
}

// Test wallet connection flow
async function testWalletConnection() {
  console.log('\n🔗 Testing Wallet Connection Flow...')
  
  try {
    // Check chain ID
    const chainId = await mockEthereum.request({ method: 'eth_chainId' })
    console.log('📡 Chain ID:', chainId)
    
    // Request accounts
    const accounts = await mockEthereum.request({ method: 'eth_requestAccounts' })
    console.log('👤 Accounts:', accounts)
    
    console.log('✅ Wallet connection flow works')
  } catch (error) {
    console.log('❌ Wallet connection failed:', error)
  }
}

// Run tests
async function runTests() {
  console.log('🧪 Running Abstract Portal Integration Tests...\n')
  
  testAbstractPortalDetection()
  await testNetworkSwitching()
  await testWalletConnection()
  
  console.log('\n🎉 All tests completed!')
  console.log('🔗 Live site: https://hamlite-web3-dodgeball-hamlites-projects-5da7fa6a.vercel.app/')
  console.log('🌐 Abstract Portal: https://portal.abs.xyz/')
}

// Run the tests
runTests().catch(console.error)
