with source as (
    select *
    from {{ source('nba', 'box_score_usage') }}
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
    s.nickname,
    s.comment,
    s.minutes_played,
    s.usg_pct,
    s.pct_fgm,
    s.pct_fga,
    s.pct_fg3m,
    s.pct_fg3a,
    s.pct_ftm,
    s.pct_fta,
    s.pct_oreb,
    s.pct_dreb,
    s.pct_reb,
    s.pct_ast,
    s.pct_tov,
    s.pct_stl,
    s.pct_blk,
    s.pct_blka,
    s.pct_pf,
    s.pct_pfd,
    s.pct_pts
from source s
left join players p on s.player_id = p.player_id