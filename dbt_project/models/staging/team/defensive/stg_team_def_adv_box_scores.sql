with game_defensive_stats as (
    select 
        g.game_id,
        g.team_id, 
        case when g.team_id = g.home_team_id then g.away_team_id else g.home_team_id end as opponent_team_id
    from {{ ref('stg_games') }} g
)

select 
    g.game_id,
    g.team_id,
    g.opponent_team_id,
    bs.minutes_played,
    bs.off_rating,
    bs.def_rating,
    bs.net_rating,
    bs.e_off_rating,
    bs.e_def_rating,
    bs.e_net_rating,
    bs.ast_pct,
    bs.ast_to,
    bs.ast_ratio,
    bs.oreb_pct,
    bs.dreb_pct,
    bs.reb_pct,
    bs.tm_tov_pct,
    bs.e_tm_tov_pct,
    bs.efg_pct,
    bs.ts_pct,
    bs.usg_pct,
    bs.e_usg_pct,
    bs.e_pace,
    bs.pace,
    bs.pace_per40,
    bs.poss,
    bs.pie
from game_defensive_stats g
left join {{ ref('stg_team_advanced_box_scores') }} bs 
    on g.game_id = bs.game_id and g.opponent_team_id = bs.team_id
group by g.game_id, g.team_id, g.opponent_team_id




