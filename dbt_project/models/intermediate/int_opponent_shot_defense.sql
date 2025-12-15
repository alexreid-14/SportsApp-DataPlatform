with player_shot_data as (
    select * from {{ ref('int_player_shots') }}
),

games as (
    select * from {{ ref('games') }}
),

-- Join player shots with games to get team context
player_team_shots as (
    select
        ps.*,
        pg.opponent_team_id as defensive_team_id,
        -- Derive the offensive team (player's team) from games table
        case
            when pg.opponent_team_id = g.home_team_id then g.away_team_id
            else g.home_team_id
        end as offensive_team_id
    from player_shot_data ps
    join {{ ref('player_game') }} pg on ps.game_id = pg.game_id and ps.player_id = pg.player_id
    join games g on ps.game_id = g.game_id
),

-- Aggregate shot data by defensive team and shot zones
team_defensive_shot_performance as (
    select
        game_id,
        defensive_team_id as team_id,
        offensive_team_id as opponent_team_id,
        season,
        game_date,
        -- Shot zone basic metrics
        sum(above_the_break_3_attempted_count) as opp_above_the_break_3_attempted,
        sum(above_the_break_3_made_count) as opp_above_the_break_3_made,
        case
            when sum(above_the_break_3_attempted_count) > 0
            then sum(above_the_break_3_made_count)::float / sum(above_the_break_3_attempted_count)
            else 0
        end as opp_above_the_break_3_fg_pct,

        sum(mid_range_attempted_count) as opp_mid_range_attempted,
        sum(mid_range_made_count) as opp_mid_range_made,
        case
            when sum(mid_range_attempted_count) > 0
            then sum(mid_range_made_count)::float / sum(mid_range_attempted_count)
            else 0
        end as opp_mid_range_fg_pct,

        sum(in_the_paint_non_ra_attempted_count) as opp_in_the_paint_non_ra_attempted,
        sum(in_the_paint_non_ra_made_count) as opp_in_the_paint_non_ra_made,
        case
            when sum(in_the_paint_non_ra_attempted_count) > 0
            then sum(in_the_paint_non_ra_made_count)::float / sum(in_the_paint_non_ra_attempted_count)
            else 0
        end as opp_in_the_paint_non_ra_fg_pct,

        sum(restricted_area_attempted_count) as opp_restricted_area_attempted,
        sum(restricted_area_made_count) as opp_restricted_area_made,
        case
            when sum(restricted_area_attempted_count) > 0
            then sum(restricted_area_made_count)::float / sum(restricted_area_attempted_count)
            else 0
        end as opp_restricted_area_fg_pct,

        sum(right_corner_3_attempted_count) as opp_right_corner_3_attempted,
        sum(right_corner_3_made_count) as opp_right_corner_3_made,
        case
            when sum(right_corner_3_attempted_count) > 0
            then sum(right_corner_3_made_count)::float / sum(right_corner_3_attempted_count)
            else 0
        end as opp_right_corner_3_fg_pct,

        sum(left_corner_3_attempted_count) as opp_left_corner_3_attempted,
        sum(left_corner_3_made_count) as opp_left_corner_3_made,
        case
            when sum(left_corner_3_attempted_count) > 0
            then sum(left_corner_3_made_count)::float / sum(left_corner_3_attempted_count)
            else 0
        end as opp_left_corner_3_fg_pct,

        -- Shot range metrics
        sum(less_than_8_ft_attempted_count) as opp_less_than_8_ft_attempted,
        sum(less_than_8_ft_made_count) as opp_less_than_8_ft_made,
        case
            when sum(less_than_8_ft_attempted_count) > 0
            then sum(less_than_8_ft_made_count)::float / sum(less_than_8_ft_attempted_count)
            else 0
        end as opp_less_than_8_ft_fg_pct,

        sum(ft_8_to_16_attempted_count) as opp_8_to_16_ft_attempted,
        sum(ft_8_to_16_made_count) as opp_8_to_16_ft_made,
        case
            when sum(ft_8_to_16_attempted_count) > 0
            then sum(ft_8_to_16_made_count)::float / sum(ft_8_to_16_attempted_count)
            else 0
        end as opp_8_to_16_ft_fg_pct,

        sum(ft_16_to_24_attempted_count) as opp_16_to_24_ft_attempted,
        sum(ft_16_to_24_made_count) as opp_16_to_24_ft_made,
        case
            when sum(ft_16_to_24_attempted_count) > 0
            then sum(ft_16_to_24_made_count)::float / sum(ft_16_to_24_attempted_count)
            else 0
        end as opp_16_to_24_ft_fg_pct,

        sum(ft_24_plus_attempted_count) as opp_24_plus_ft_attempted,
        sum(ft_24_plus_made_count) as opp_24_plus_ft_made,
        case
            when sum(ft_24_plus_attempted_count) > 0
            then sum(ft_24_plus_made_count)::float / sum(ft_24_plus_attempted_count)
            else 0
        end as opp_24_plus_ft_fg_pct,

        sum(backcourt_attempted_count) as opp_backcourt_attempted,
        sum(backcourt_made_count) as opp_backcourt_made,
        case
            when sum(backcourt_attempted_count) > 0
            then sum(backcourt_made_count)::float / sum(backcourt_attempted_count)
            else 0
        end as opp_backcourt_fg_pct,

        -- Total shots for context
        sum(above_the_break_3_attempted_count + mid_range_attempted_count + in_the_paint_non_ra_attempted_count +
            restricted_area_attempted_count + right_corner_3_attempted_count + left_corner_3_attempted_count) as total_opp_attempted,
        sum(above_the_break_3_made_count + mid_range_made_count + in_the_paint_non_ra_made_count +
            restricted_area_made_count + right_corner_3_made_count + left_corner_3_made_count) as total_opp_made,
        case
            when sum(above_the_break_3_attempted_count + mid_range_attempted_count + in_the_paint_non_ra_attempted_count +
                    restricted_area_attempted_count + right_corner_3_attempted_count + left_corner_3_attempted_count) > 0
            then sum(above_the_break_3_made_count + mid_range_made_count + in_the_paint_non_ra_made_count +
                    restricted_area_made_count + right_corner_3_made_count + left_corner_3_made_count)::float /
                 sum(above_the_break_3_attempted_count + mid_range_attempted_count + in_the_paint_non_ra_attempted_count +
                     restricted_area_attempted_count + right_corner_3_attempted_count + left_corner_3_attempted_count)
            else 0
        end as total_opp_fg_pct
    from player_team_shots
    group by game_id, defensive_team_id, offensive_team_id, season, game_date
),

-- Calculate rolling averages for defensive performance
rolling_defensive_stats as (
    select
        game_id,
        team_id,
        opponent_team_id,
        season,
        game_date,

        -- Season to date averages (what teams allow)
        avg(opp_above_the_break_3_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_above_the_break_3_fga_season_to_date,
        avg(opp_above_the_break_3_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_above_the_break_3_fg_pct_season_to_date,

        avg(opp_mid_range_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_mid_range_fga_season_to_date,
        avg(opp_mid_range_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_mid_range_fg_pct_season_to_date,

        avg(opp_in_the_paint_non_ra_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_in_the_paint_non_ra_fga_season_to_date,
        avg(opp_in_the_paint_non_ra_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_in_the_paint_non_ra_fg_pct_season_to_date,

        avg(opp_restricted_area_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_restricted_area_fga_season_to_date,
        avg(opp_restricted_area_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_restricted_area_fg_pct_season_to_date,

        avg(opp_right_corner_3_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_right_corner_3_fga_season_to_date,
        avg(opp_right_corner_3_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_right_corner_3_fg_pct_season_to_date,

        avg(opp_left_corner_3_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_left_corner_3_fga_season_to_date,
        avg(opp_left_corner_3_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_left_corner_3_fg_pct_season_to_date,

        avg(opp_less_than_8_ft_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_less_than_8_ft_fga_season_to_date,
        avg(opp_less_than_8_ft_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_less_than_8_ft_fg_pct_season_to_date,

        avg(opp_8_to_16_ft_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_8_to_16_ft_fga_season_to_date,
        avg(opp_8_to_16_ft_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_8_to_16_ft_fg_pct_season_to_date,

        avg(opp_16_to_24_ft_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_16_to_24_ft_fga_season_to_date,
        avg(opp_16_to_24_ft_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_16_to_24_ft_fg_pct_season_to_date,

        avg(opp_24_plus_ft_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_24_plus_ft_fga_season_to_date,
        avg(opp_24_plus_ft_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_24_plus_ft_fg_pct_season_to_date,

        avg(opp_backcourt_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_backcourt_fga_season_to_date,
        avg(opp_backcourt_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_backcourt_fg_pct_season_to_date,

        avg(total_opp_attempted) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_total_fga_season_to_date,
        avg(total_opp_fg_pct) over (partition by team_id, season order by game_date rows between unbounded preceding and 1 preceding) as opp_total_fg_pct_season_to_date,

        -- Last 5 games averages
        avg(opp_above_the_break_3_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_above_the_break_3_fga_last_5,
        avg(opp_above_the_break_3_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_above_the_break_3_fg_pct_last_5,

        avg(opp_mid_range_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_mid_range_fga_last_5,
        avg(opp_mid_range_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_mid_range_fg_pct_last_5,

        avg(opp_in_the_paint_non_ra_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_in_the_paint_non_ra_fga_last_5,
        avg(opp_in_the_paint_non_ra_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_in_the_paint_non_ra_fg_pct_last_5,

        avg(opp_restricted_area_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_restricted_area_fga_last_5,
        avg(opp_restricted_area_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_restricted_area_fg_pct_last_5,

        avg(opp_right_corner_3_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_right_corner_3_fga_last_5,
        avg(opp_right_corner_3_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_right_corner_3_fg_pct_last_5,

        avg(opp_left_corner_3_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_left_corner_3_fga_last_5,
        avg(opp_left_corner_3_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_left_corner_3_fg_pct_last_5,

        avg(opp_less_than_8_ft_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_less_than_8_ft_fga_last_5,
        avg(opp_less_than_8_ft_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_less_than_8_ft_fg_pct_last_5,

        avg(opp_8_to_16_ft_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_8_to_16_ft_fga_last_5,
        avg(opp_8_to_16_ft_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_8_to_16_ft_fg_pct_last_5,

        avg(opp_16_to_24_ft_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_16_to_24_ft_fga_last_5,
        avg(opp_16_to_24_ft_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_16_to_24_ft_fg_pct_last_5,

        avg(opp_24_plus_ft_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_24_plus_ft_fga_last_5,
        avg(opp_24_plus_ft_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_24_plus_ft_fg_pct_last_5,

        avg(opp_backcourt_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_backcourt_fga_last_5,
        avg(opp_backcourt_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_backcourt_fg_pct_last_5,

        avg(total_opp_attempted) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_total_fga_last_5,
        avg(total_opp_fg_pct) over (partition by team_id, season order by game_date rows between 5 preceding and 1 preceding) as opp_total_fg_pct_last_5,

        -- Vs opponent season to date averages
        avg(opp_above_the_break_3_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_above_the_break_3_fga_vs_opp_season_to_date,
        avg(opp_above_the_break_3_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_above_the_break_3_fg_pct_vs_opp_season_to_date,

        avg(opp_mid_range_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_mid_range_fga_vs_opp_season_to_date,
        avg(opp_mid_range_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_mid_range_fg_pct_vs_opp_season_to_date,

        avg(opp_in_the_paint_non_ra_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_in_the_paint_non_ra_fga_vs_opp_season_to_date,
        avg(opp_in_the_paint_non_ra_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_in_the_paint_non_ra_fg_pct_vs_opp_season_to_date,

        avg(opp_restricted_area_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_restricted_area_fga_vs_opp_season_to_date,
        avg(opp_restricted_area_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_restricted_area_fg_pct_vs_opp_season_to_date,

        avg(opp_right_corner_3_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_right_corner_3_fga_vs_opp_season_to_date,
        avg(opp_right_corner_3_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_right_corner_3_fg_pct_vs_opp_season_to_date,

        avg(opp_left_corner_3_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_left_corner_3_fga_vs_opp_season_to_date,
        avg(opp_left_corner_3_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_left_corner_3_fg_pct_vs_opp_season_to_date,

        avg(opp_less_than_8_ft_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_less_than_8_ft_fga_vs_opp_season_to_date,
        avg(opp_less_than_8_ft_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_less_than_8_ft_fg_pct_vs_opp_season_to_date,

        avg(opp_8_to_16_ft_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_8_to_16_ft_fga_vs_opp_season_to_date,
        avg(opp_8_to_16_ft_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_8_to_16_ft_fg_pct_vs_opp_season_to_date,

        avg(opp_16_to_24_ft_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_16_to_24_ft_fga_vs_opp_season_to_date,
        avg(opp_16_to_24_ft_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_16_to_24_ft_fg_pct_vs_opp_season_to_date,

        avg(opp_24_plus_ft_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_24_plus_ft_fga_vs_opp_season_to_date,
        avg(opp_24_plus_ft_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_24_plus_ft_fg_pct_vs_opp_season_to_date,

        avg(opp_backcourt_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_backcourt_fga_vs_opp_season_to_date,
        avg(opp_backcourt_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_backcourt_fg_pct_vs_opp_season_to_date,

        avg(total_opp_attempted) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_total_fga_vs_opp_season_to_date,
        avg(total_opp_fg_pct) over (partition by team_id, season, opponent_team_id order by game_date rows between unbounded preceding and 1 preceding) as opp_total_fg_pct_vs_opp_season_to_date

    from team_defensive_shot_performance
)

select
    game_id,
    team_id,
    opponent_team_id,
    season,
    game_date,

    -- Season to date averages
    opp_above_the_break_3_fga_season_to_date,
    opp_above_the_break_3_fg_pct_season_to_date,
    opp_mid_range_fga_season_to_date,
    opp_mid_range_fg_pct_season_to_date,
    opp_in_the_paint_non_ra_fga_season_to_date,
    opp_in_the_paint_non_ra_fg_pct_season_to_date,
    opp_restricted_area_fga_season_to_date,
    opp_restricted_area_fg_pct_season_to_date,
    opp_right_corner_3_fga_season_to_date,
    opp_right_corner_3_fg_pct_season_to_date,
    opp_left_corner_3_fga_season_to_date,
    opp_left_corner_3_fg_pct_season_to_date,
    opp_less_than_8_ft_fga_season_to_date,
    opp_less_than_8_ft_fg_pct_season_to_date,
    opp_8_to_16_ft_fga_season_to_date,
    opp_8_to_16_ft_fg_pct_season_to_date,
    opp_16_to_24_ft_fga_season_to_date,
    opp_16_to_24_ft_fg_pct_season_to_date,
    opp_24_plus_ft_fga_season_to_date,
    opp_24_plus_ft_fg_pct_season_to_date,
    opp_backcourt_fga_season_to_date,
    opp_backcourt_fg_pct_season_to_date,
    opp_total_fga_season_to_date,
    opp_total_fg_pct_season_to_date,

    -- Last 5 games averages
    opp_above_the_break_3_fga_last_5,
    opp_above_the_break_3_fg_pct_last_5,
    opp_mid_range_fga_last_5,
    opp_mid_range_fg_pct_last_5,
    opp_in_the_paint_non_ra_fga_last_5,
    opp_in_the_paint_non_ra_fg_pct_last_5,
    opp_restricted_area_fga_last_5,
    opp_restricted_area_fg_pct_last_5,
    opp_right_corner_3_fga_last_5,
    opp_right_corner_3_fg_pct_last_5,
    opp_left_corner_3_fga_last_5,
    opp_left_corner_3_fg_pct_last_5,
    opp_less_than_8_ft_fga_last_5,
    opp_less_than_8_ft_fg_pct_last_5,
    opp_8_to_16_ft_fga_last_5,
    opp_8_to_16_ft_fg_pct_last_5,
    opp_16_to_24_ft_fga_last_5,
    opp_16_to_24_ft_fg_pct_last_5,
    opp_24_plus_ft_fga_last_5,
    opp_24_plus_ft_fg_pct_last_5,
    opp_backcourt_fga_last_5,
    opp_backcourt_fg_pct_last_5,
    opp_total_fga_last_5,
    opp_total_fg_pct_last_5,

    -- Vs opponent season to date averages
    opp_above_the_break_3_fga_vs_opp_season_to_date,
    opp_above_the_break_3_fg_pct_vs_opp_season_to_date,
    opp_mid_range_fga_vs_opp_season_to_date,
    opp_mid_range_fg_pct_vs_opp_season_to_date,
    opp_in_the_paint_non_ra_fga_vs_opp_season_to_date,
    opp_in_the_paint_non_ra_fg_pct_vs_opp_season_to_date,
    opp_restricted_area_fga_vs_opp_season_to_date,
    opp_restricted_area_fg_pct_vs_opp_season_to_date,
    opp_right_corner_3_fga_vs_opp_season_to_date,
    opp_right_corner_3_fg_pct_vs_opp_season_to_date,
    opp_left_corner_3_fga_vs_opp_season_to_date,
    opp_left_corner_3_fg_pct_vs_opp_season_to_date,
    opp_less_than_8_ft_fga_vs_opp_season_to_date,
    opp_less_than_8_ft_fg_pct_vs_opp_season_to_date,
    opp_8_to_16_ft_fga_vs_opp_season_to_date,
    opp_8_to_16_ft_fg_pct_vs_opp_season_to_date,
    opp_16_to_24_ft_fga_vs_opp_season_to_date,
    opp_16_to_24_ft_fg_pct_vs_opp_season_to_date,
    opp_24_plus_ft_fga_vs_opp_season_to_date,
    opp_24_plus_ft_fg_pct_vs_opp_season_to_date,
    opp_backcourt_fga_vs_opp_season_to_date,
    opp_backcourt_fg_pct_vs_opp_season_to_date,
    opp_total_fga_vs_opp_season_to_date,
    opp_total_fg_pct_vs_opp_season_to_date

from rolling_defensive_stats
order by team_id, season, game_date