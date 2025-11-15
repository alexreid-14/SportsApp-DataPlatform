-- ============================================================================
-- GAMES_RAW TABLE: Stores raw game data from NBA API
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.games_raw (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    game_date DATE NOT NULL,
    game_type VARCHAR(20), -- 'regular', 'playoff', 'playin'
    season VARCHAR(10) NOT NULL,
    team_id INTEGER NOT NULL,
    matchup VARCHAR(100),
    points INTEGER,
    is_win BOOLEAN,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, team_id)
);

-- ============================================================================
-- LINEUPS TABLE: Stores lineup statistics for each team in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.lineups (
    group_id VARCHAR(50) NOT NULL,
    group_name VARCHAR(200),
    team_id INTEGER,
    team_name VARCHAR(100),
    season VARCHAR(10) NOT NULL,
    games_played INTEGER,
    wins INTEGER,
    losses INTEGER,
    minutes_played DECIMAL(10,2),
    off_rating DECIMAL(10,2),
    def_rating DECIMAL(10,2),
    net_rating DECIMAL(10,2),
    ast_pct DECIMAL(10,2),
    ast_to DECIMAL(10,2),
    ast_ratio DECIMAL(10,2),
    oreb_pct DECIMAL(10,2),
    dreb_pct DECIMAL(10,2),
    reb_pct DECIMAL(10,2),
    tm_tov_pct DECIMAL(10,2),
    efg_pct DECIMAL(10,2),
    ts_pct DECIMAL(10,2),
    usg_pct DECIMAL(10,2),
    e_usg_pct DECIMAL(10,2),
    e_pace DECIMAL(10,2),
    pace DECIMAL(10,2),
    pace_per40 DECIMAL(10,2),
    poss INTEGER,
    pie DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, season)
);
