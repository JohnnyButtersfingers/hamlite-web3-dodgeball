import { useState, useEffect, useCallback } from 'react'
import './GameArena.css'

const GameArena = ({ account }) => {
  const [gameState, setGameState] = useState('waiting') // waiting, playing, gameOver
  const [players, setPlayers] = useState([])
  const [balls, setBalls] = useState([])
  const [score, setScore] = useState(0)
  const [timeLeft, setTimeLeft] = useState(60)

  // Game mechanics
  const startGame = useCallback(() => {
    setGameState('playing')
    setScore(0)
    setTimeLeft(60)
    
    // Initialize players
    setPlayers([
      { id: 1, x: 100, y: 200, health: 100, isPlayer: true },
      { id: 2, x: 500, y: 200, health: 100, isPlayer: false },
      { id: 3, x: 300, y: 100, health: 100, isPlayer: false }
    ])
  }, [])

  const throwBall = useCallback((targetX, targetY) => {
    const newBall = {
      id: Date.now(),
      x: 100,
      y: 200,
      targetX,
      targetY,
      speed: 5,
      damage: 25
    }
    setBalls(prev => [...prev, newBall])
  }, [])

  // Hit detection
  const checkHit = useCallback((ball, player) => {
    const distance = Math.sqrt(
      Math.pow(ball.x - player.x, 2) + Math.pow(ball.y - player.y, 2)
    )
    return distance < 30 // Hit radius
  }, [])

  // Game timer
  useEffect(() => {
    if (gameState === 'playing' && timeLeft > 0) {
      const timer = setTimeout(() => {
        setTimeLeft(prev => prev - 1)
      }, 1000)
      return () => clearTimeout(timer)
    } else if (timeLeft === 0) {
      setGameState('gameOver')
    }
  }, [gameState, timeLeft])

  // Ball animation and collision detection
  useEffect(() => {
    if (gameState === 'playing') {
      const interval = setInterval(() => {
        setBalls(prev => {
          const activeBalls = []
          
          prev.forEach(ball => {
            // Move ball towards target
            const newX = ball.x + (ball.targetX - ball.x) * 0.1
            const newY = ball.y + (ball.targetY - ball.y) * 0.1
            
            // Check if ball reached target or hit player
            const reachedTarget = Math.abs(newX - ball.targetX) < 5 && Math.abs(newY - ball.targetY) < 5
            
            if (!reachedTarget) {
              // Check collision with enemies
              let hitEnemy = false
              setPlayers(prevPlayers => prevPlayers.map(player => {
                if (!player.isPlayer && checkHit({ x: newX, y: newY }, player)) {
                  hitEnemy = true
                  setScore(prevScore => prevScore + 100)
                  return { ...player, health: Math.max(0, player.health - ball.damage) }
                }
                return player
              }))
              
              if (!hitEnemy) {
                activeBalls.push({ ...ball, x: newX, y: newY })
              }
            }
          })
          
          return activeBalls
        })
      }, 50)
      return () => clearInterval(interval)
    }
  }, [gameState, checkHit])

  // AI enemy ball throwing
  useEffect(() => {
    if (gameState === 'playing') {
      const aiInterval = setInterval(() => {
        if (Math.random() < 0.3) { // 30% chance to throw
          const enemyBall = {
            id: Date.now() + Math.random(),
            x: 500,
            y: 200,
            targetX: 100 + Math.random() * 50,
            targetY: 200 + Math.random() * 50,
            speed: 4,
            damage: 20,
            isEnemyBall: true
          }
          setBalls(prev => [...prev, enemyBall])
        }
      }, 2000)
      return () => clearInterval(aiInterval)
    }
  }, [gameState])

  return (
    <div className="game-arena">
      <div className="game-header">
        <div className="game-stats">
          <span>Score: {score}</span>
          <span>Time: {timeLeft}s</span>
          <span>Connected: {account?.slice(0, 6)}...{account?.slice(-4)}</span>
        </div>
      </div>

      <div className="game-field" onClick={(e) => {
        if (gameState === 'playing') {
          const rect = e.currentTarget.getBoundingClientRect()
          throwBall(e.clientX - rect.left, e.clientY - rect.top)
        }
      }}>
        {/* Players */}
        {players.map(player => (
          <div
            key={player.id}
            className={`player ${player.isPlayer ? 'main-player' : 'enemy'}`}
            style={{ left: player.x, top: player.y }}
          >
            <div className="health-bar">
              <div 
                className="health-fill"
                style={{ width: `${player.health}%` }}
              />
            </div>
          </div>
        ))}

        {/* Balls */}
        {balls.map(ball => (
          <div
            key={ball.id}
            className={`ball ${ball.isEnemyBall ? 'enemy-ball' : 'player-ball'}`}
            style={{ left: ball.x, top: ball.y }}
          />
        ))}
      </div>

      <div className="game-controls">
        {gameState === 'waiting' && (
          <div className="start-section">
            <button onClick={startGame} className="start-btn">
              🎮 Start Game
            </button>
            <p className="game-info">
              Click anywhere on the field to throw balls at enemies!
            </p>
          </div>
        )}
        
        {gameState === 'playing' && (
          <div className="instructions">
            <p>🎯 Click anywhere to throw a ball!</p>
            <p>🛡️ Avoid red enemy balls and hit your opponents!</p>
          </div>
        )}
        
        {gameState === 'gameOver' && (
          <div className="game-over">
            <h2>🎉 Game Over!</h2>
            <p>Final Score: <span className="final-score">{score}</span></p>
            <button onClick={startGame} className="restart-btn">
              🔄 Play Again
            </button>
          </div>
        )}
      </div>
    </div>
  )
}

export default GameArena
