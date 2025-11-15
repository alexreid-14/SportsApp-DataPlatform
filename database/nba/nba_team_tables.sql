-- ============================================================================
-- TEAMS TABLE: Stores team information and location data
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.teams (
    id SERIAL PRIMARY KEY,
    team_id INTEGER UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    abbreviation VARCHAR(10) NOT NULL,
    nickname VARCHAR(100),
    city VARCHAR(100),
    state VARCHAR(50),
    year_founded INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- TEAM_BOX_SCORES TABLE: Stores team box score statistics for each team in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.team_box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    team_name VARCHAR(100),
    team_abbreviation VARCHAR(10),
    team_city VARCHAR(50),
    minutes_played DECIMAL(5,2),
    field_goals_made INTEGER,
    field_goals_attempted INTEGER,
    field_goal_pct DECIMAL(5,3),
    three_pointers_made INTEGER,
    three_pointers_attempted INTEGER,
    three_pointer_pct DECIMAL(5,3),
    free_throws_made INTEGER,
    free_throws_attempted INTEGER,
    free_throw_pct DECIMAL(5,3),
    offensive_rebounds INTEGER,
    defensive_rebounds INTEGER,
    rebounds INTEGER,
    assists INTEGER,
    steals INTEGER,
    blocks INTEGER,
    turnovers INTEGER,
    personal_fouls INTEGER,
    points INTEGER,
    plus_minus INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, team_id)
);

-- ============================================================================
-- TEAM_ADVANCED_BOX_SCORES TABLE: Stores advanced team box score statistics for each team in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.team_advanced_box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    team_name VARCHAR(100),
    team_abbreviation VARCHAR(10),
    team_city VARCHAR(50),
    minutes_played DECIMAL(5,2),
    off_rating DECIMAL(6,2),
    def_rating DECIMAL(6,2),
    net_rating DECIMAL(6,2),
    e_off_rating DECIMAL(6,2),
    e_def_rating DECIMAL(6,2),
    e_net_rating DECIMAL(6,2),
    ast_pct DECIMAL(5,2),
    ast_to DECIMAL(5,2),
    ast_ratio DECIMAL(5,2),
    oreb_pct DECIMAL(5,2),
    dreb_pct DECIMAL(5,2),
    reb_pct DECIMAL(5,2),
    tm_tov_pct DECIMAL(5,2),
    e_tm_tov_pct DECIMAL(5,2),
    efg_pct DECIMAL(5,3),
    ts_pct DECIMAL(5,3),
    usg_pct DECIMAL(5,2),
    e_usg_pct DECIMAL(5,2),
    e_pace DECIMAL(6,2),
    pace DECIMAL(6,2),
    pace_per40 DECIMAL(6,2),
    poss INTEGER,
    pie DECIMAL(5,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, team_id)
);