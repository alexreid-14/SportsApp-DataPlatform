-- ============================================================================
-- PLAYERS TABLE: Stores basic player information and biographical data
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.players (
    id SERIAL PRIMARY KEY,
    player_id INTEGER UNIQUE NOT NULL,
    full_name VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    draft_year INTEGER,
    from_year INTEGER,
    to_year INTEGER,
    position VARCHAR(10),
    height VARCHAR(10),
    weight INTEGER,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- BOX_SCORES TABLE: Stores traditional box score statistics for each player in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    start_position VARCHAR(10),
    field_goals_made INTEGER,
    field_goals_attempted INTEGER,
    three_pointers_made INTEGER,
    three_pointers_attempted INTEGER,
    free_throws_made INTEGER,
    free_throws_attempted INTEGER,
    points INTEGER,
    offensive_rebounds INTEGER,
    defensive_rebounds INTEGER,
    assists INTEGER,
    steals INTEGER,
    blocks INTEGER,
    turnovers INTEGER,
    personal_fouls INTEGER,
    minutes_played DECIMAL(5,2),
    plus_minus INTEGER,
    comments TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, player_id)
);

-- ============================================================================
-- ADVANCED_BOX_SCORES TABLE: Stores advanced box score statistics for each player in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.advanced_box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    start_position VARCHAR(10),
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
    efg_pct DECIMAL(5,2),
    ts_pct DECIMAL(5,2),
    usg_pct DECIMAL(5,2),
    e_usg_pct DECIMAL(5,2),
    e_pace DECIMAL(6,2),
    pace DECIMAL(6,2),
    pace_per40 DECIMAL(6,2),
    poss INTEGER,
    pie DECIMAL(5,2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, player_id)
);

-- ============================================================================
-- PLAYER_TRACKING_BOX_SCORES TABLE: Stores player tracking statistics for each player in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.player_tracking_box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    start_position VARCHAR(10),
    minutes_played DECIMAL(5,2),
    speed DECIMAL(5,2), -- Average speed in miles per hour
    distance DECIMAL(6,2), -- Distance traveled in miles
    offensive_rebounds INTEGER,
    defensive_rebounds INTEGER,
    rebounds INTEGER,
    touches INTEGER,
    secondary_assists INTEGER,
    free_throw_assists INTEGER,
    passes INTEGER,
    assists INTEGER,
    contested_field_goals_made INTEGER,
    contested_field_goals_attempted INTEGER,
    contested_field_goal_pct DECIMAL(5,3),
    uncontested_field_goals_made INTEGER,
    uncontested_field_goals_attempted INTEGER,
    uncontested_field_goal_pct DECIMAL(5,3),
    field_goal_pct DECIMAL(5,3),
    defended_field_goals_made INTEGER,
    defended_field_goals_attempted INTEGER,
    defended_field_goal_pct DECIMAL(5,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, player_id)
);

-- ============================================================================
-- BOX_SCORE_USAGE TABLE: Stores usage statistics for each player in each game
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.box_score_usage (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    team_id INTEGER NOT NULL,
    team_abbreviation VARCHAR(10) NOT NULL,
    team_city VARCHAR(100) NOT NULL,
    player_id INTEGER NOT NULL,
    player_name VARCHAR(255) NOT NULL,
    nickname VARCHAR(100),
    start_position VARCHAR(10),
    comment TEXT,
    minutes_played DECIMAL(5,2),
    usg_pct DECIMAL(5,3),
    pct_fgm DECIMAL(5,3),
    pct_fga DECIMAL(5,3),
    pct_fg3m DECIMAL(5,3),
    pct_fg3a DECIMAL(5,3),
    pct_ftm DECIMAL(5,3),
    pct_fta DECIMAL(5,3),
    pct_oreb DECIMAL(5,3),
    pct_dreb DECIMAL(5,3),
    pct_reb DECIMAL(5,3),
    pct_ast DECIMAL(5,3),
    pct_tov DECIMAL(5,3),
    pct_stl DECIMAL(5,3),
    pct_blk DECIMAL(5,3),
    pct_blka DECIMAL(5,3),
    pct_pf DECIMAL(5,3),
    pct_pfd DECIMAL(5,3),
    pct_pts DECIMAL(5,3),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, player_id)
);

-- ============================================================================
-- LINEUP_SHOT_DATA TABLE: Stores shot data for each player in each lineup
-- ============================================================================
CREATE TABLE IF NOT EXISTS nba_raw.lineup_shot_data (
    group_id VARCHAR(50) NOT NULL,
    season VARCHAR(10) NOT NULL,
    game_id VARCHAR(20),
    game_event_id INTEGER,
    player_id INTEGER,
    player_name VARCHAR(100),
    team_id INTEGER,
    team_name VARCHAR(100),
    period INTEGER,
    minutes_remaining INTEGER,
    seconds_remaining INTEGER,
    event_type VARCHAR(50),
    action_type VARCHAR(100),
    shot_type VARCHAR(50),
    shot_zone_basic VARCHAR(50),
    shot_zone_area VARCHAR(50),
    shot_zone_range VARCHAR(50),
    shot_distance INTEGER,
    loc_x INTEGER,
    loc_y INTEGER,
    shot_attempted_flag INTEGER,
    shot_made_flag INTEGER,
    game_date DATE,
    home_team VARCHAR(10),
    away_team VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (group_id, game_event_id, player_id)
);