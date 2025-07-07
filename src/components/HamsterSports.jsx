import { useState, useEffect } from 'react'
import './HamsterSports.css'

const HamsterSports = ({ account, provider }) => {
  const [currentView, setCurrentView] = useState('arena') // arena, predictions, leaderboard
  const [playerData, setPlayerData] = useState(null)
  const [currentMatch, setCurrentMatch] = useState(null)
  const [teams, setTeams] = useState([])
  const [isLoading, setIsLoading] = useState(true)

  // Team configurations
  const TEAMS = {
    alpha: { 
      name: 'Alpha', 
      color: '#ff4757', 
      hamsters: ['Speedy', 'Dash', 'Lightning'],
      wins: 0,
      stats: { speed: 85, accuracy: 78, teamwork: 82 }
    },
    beta: { 
      name: 'Beta', 
      color: '#2f3542', 
      hamsters: ['Thunder', 'Storm', 'Blitz'],
      wins: 0,
      stats: { speed: 80, accuracy: 85, teamwork: 79 }
    },
    gamma: { 
      name: 'Gamma', 
      color: '#3742fa', 
      hamsters: ['Rocket', 'Zoom', 'Flash'],
      wins: 0,
      stats: { speed: 88, accuracy: 75, teamwork: 85 }
    },
    delta: { 
      name: 'Delta', 
      color: '#2ed573', 
      hamsters: ['Ninja', 'Swift', 'Bolt'],
      wins: 0,
      stats: { speed: 82, accuracy: 88, teamwork: 78 }
    }
  }

  useEffect(() => {
    initializePlayer()
    loadCurrentMatch()
  }, [account])

  const initializePlayer = async () => {
    try {
      setIsLoading(true)
      // TODO: Check if player exists in Airtable
      // For now, create a mock player
      const mockPlayer = {
        walletAddress: account,
        username: `Player_${account?.slice(-4)}`,
        totalXP: 0,
        correctPredictions: 0,
        totalPredictions: 0,
        favoriteTeam: null,
        joinDate: new Date().toISOString()
      }
      setPlayerData(mockPlayer)
    } catch (error) {
      console.error('Error initializing player:', error)
    } finally {
      setIsLoading(false)
    }
  }

  const loadCurrentMatch = async () => {
    try {
      // TODO: Load current/upcoming match from backend
      // For now, create a mock match
      const mockMatch = {
        id: `match_${Date.now()}`,
        status: 'upcoming', // upcoming, live, completed
        teams: ['alpha', 'beta'], // Teams playing in this match
        round: 1,
        maxRounds: 3,
        startTime: new Date(Date.now() + 300000), // 5 minutes from now
        bettingDeadline: new Date(Date.now() + 240000), // 4 minutes from now
        prizePool: 1000,
        currentSeed: null,
        results: null
      }
      setCurrentMatch(mockMatch)
      setTeams([TEAMS.alpha, TEAMS.beta, TEAMS.gamma, TEAMS.delta])
    } catch (error) {
      console.error('Error loading match:', error)
    }
  }

  const ArenaView = () => (
    <div className="hamster-arena">
      <div className="arena-header">
        <h2>🏟️ Hamster Sports Arena</h2>
        <div className="match-info">
          {currentMatch && (
            <>
              <div className="match-status">
                <span className={`status-badge ${currentMatch.status}`}>
                  {currentMatch.status.toUpperCase()}
                </span>
                <span className="match-round">
                  Round {currentMatch.round} of {currentMatch.maxRounds}
                </span>
              </div>
              <div className="match-teams">
                <div className="team" style={{ borderColor: TEAMS[currentMatch.teams[0]].color }}>
                  <div className="team-name">{TEAMS[currentMatch.teams[0]].name}</div>
                  <div className="team-hamsters">
                    {TEAMS[currentMatch.teams[0]].hamsters.map((hamster, idx) => (
                      <span key={idx} className="hamster-name">🐹 {hamster}</span>
                    ))}
                  </div>
                </div>
                <div className="vs-divider">VS</div>
                <div className="team" style={{ borderColor: TEAMS[currentMatch.teams[1]].color }}>
                  <div className="team-name">{TEAMS[currentMatch.teams[1]].name}</div>
                  <div className="team-hamsters">
                    {TEAMS[currentMatch.teams[1]].hamsters.map((hamster, idx) => (
                      <span key={idx} className="hamster-name">🐹 {hamster}</span>
                    ))}
                  </div>
                </div>
              </div>
            </>
          )}
        </div>
      </div>

      <div className="court-container">
        <div className="dodgeball-court">
          <div className="court-line center-line"></div>
          <div className="court-section left-section">
            <div className="team-area" style={{ backgroundColor: `${TEAMS.alpha?.color}20` }}>
              <div className="team-label">Team Alpha</div>
              {/* Hamster positions will be animated here */}
              <div className="hamster-positions">
                <div className="hamster hamster-1">🐹</div>
                <div className="hamster hamster-2">🐹</div>
                <div className="hamster hamster-3">🐹</div>
              </div>
            </div>
          </div>
          
          <div className="court-section center-section">
            <div className="cheese-puff-zone">
              <div className="cheese-puff">🧀</div>
              <div className="court-center-label">Cheese Puff Zone</div>
            </div>
          </div>
          
          <div className="court-section right-section">
            <div className="team-area" style={{ backgroundColor: `${TEAMS.beta?.color}20` }}>
              <div className="team-label">Team Beta</div>
              <div className="hamster-positions">
                <div className="hamster hamster-1">🐹</div>
                <div className="hamster hamster-2">🐹</div>
                <div className="hamster hamster-3">🐹</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="game-controls">
        <div className="timer-section">
          <div className="countdown">
            <span className="countdown-label">Next Match In:</span>
            <span className="countdown-timer">04:32</span>
          </div>
        </div>
        
        <div className="action-buttons">
          <button 
            className="action-btn primary"
            onClick={() => setCurrentView('predictions')}
          >
            🎯 Make Predictions
          </button>
          <button 
            className="action-btn secondary"
            onClick={() => setCurrentView('leaderboard')}
          >
            🏆 Leaderboard
          </button>
        </div>
      </div>
    </div>
  )

  const PredictionView = () => (
    <div className="predictions-panel">
      <div className="panel-header">
        <h2>🎯 Match Predictions</h2>
        <button 
          className="back-btn"
          onClick={() => setCurrentView('arena')}
        >
          ← Back to Arena
        </button>
      </div>

      <div className="prediction-sections">
        <div className="team-prediction-section">
          <h3>Team Winner Prediction (10 XP)</h3>
          <div className="team-selection">
            {currentMatch?.teams.map(teamKey => {
              const team = TEAMS[teamKey]
              return (
                <div key={teamKey} className="team-option" style={{ borderColor: team.color }}>
                  <div className="team-header">
                    <span className="team-name">{team.name}</span>
                    <div className="team-stats">
                      <span>Speed: {team.stats.speed}</span>
                      <span>Accuracy: {team.stats.accuracy}</span>
                      <span>Teamwork: {team.stats.teamwork}</span>
                    </div>
                  </div>
                  <div className="team-roster">
                    {team.hamsters.map((hamster, idx) => (
                      <span key={idx} className="hamster-chip">🐹 {hamster}</span>
                    ))}
                  </div>
                  <button className="predict-btn">
                    Predict {team.name} Wins
                  </button>
                </div>
              )
            })}
          </div>
        </div>

        <div className="mvp-prediction-section">
          <h3>MVP Prediction (20 XP)</h3>
          <div className="mvp-selection">
            <p>Select the hamster you think will be named MVP:</p>
            <div className="hamster-grid">
              {currentMatch?.teams.flatMap(teamKey => 
                TEAMS[teamKey].hamsters.map((hamster, idx) => (
                  <div key={`${teamKey}-${idx}`} className="hamster-option">
                    <div className="hamster-avatar">🐹</div>
                    <div className="hamster-info">
                      <span className="hamster-name">{hamster}</span>
                      <span className="team-badge" style={{ backgroundColor: TEAMS[teamKey].color }}>
                        {TEAMS[teamKey].name}
                      </span>
                    </div>
                    <button className="mvp-btn">Predict MVP</button>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>

        <div className="fairness-section">
          <h3>🎲 Provably Fair System</h3>
          <div className="fairness-info">
            <p>This match uses cryptographic seeds to ensure fairness:</p>
            <div className="seed-info">
              <span className="seed-label">Match Seed (Committed):</span>
              <span className="seed-hash">abc123...def456</span>
            </div>
            <p className="fairness-note">
              Seeds are generated before betting closes and revealed after the match.
              You can verify the results were not manipulated.
            </p>
          </div>
        </div>
      </div>
    </div>
  )

  const LeaderboardView = () => (
    <div className="leaderboard-panel">
      <div className="panel-header">
        <h2>🏆 Global Leaderboard</h2>
        <button 
          className="back-btn"
          onClick={() => setCurrentView('arena')}
        >
          ← Back to Arena
        </button>
      </div>

      <div className="leaderboard-content">
        <div className="player-stats">
          <h3>Your Stats</h3>
          <div className="stats-grid">
            <div className="stat-item">
              <span className="stat-value">{playerData?.totalXP || 0}</span>
              <span className="stat-label">Total XP</span>
            </div>
            <div className="stat-item">
              <span className="stat-value">
                {playerData?.totalPredictions > 0 
                  ? Math.round((playerData.correctPredictions / playerData.totalPredictions) * 100)
                  : 0}%
              </span>
              <span className="stat-label">Accuracy</span>
            </div>
            <div className="stat-item">
              <span className="stat-value">{playerData?.correctPredictions || 0}</span>
              <span className="stat-label">Correct Predictions</span>
            </div>
          </div>
        </div>

        <div className="global-rankings">
          <h3>Top Players</h3>
          <div className="ranking-list">
            {/* Mock leaderboard data */}
            {[
              { rank: 1, username: 'HamsterMaster', xp: 2450, accuracy: 87 },
              { rank: 2, username: 'CheeseHunter', xp: 2100, accuracy: 82 },
              { rank: 3, username: 'DodgeballPro', xp: 1850, accuracy: 79 },
              { rank: 4, username: 'AlphaFan', xp: 1620, accuracy: 75 },
              { rank: 5, username: 'BetaBeliever', xp: 1430, accuracy: 78 }
            ].map((player) => (
              <div key={player.rank} className="ranking-item">
                <div className="rank-badge">#{player.rank}</div>
                <div className="player-info">
                  <span className="username">{player.username}</span>
                  <div className="player-stats-mini">
                    <span>{player.xp} XP</span>
                    <span>{player.accuracy}% accuracy</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  )

  if (isLoading) {
    return (
      <div className="loading-container">
        <div className="loading-spinner">🐹</div>
        <p>Loading Hamster Sports Arena...</p>
      </div>
    )
  }

  return (
    <div className="hamster-sports-container">
      {currentView === 'arena' && <ArenaView />}
      {currentView === 'predictions' && <PredictionView />}
      {currentView === 'leaderboard' && <LeaderboardView />}
    </div>
  )
}

export default HamsterSports
