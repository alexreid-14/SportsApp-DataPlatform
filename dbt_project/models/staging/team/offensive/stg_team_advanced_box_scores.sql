with source as (
    select * from {{ source('nba', 'team_advanced_box_scores') }}
)

select
    game_id,
    team_id,
    team_name,
    team_abbreviation,
    team_city,
    minutes_played,
    off_rating,
    def_rating,
    net_rating,
    e_off_rating,
    e_def_rating,
    e_net_rating,
    ast_pct,
    ast_to,
    ast_ratio,
    oreb_pct,
    dreb_pct,
    reb_pct,
    tm_tov_pct,
    e_tm_tov_pct,
    efg_pct,
    ts_pct,
    usg_pct,
    e_usg_pct,
    e_pace,
    pace,
    pace_per40,
    poss,
    pie,
    created_at,
    updated_at,
    concat(game_id, '-', team_id) as team_advanced_box_score_id
from source