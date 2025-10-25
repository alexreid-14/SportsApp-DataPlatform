-- NBA Raw Data Tables
-- This file contains all the CREATE TABLE statements for tables used in base_nba_data_loader.py
-- These tables store raw NBA data from the NBA API

-- ============================================================================
-- PLAYERS TABLE
-- ============================================================================
-- Stores basic player information and biographical data
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
-- TEAMS TABLE
-- ============================================================================
-- Stores team information and location data
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
-- GAMES_RAW TABLE
-- ============================================================================
-- Stores raw game data from NBA API
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
-- BOX_SCORES TABLE
-- ============================================================================
-- Stores traditional box score statistics for each player in each game
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
-- ADVANCED_BOX_SCORES TABLE
-- ============================================================================
-- Stores advanced box score statistics for each player in each game
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


/*
-- ============================================================================
-- PLAYER_SHOT_LOCATIONS TABLE
-- ============================================================================
-- Stores detailed shot location data including coordinates, zones, action types, and game context
CREATE TABLE IF NOT EXISTS nba_raw.player_shot_locations (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) NOT NULL,
    game_event_id INTEGER NOT NULL,
    player_id INTEGER NOT NULL,
    player_name VARCHAR(100),
    team_id INTEGER NOT NULL,
    team_name VARCHAR(100),
    period INTEGER,
    minutes_remaining INTEGER,
    seconds_remaining INTEGER,
    event_type VARCHAR(50), -- 'Made Shot', 'Missed Shot'
    action_type VARCHAR(100), -- 'Running Layup Shot', 'Driving Finger Roll Layup Shot', etc.
    shot_type VARCHAR(50), -- '2PT Field Goal', '3PT Field Goal'
    shot_zone_basic VARCHAR(50), -- 'Restricted Area', 'In The Paint (Non-RA)', 'Mid-Range', 'Above the Break 3', 'Corner 3'
    shot_zone_area VARCHAR(50), -- 'Center(C)', 'Left Side(L)', 'Right Side(R)', 'Left Side Center(LC)', 'Right Side Center(RC)', 'Back Court(BC)'
    shot_zone_range VARCHAR(50), -- 'Less Than 8 ft.', '8-16 ft.', '16-24 ft.', '24+ ft.', 'Back Court Shot'
    shot_distance INTEGER, -- Distance in feet
    loc_x INTEGER, -- X coordinate on court
    loc_y INTEGER, -- Y coordinate on court
    shot_attempted_flag INTEGER, -- 1 if shot was attempted
    shot_made_flag INTEGER, -- 1 if shot was made
    game_date DATE,
    home_team VARCHAR(10), -- Home team abbreviation
    away_team VARCHAR(10), -- Away team abbreviation
    season VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(game_id, game_event_id, player_id)
);
*/

-- ============================================================================
-- NBA_PLAY_TYPE_STATS TABLE
-- ============================================================================
-- Stores play type statistics scraped from NBA stats website
/*
CREATE TABLE IF NOT EXISTS nba_raw.nba_play_type_stats (
    id SERIAL PRIMARY KEY,
    rank INTEGER,
    player VARCHAR(255),
    team VARCHAR(10),
    gp INTEGER,
    w INTEGER,
    l INTEGER,
    min DECIMAL(8,2),
    poss DECIMAL(8,2),
    pts DECIMAL(8,2),
    ppp DECIMAL(8,2),
    pts_pct DECIMAL(8,2),
    fgm INTEGER,
    fga INTEGER,
    fg_pct DECIMAL(8,3),
    efg_pct DECIMAL(8,3),
    ft_freq DECIMAL(8,2),
    ft_pct DECIMAL(8,3),
    to_freq DECIMAL(8,2),
    sf_freq DECIMAL(8,2),
    score DECIMAL(8,2),
    percentile DECIMAL(8,2),
    play_type VARCHAR(50),
    season VARCHAR(10),
    season_type VARCHAR(20),
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
*/


-- ============================================================================
-- PLAYER_TRACKING_BOX_SCORES TABLE
-- ============================================================================
-- Stores player tracking statistics for each player in each game
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
-- TEAM_BOX_SCORES TABLE
-- ============================================================================
-- Stores team box score statistics for each team in each game
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
-- TEAM_ADVANCED_BOX_SCORES TABLE
-- ============================================================================
-- Stores advanced team box score statistics for each team in each game
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

-- ============================================================================
-- BOX_SCORE_USAGE TABLE
-- ============================================================================
-- Stores usage statistics for each player in each game
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
-- LINEUPS TABLE
-- ============================================================================
-- Stores lineup statistics for each team in each game
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

-- ============================================================================
-- LINEUP_SHOT_DATA TABLE
-- ============================================================================
-- Stores shot data for each player in each lineup
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


-- ============================================================================
-- FAILED GAMES TABLES
-- ============================================================================
-- These tables track games that failed to process for various reasons

