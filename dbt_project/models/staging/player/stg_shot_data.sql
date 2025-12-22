{{
  config(
    materialized='view'
  )
}}

with source as (
    select *
    from {{ source('nba', 'lineup_shot_data') }}
),

select
    s.season,
    s.game_id,
    s.game_event_id,
    s.player_id,
    s.player_name,
    s.team_id,
    s.team_name,
    s.period,
    s.minutes_remaining,
    s.seconds_remaining,
    s.event_type,
    s.action_type,
    s.shot_type,
    s.shot_zone_basic,
    s.shot_zone_area,
    s.shot_zone_range,
    s.shot_distance,
    s.loc_x,
    s.loc_y,
    s.shot_attempted_flag,
    s.shot_made_flag,
    s.game_date,
    s.home_team,
    s.away_team
from source s
