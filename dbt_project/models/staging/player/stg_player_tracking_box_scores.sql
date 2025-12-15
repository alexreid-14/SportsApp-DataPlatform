with source as (
    select *
    from {{ source('nba', 'player_tracking_box_scores') }}
),

players as (
    select * from {{ ref('stg_players') }}
)

select
    s.game_id,
    s.team_id,
    s.player_id,
    s.player_name,
    p.position as player_position,
    s.start_position,
    s.minutes_played,
    s.speed,
    s.distance,
    s.offensive_rebounds_contested,
    s.defensive_rebounds_contested,
    s.rebounds_contested,
    s.touches,
    s.secondary_assists,
    s.free_throw_assists,
    s.passes,
    s.assists,
    s.contested_field_goals_made,
    s.contested_field_goals_attempted,
    s.contested_field_goal_pct,
    s.uncontested_field_goals_made,
    s.uncontested_field_goals_attempted,
    s.uncontested_field_goal_pct,
    s.field_goal_pct,
    s.defended_field_goals_made,
    s.defended_field_goals_attempted,
    s.defended_field_goal_pct
from source s
left join players p on s.player_id = p.player_id