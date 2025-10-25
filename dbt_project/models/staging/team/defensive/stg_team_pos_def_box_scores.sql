with game_defensive_stats as (
    select 
        g.game_id,
        g.team_id, 
        case when g.team_id = g.home_team_id then g.away_team_id else g.home_team_id end as opponent_team_id
    from {{ ref('stg_games') }} g
),

team_defensive_stats as (
    select 
        g.game_id,
        g.team_id,
        g.opponent_team_id,
        bs.player_position,
        sum(bs.field_goals_made) as field_goals_made,
        sum(bs.field_goals_attempted) as field_goals_attempted,
        sum(bs.three_pointers_made) as three_pointers_made,
        sum(bs.three_pointers_attempted) as three_pointers_attempted,
        sum(bs.free_throws_made) as free_throws_made,
        sum(bs.free_throws_attempted) as free_throws_attempted,
        sum(bs.points) as points,
        sum(bs.offensive_rebounds) as offensive_rebounds,
        sum(bs.defensive_rebounds) as defensive_rebounds,
        sum(bs.assists) as assists,
        sum(bs.steals) as steals,
        sum(bs.blocks) as blocks,
        sum(bs.turnovers) as turnovers,
        sum(bs.personal_fouls) as personal_fouls
    from game_defensive_stats g
    left join {{ ref('stg_box_scores') }} bs 
        on g.game_id = bs.game_id and g.opponent_team_id = bs.team_id
    group by g.game_id, g.team_id, g.opponent_team_id, bs.player_position
)

select * from team_defensive_stats
