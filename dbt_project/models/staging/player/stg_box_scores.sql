with source as (
    select *
    from {{ source('nba', 'box_scores') }}
),

select
    s.game_id,
    s.team_id,
    s.player_id,
    s.player_name,
    s.start_position,
    s.field_goals_made,
    s.field_goals_attempted,
    s.three_pointers_made,
    s.three_pointers_attempted,
    s.free_throws_made,
    s.free_throws_attempted,
    s.points,
    s.offensive_rebounds,
    s.defensive_rebounds,
    s.assists,
    s.steals,
    s.blocks,
    s.turnovers,
    s.personal_fouls,
    s.minutes_played,
    s.plus_minus,
    s.comments
from source s
