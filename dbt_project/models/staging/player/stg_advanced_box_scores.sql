with source as (
    select *
    from {{ source('nba', 'advanced_box_scores') }}
),

select
    s.game_id,
    s.team_id,
    s.player_id,
    s.player_name,
    s.start_position,
    s.minutes_played,
    s.off_rating,
    s.def_rating,
    s.net_rating,
    s.e_off_rating,
    s.e_def_rating,
    s.e_net_rating,
    s.ast_pct,
    s.ast_to,
    s.ast_ratio,
    s.oreb_pct,
    s.dreb_pct,
    s.reb_pct,
    s.tm_tov_pct,
    s.efg_pct,
    s.ts_pct,
    s.usg_pct,
    s.e_usg_pct,
    s.e_pace,
    s.pace,
    s.pace_per40,
    s.poss,
    s.pie
from source s