-- Failed traditional box score games
CREATE TABLE IF NOT EXISTS nba_raw.failed_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Failed advanced box score games
CREATE TABLE IF NOT EXISTS nba_raw.failed_advanced_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Failed player tracking games
CREATE TABLE IF NOT EXISTS nba_raw.failed_player_tracking_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Failed box score usage games
CREATE TABLE IF NOT EXISTS nba_raw.failed_box_score_usage_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS nba_raw.failed_team_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tracks games where team advanced box score data could not be retrieved
CREATE TABLE IF NOT EXISTS nba_raw.failed_team_advanced_games (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tracks games where team box score data could not be retrieved
CREATE TABLE IF NOT EXISTS nba_raw.failed_team_box_scores (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tracks games where lineup shot data could not be retrieved
CREATE TABLE IF NOT EXISTS nba_raw.failed_lineup_shot_data (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tracks games where lineup data could not be retrieved
CREATE TABLE IF NOT EXISTS nba_raw.failed_lineups (
    id SERIAL PRIMARY KEY,
    game_id VARCHAR(20) UNIQUE NOT NULL,
    error_message TEXT,
    failed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================================
-- INDEXES FOR PERFORMANCE
-- ============================================================================

-- Players table indexes
CREATE INDEX IF NOT EXISTS idx_players_player_id ON nba_raw.players(player_id);
CREATE INDEX IF NOT EXISTS idx_players_name ON nba_raw.players(full_name);

-- Teams table indexes
CREATE INDEX IF NOT EXISTS idx_teams_team_id ON nba_raw.teams(team_id);
CREATE INDEX IF NOT EXISTS idx_teams_abbreviation ON nba_raw.teams(abbreviation);

-- Games raw table indexes
CREATE INDEX IF NOT EXISTS idx_games_raw_game_id ON nba_raw.games_raw(game_id);
CREATE INDEX IF NOT EXISTS idx_games_raw_date ON nba_raw.games_raw(game_date);
CREATE INDEX IF NOT EXISTS idx_games_raw_season ON nba_raw.games_raw(season);
CREATE INDEX IF NOT EXISTS idx_games_raw_team_id ON nba_raw.games_raw(team_id);

-- Box scores table indexes
CREATE INDEX IF NOT EXISTS idx_box_scores_game_id ON nba_raw.box_scores(game_id);
CREATE INDEX IF NOT EXISTS idx_box_scores_player_id ON nba_raw.box_scores(player_id);
CREATE INDEX IF NOT EXISTS idx_box_scores_team_id ON nba_raw.box_scores(team_id);

-- Advanced box scores table indexes
CREATE INDEX IF NOT EXISTS idx_advanced_box_scores_game_id ON nba_raw.advanced_box_scores(game_id);
CREATE INDEX IF NOT EXISTS idx_advanced_box_scores_player_id ON nba_raw.advanced_box_scores(player_id);
CREATE INDEX IF NOT EXISTS idx_advanced_box_scores_team_id ON nba_raw.advanced_box_scores(team_id);

-- Player tracking box scores table indexes
CREATE INDEX IF NOT EXISTS idx_player_tracking_box_scores_game_id ON nba_raw.player_tracking_box_scores(game_id);
CREATE INDEX IF NOT EXISTS idx_player_tracking_box_scores_player_id ON nba_raw.player_tracking_box_scores(player_id);
CREATE INDEX IF NOT EXISTS idx_player_tracking_box_scores_team_id ON nba_raw.player_tracking_box_scores(team_id);

-- Player shot locations table indexes
CREATE INDEX IF NOT EXISTS idx_player_shot_locations_game_id ON nba_raw.player_shot_locations(game_id);
CREATE INDEX IF NOT EXISTS idx_player_shot_locations_player_id ON nba_raw.player_shot_locations(player_id);
CREATE INDEX IF NOT EXISTS idx_player_shot_locations_team_id ON nba_raw.player_shot_locations(team_id);
CREATE INDEX IF NOT EXISTS idx_player_shot_locations_season ON nba_raw.player_shot_locations(season);
CREATE INDEX IF NOT EXISTS idx_player_shot_locations_game_date ON nba_raw.player_shot_locations(game_date);

-- Failed games table indexes
CREATE INDEX IF NOT EXISTS idx_failed_games_game_id ON nba_raw.failed_games(game_id);
CREATE INDEX IF NOT EXISTS idx_failed_advanced_games_game_id ON nba_raw.failed_advanced_games(game_id);
CREATE INDEX IF NOT EXISTS idx_failed_player_tracking_games_game_id ON nba_raw.failed_player_tracking_games(game_id);
CREATE INDEX IF NOT EXISTS idx_failed_box_score_usage_games_game_id ON nba_raw.failed_box_score_usage_games(game_id);

-- NBA play type stats table indexes
CREATE INDEX IF NOT EXISTS idx_nba_play_type_stats_player ON nba_raw.nba_play_type_stats(player);
CREATE INDEX IF NOT EXISTS idx_nba_play_type_stats_team ON nba_raw.nba_play_type_stats(team);
CREATE INDEX IF NOT EXISTS idx_nba_play_type_stats_play_type ON nba_raw.nba_play_type_stats(play_type);
CREATE INDEX IF NOT EXISTS idx_nba_play_type_stats_season ON nba_raw.nba_play_type_stats(season);
CREATE INDEX IF NOT EXISTS idx_nba_play_type_stats_season_type ON nba_raw.nba_play_type_stats(season_type);

-- NBA team defense stats table indexes
CREATE INDEX IF NOT EXISTS idx_nba_team_defense_stats_team ON nba_raw.nba_team_defense_stats(team);
CREATE INDEX IF NOT EXISTS idx_nba_team_defense_stats_play_type ON nba_raw.nba_team_defense_stats(play_type);
CREATE INDEX IF NOT EXISTS idx_nba_team_defense_stats_season ON nba_raw.nba_team_defense_stats(season);
CREATE INDEX IF NOT EXISTS idx_nba_team_defense_stats_season_type ON nba_raw.nba_team_defense_stats(season_type);

-- Player play type stats table indexes
CREATE INDEX IF NOT EXISTS idx_player_play_type_stats_player_id ON nba_raw.player_play_type_stats(player_id);
CREATE INDEX IF NOT EXISTS idx_player_play_type_stats_team_id ON nba_raw.player_play_type_stats(team_id);
CREATE INDEX IF NOT EXISTS idx_player_play_type_stats_season ON nba_raw.player_play_type_stats(season);
CREATE INDEX IF NOT EXISTS idx_player_play_type_stats_play_type ON nba_raw.player_play_type_stats(play_type);

-- Box score usage table indexes
CREATE INDEX IF NOT EXISTS idx_box_score_usage_game_id ON nba_raw.box_score_usage(game_id);
CREATE INDEX IF NOT EXISTS idx_box_score_usage_player_id ON nba_raw.box_score_usage(player_id);
CREATE INDEX IF NOT EXISTS idx_box_score_usage_team_id ON nba_raw.box_score_usage(team_id);

-- Team box scores indexes
CREATE INDEX IF NOT EXISTS idx_team_box_scores_game_id ON nba_raw.team_box_scores(game_id);
CREATE INDEX IF NOT EXISTS idx_team_box_scores_team_id ON nba_raw.team_box_scores(team_id);
CREATE INDEX IF NOT EXISTS idx_team_box_scores_game_team ON nba_raw.team_box_scores(game_id, team_id);

-- Team advanced box scores indexes
CREATE INDEX IF NOT EXISTS idx_team_advanced_box_scores_game_id ON nba_raw.team_advanced_box_scores(game_id);
CREATE INDEX IF NOT EXISTS idx_team_advanced_box_scores_team_id ON nba_raw.team_advanced_box_scores(team_id);
CREATE INDEX IF NOT EXISTS idx_team_advanced_box_scores_game_team ON nba_raw.team_advanced_box_scores(game_id, team_id);

-- Failed games indexes
CREATE INDEX IF NOT EXISTS idx_failed_team_games_game_id ON nba_raw.failed_team_games(game_id);
CREATE INDEX IF NOT EXISTS idx_failed_team_advanced_games_game_id ON nba_raw.failed_team_advanced_games(game_id);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_lineups_group_id ON nba_raw.lineups(group_id);
CREATE INDEX IF NOT EXISTS idx_lineups_team_id ON nba_raw.lineups(team_id);
CREATE INDEX IF NOT EXISTS idx_lineups_season ON nba_raw.lineups(season);

CREATE INDEX IF NOT EXISTS idx_lineup_shot_data_group_id ON nba_raw.lineup_shot_data(group_id);
CREATE INDEX IF NOT EXISTS idx_lineup_shot_data_season ON nba_raw.lineup_shot_data(season);
CREATE INDEX IF NOT EXISTS idx_lineup_shot_data_player_id ON nba_raw.lineup_shot_data(player_id);
CREATE INDEX IF NOT EXISTS idx_lineup_shot_data_game_id ON nba_raw.lineup_shot_data(game_id);
CREATE INDEX IF NOT EXISTS idx_lineup_shot_data_game_date ON nba_raw.lineup_shot_data(game_date);

-- Add comments for documentation
COMMENT ON TABLE nba_raw.lineups IS 'Lineup statistics from LeagueDashLineups endpoint';
COMMENT ON TABLE nba_raw.lineup_shot_data IS 'Shot data for specific lineups from ShotChartLineupDetail endpoint'; 
COMMENT ON TABLE nba_raw.box_scores IS 'Traditional box score statistics for each player in each game';
COMMENT ON TABLE nba_raw.advanced_box_scores IS 'Advanced box score statistics for each player in each game';
--COMMENT ON TABLE nba_raw.player_tracking_box_scores IS 'Player tracking box score statistics for each player in each game';
COMMENT ON TABLE nba_raw.team_box_scores IS 'Team box score statistics for each team in each game';
COMMENT ON TABLE nba_raw.team_advanced_box_scores IS 'Team advanced box score statistics for each team in each game';
COMMENT ON TABLE nba_raw.box_score_usage IS 'Usage statistics for each player in each game';
COMMENT ON TABLE nba_raw.lineups IS 'Lineup statistics for each team in each game';
COMMENT ON TABLE nba_raw.lineup_shot_data IS 'Shot data for specific lineups from ShotChartLineupDetail endpoint';