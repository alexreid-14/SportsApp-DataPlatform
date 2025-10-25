with source as (
    select *
    from {{ source('nba', 'games_raw') }}
)
select
    game_id, 
    game_date, 
    game_type, 
    season, 
    team_id, 
    matchup,
    points,
    is_win
from source
