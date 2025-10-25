# NBA Defensive Metrics for Machine Learning

This document explains the defensive metrics models created in dbt and how to use them for machine learning models to predict player performance.

## Overview

The defensive metrics system calculates rolling averages of team defensive performance based on:
1. **Shot location data** - How well teams defend different shot zones
2. **Box score data** - Traditional defensive stats like steals, blocks, rebounds
3. **Advanced metrics** - Defensive ratings and efficiency measures

These metrics are designed to be used as features in ML models to predict player stats (points, rebounds, assists, steals, blocks) for upcoming games.

## Models

### 1. `team_defensive_shot_metrics`
Calculates team defensive performance by shot location with rolling averages.

**Key Features:**
- Defensive field goal percentage by shot zone (Restricted Area, Paint, Mid-Range, 3-Point)
- 10-game, 20-game, and season-to-date rolling averages
- Defensive efficiency metrics (lower FG% = better defense)

**Example Usage:**
```sql
-- Get how well a team defends corner 3s over last 10 games
SELECT team_id, season, game_date, 
       rolling_defensive_fg_pct_10g as corner_3_defense_10g
FROM team_defensive_shot_metrics 
WHERE shot_zone_basic = 'Corner 3'
ORDER BY team_id, game_date;
```

### 2. `team_defensive_box_metrics`
Calculates team defensive metrics from box scores with rolling averages.

**Key Features:**
- Steals, blocks, defensive rebounds per game
- Points allowed per game
- Defensive rating
- 10-game, 20-game, and season-to-date rolling averages

**Example Usage:**
```sql
-- Get team's defensive performance over last 20 games
SELECT team_id, season, game_date,
       rolling_steals_20g, rolling_blocks_20g, 
       rolling_points_allowed_20g, rolling_def_rating_20g
FROM team_defensive_box_metrics
ORDER BY team_id, game_date;
```

### 3. `player_game_defensive_features`
Comprehensive defensive features for ML models at player-game level.

**Key Features:**
- Player performance (points, rebounds, assists, steals, blocks)
- Opponent defensive metrics (all shot zones + box score stats)
- Multiple time windows (10-game, 20-game, season-to-date)
- Ready-to-use features for ML models

**Example Usage:**
```sql
-- Get all defensive features for a specific player-game
SELECT * FROM player_game_defensive_features 
WHERE player_id = 2544 AND game_date = '2024-01-15';
```

## Machine Learning Use Cases

### 1. Points Prediction Model
Use opponent defensive metrics to predict player points:

**Features:**
- `opp_def_fg_pct_10g` - Overall opponent defense
- `opp_def_restricted_area_10g` - Paint defense
- `opp_def_mid_range_10g` - Mid-range defense
- `opp_def_above_break_3_10g` - 3-point defense
- `opp_points_allowed_10g` - Points allowed

### 2. Rebounds Prediction Model
Use opponent rebounding defense to predict rebounds:

**Features:**
- `opp_defensive_rebounds_10g` - Opponent defensive rebounding
- `opp_blocks_10g` - Opponent shot blocking
- `opp_def_rating_10g` - Overall defensive rating

### 3. Assists Prediction Model
Use opponent defensive pressure to predict assists:

**Features:**
- `opp_def_efficiency_10g` - Defensive efficiency
- `opp_steals_10g` - Opponent steals (defensive pressure)
- `opp_def_rating_10g` - Defensive rating

### 4. Steals/Blocks Prediction Model
Use opponent offensive patterns to predict defensive stats:

**Features:**
- `opp_def_fg_pct_10g` - Opponent shooting (more misses = more rebound opportunities)
- `opp_points_allowed_10g` - Opponent scoring (more points = more defensive opportunities)

## Feature Engineering Strategy

### Time Windows
- **10-game rolling**: Recent form, good for short-term trends
- **20-game rolling**: Medium-term trends, more stable
- **Season-to-date**: Long-term baseline performance

### Shot Zone Breakdown
- **Restricted Area**: Paint defense, affects layup/dunk opportunities
- **In The Paint (Non-RA)**: Close-range defense
- **Mid-Range**: Mid-range shooting defense
- **Above the Break 3**: 3-point defense (non-corner)
- **Corner 3**: Corner 3-point defense

### Defensive Metrics
- **Defensive FG%**: Lower is better (better defense)
- **Defensive Efficiency**: 1 - FG% (higher is better defense)
- **Points Allowed**: Lower is better
- **Defensive Rating**: Advanced metric (lower is better)

## Example ML Model Features

```python
# Example feature set for points prediction
features = [
    'opp_def_fg_pct_10g',           # Overall defense
    'opp_def_restricted_area_10g',   # Paint defense
    'opp_def_mid_range_10g',         # Mid-range defense
    'opp_def_above_break_3_10g',    # 3-point defense
    'opp_def_corner_3_10g',         # Corner 3 defense
    'opp_points_allowed_10g',        # Points allowed
    'opp_def_rating_10g',            # Defensive rating
    'opp_def_efficiency_10g',        # Defensive efficiency
    # Add 20-game and season features for comparison
    'opp_def_fg_pct_20g',
    'opp_def_fg_pct_season',
    # Player's recent performance
    'player_avg_points_10g',
    'player_avg_minutes_10g'
]
```

## Data Quality Considerations

1. **Missing Data**: Some games may not have shot location data
2. **Small Sample Sizes**: Early in season, rolling averages may be based on few games
3. **Playoff vs Regular Season**: Consider separate models for different game types
4. **Player Position**: Different positions may be affected differently by defensive metrics

## Performance Optimization

- Models are materialized as tables for fast querying
- Indexes created on key columns (player_id, game_id, team_id)
- Rolling averages calculated efficiently using window functions
- Consider partitioning by season for large datasets

## Next Steps

1. **Feature Selection**: Use correlation analysis to identify most predictive features
2. **Model Validation**: Test on historical data with proper train/test splits
3. **Ensemble Models**: Combine predictions from multiple time windows
4. **Player-Specific Models**: Train separate models for different player types
5. **Real-time Updates**: Set up automated model retraining as new data arrives 