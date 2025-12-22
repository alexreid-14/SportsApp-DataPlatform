with player_game as (
    select * from {{ ref('player_game') }}
),

box_scores as (
    select * from {{ ref('stg_box_scores') }}
),

player_stats as (
    select * from {{ ref('int_player_stats') }}
),

player_shots as (
    select * from {{ ref('int_player_shots') }}
),

team_stats as (
    select * from {{ ref('int_team_stats') }}
),

opponent_shot_defense as (
    select * from {{ ref('int_opponent_shot_defense') }}
),

player_points as (
    select
        -- Target Variable
        bs.points as points_scored,

        -- Basic Info
        pg.player_id,
        pg.game_id,
        pg.game_type,
        pg.season,
        pg.home_team_flag,
        pg.team_game_number,
        pg.team_win_percentage,
        pg.days_since_previous_game,
        pg.is_back_to_back,
        pg.player_position,
        ----------------------------
        -- Player stats
        ----------------------------

        -- Season to date
        -- Box Score
        ps.avg_points_season_to_date,
        ps.avg_fgm_season_to_date,
        ps.avg_fga_season_to_date,
        ps.avg_3pm_season_to_date,
        ps.avg_3pa_season_to_date,
        ps.avg_ftm_season_to_date,
        ps.avg_fta_season_to_date,
        ps.avg_mp_season_to_date,
        -- Advanced Box Score
        ps.avg_off_rating_season_to_date,
        ps.avg_e_off_rating_season_to_date,
        ps.avg_efg_pct_season_to_date,
        ps.avg_ts_pct_season_to_date,
        ps.avg_usg_pct_season_to_date,
        ps.avg_e_usg_pct_season_to_date,
        ps.avg_e_pace_season_to_date,
        ps.avg_pace_season_to_date,
        ps.avg_pace_per40_season_to_date,
        ps.avg_poss_season_to_date,
        ps.avg_pie_season_to_date,
        -- Shot data
        psh.avg_above_the_break_3_attempted_count_season_to_date,
        psh.avg_above_the_break_3_pct_season_to_date,
        psh.avg_mid_range_attempted_count_season_to_date,
        psh.avg_mid_range_pct_season_to_date,
        psh.avg_in_the_paint_non_ra_attempted_count_season_to_date,
        psh.avg_in_the_paint_non_ra_pct_season_to_date,
        psh.avg_restricted_area_attempted_count_season_to_date,
        psh.avg_restricted_area_pct_season_to_date,
        psh.avg_right_corner_3_attempted_count_season_to_date,
        psh.avg_right_corner_3_pct_season_to_date,
        psh.avg_left_corner_3_attempted_count_season_to_date,
        psh.avg_left_corner_3_pct_season_to_date,
        psh.avg_less_than_8_ft_attempted_count_season_to_date,
        psh.avg_less_than_8_ft_pct_season_to_date,
        psh.avg_ft_8_to_16_attempted_count_season_to_date,
        psh.avg_ft_8_to_16_pct_season_to_date,
        psh.avg_ft_16_to_24_attempted_count_season_to_date,
        psh.avg_ft_16_to_24_pct_season_to_date,
        psh.avg_ft_24_plus_attempted_count_season_to_date,
        psh.avg_ft_24_plus_pct_season_to_date,
        psh.avg_backcourt_attempted_count_season_to_date,
        psh.avg_backcourt_pct_season_to_date,

        -- Last 5 games
        -- Box Score
        ps.avg_points_last_5,
        ps.avg_fgm_last_5,
        ps.avg_fga_last_5,
        ps.avg_3pm_last_5,
        ps.avg_3pa_last_5,
        ps.avg_ftm_last_5,
        ps.avg_fta_last_5,
        ps.avg_mp_last_5,
        -- Advanced Box Score
        ps.avg_off_rating_last_5,
        ps.avg_e_off_rating_last_5,
        ps.avg_efg_pct_last_5,
        ps.avg_ts_pct_last_5,
        ps.avg_usg_pct_last_5,
        ps.avg_e_usg_pct_last_5,
        ps.avg_e_pace_last_5,
        ps.avg_pace_last_5,
        ps.avg_pace_per40_last_5,
        ps.avg_poss_last_5,
        ps.avg_pie_last_5,
        -- Usage stats
        ps.avg_pct_fgm_last_5,
        ps.avg_pct_fga_last_5,
        ps.avg_pct_fg3m_last_5,
        ps.avg_pct_fg3a_last_5,
        ps.avg_pct_ftm_last_5,
        ps.avg_pct_fta_last_5,
        ps.avg_pct_pts_last_5,

        -- Vs opponent this season
        -- Box Score
        ps.avg_points_vs_opp_this_season,
        ps.avg_fgm_vs_opp_this_season,
        ps.avg_fga_vs_opp_this_season,
        ps.avg_3pm_vs_opp_this_season,
        ps.avg_3pa_vs_opp_this_season,
        ps.avg_ftm_vs_opp_this_season,
        ps.avg_fta_vs_opp_this_season,
        ps.avg_mp_vs_opp_this_season,
        -- Advanced Box Score
        ps.avg_off_rating_vs_opp_this_season,
        ps.avg_e_off_rating_vs_opp_this_season,
        ps.avg_efg_pct_vs_opp_this_season,
        ps.avg_ts_pct_vs_opp_this_season,
        ps.avg_usg_pct_vs_opp_this_season,
        ps.avg_e_usg_pct_vs_opp_this_season,
        ps.avg_e_pace_vs_opp_this_season,
        ps.avg_pace_vs_opp_this_season,
        ps.avg_pace_per40_vs_opp_this_season,
        ps.avg_poss_vs_opp_this_season,
        ps.avg_pie_vs_opp_this_season,
        -- Usage stats
        ps.avg_pct_fgm_vs_opp_this_season,
        ps.avg_pct_fga_vs_opp_this_season,
        ps.avg_pct_fg3m_vs_opp_this_season,
        ps.avg_pct_fg3a_vs_opp_this_season,
        ps.avg_pct_ftm_vs_opp_this_season,
        ps.avg_pct_fta_vs_opp_this_season,
        ps.avg_pct_pts_vs_opp_this_season,


        ----------------------------
        -- Team Stats
        ----------------------------
        -- Season to date
        tso.avg_points_scored_season_to_date,
        tso.avg_off_rating_season_to_date,
        tso.avg_off_e_off_rating_season_to_date,
        tso.avg_off_e_pace_season_to_date,
        tso.avg_off_pace_season_to_date,
        tso.avg_off_pace_per40_season_to_date,
        -- Last 5 games
        tso.avg_points_scored_last_5,
        tso.avg_off_rating_last_5,
        tso.avg_off_e_off_rating_last_5,
        tso.avg_off_e_pace_last_5,
        tso.avg_off_pace_last_5,
        tso.avg_off_pace_per40_last_5,
        -- Vs opponent this season
        tso.avg_points_scored_vs_opp_this_season,
        tso.avg_off_rating_vs_opp_this_season,
        tso.avg_off_e_off_rating_vs_opp_this_season,
        tso.avg_off_e_pace_vs_opp_this_season,
        tso.avg_off_pace_vs_opp_this_season,
        tso.avg_off_pace_per40_vs_opp_this_season,

        ----------------------------
        -- Opponent Team Stats --
        ----------------------------
        -- Season to date
        tsd.avg_points_allowed_season_to_date,
        tsd.avg_3pm_allowed_season_to_date,
        tsd.avg_off_def_rating_season_to_date,
        tsd.avg_off_e_def_rating_season_to_date,
        tsd.avg_off_e_pace_season_to_date,
        tsd.avg_off_pace_season_to_date,
        tsd.avg_off_pace_per40_season_to_date,
        os.opp_above_the_break_3_fga_season_to_date,
        os.opp_above_the_break_3_fg_pct_season_to_date,
        os.opp_mid_range_fga_season_to_date,
        os.opp_mid_range_fg_pct_season_to_date,
        os.opp_in_the_paint_non_ra_fga_season_to_date,
        os.opp_in_the_paint_non_ra_fg_pct_season_to_date,
        os.opp_restricted_area_fga_season_to_date,
        os.opp_restricted_area_fg_pct_season_to_date,
        os.opp_right_corner_3_fga_season_to_date,
        os.opp_right_corner_3_fg_pct_season_to_date,
        os.opp_left_corner_3_fga_season_to_date,
        os.opp_left_corner_3_fg_pct_season_to_date,
        os.opp_less_than_8_ft_fga_season_to_date,
        os.opp_less_than_8_ft_fg_pct_season_to_date,
        os.opp_ft_8_to_16_fga_season_to_date,
        os.opp_ft_8_to_16_fg_pct_season_to_date,
        os.opp_ft_16_to_24_fga_season_to_date,
        os.opp_ft_16_to_24_fg_pct_season_to_date,
        os.opp_ft_24_plus_fga_season_to_date,
        os.opp_ft_24_plus_fg_pct_season_to_date,
        os.opp_backcourt_fga_season_to_date,
        os.opp_backcourt_fg_pct_season_to_date,
        os.opp_total_fga_season_to_date,
        os.opp_total_fg_pct_season_to_date,
        -- Last 5 games
        tsd.avg_points_allowed_last_5,
        tsd.avg_3pm_allowed_last_5,
        tsd.avg_off_def_rating_last_5,
        tsd.avg_off_e_def_rating_last_5,
        tsd.avg_off_e_pace_last_5,
        tsd.avg_off_pace_last_5,
        tsd.avg_off_pace_per40_last_5,
        os.opp_above_the_break_3_fga_last_5,
        os.opp_above_the_break_3_fg_pct_last_5,
        os.opp_mid_range_fga_last_5,
        os.opp_mid_range_fg_pct_last_5,
        os.opp_in_the_paint_non_ra_fga_last_5,
        os.opp_in_the_paint_non_ra_fg_pct_last_5,
        os.opp_restricted_area_fga_last_5,
        os.opp_restricted_area_fg_pct_last_5,
        os.opp_right_corner_3_fga_last_5,
        os.opp_right_corner_3_fg_pct_last_5,
        os.opp_left_corner_3_fga_last_5,
        os.opp_left_corner_3_fg_pct_last_5,
        os.opp_less_than_8_ft_fga_last_5,
        os.opp_less_than_8_ft_fg_pct_last_5,
        os.opp_ft_8_to_16_fga_last_5,
        os.opp_ft_8_to_16_fg_pct_last_5,
        os.opp_ft_16_to_24_fga_last_5,
        os.opp_ft_16_to_24_fg_pct_last_5,
        os.opp_ft_24_plus_fga_last_5,
        os.opp_ft_24_plus_fg_pct_last_5,
        os.opp_backcourt_fga_last_5,
        os.opp_backcourt_fg_pct_last_5,
        os.opp_total_fga_last_5,
        os.opp_total_fg_pct_last_5,
        -- Vs opponent this season
        tsd.avg_points_allowed_vs_opp_this_season,
        tsd.avg_3pm_allowed_vs_opp_this_season,
        tsd.avg_off_def_rating_vs_opp_this_season,
        tsd.avg_off_e_def_rating_vs_opp_this_season,
        tsd.avg_off_e_pace_vs_opp_this_season,
        tsd.avg_off_pace_vs_opp_this_season,
        tsd.avg_off_pace_per40_vs_opp_this_season,
        os.opp_above_the_break_3_fga_vs_opp_season_to_date,
        os.opp_above_the_break_3_fg_pct_vs_opp_season_to_date,
        os.opp_mid_range_fga_vs_opp_season_to_date,
        os.opp_mid_range_fg_pct_vs_opp_season_to_date,
        os.opp_in_the_paint_non_ra_fga_vs_opp_season_to_date,
        os.opp_in_the_paint_non_ra_fg_pct_vs_opp_season_to_date,
        os.opp_restricted_area_fga_vs_opp_season_to_date,
        os.opp_restricted_area_fg_pct_vs_opp_season_to_date,
        os.opp_right_corner_3_fga_vs_opp_season_to_date,
        os.opp_right_corner_3_fg_pct_vs_opp_season_to_date,
        os.opp_left_corner_3_fga_vs_opp_season_to_date,
        os.opp_left_corner_3_fg_pct_vs_opp_season_to_date,
        os.opp_less_than_8_ft_fga_vs_opp_season_to_date,
        os.opp_less_than_8_ft_fg_pct_vs_opp_season_to_date,
        os.opp_ft_8_to_16_fga_vs_opp_season_to_date,
        os.opp_ft_8_to_16_fg_pct_vs_opp_season_to_date,
        os.opp_ft_16_to_24_fga_vs_opp_season_to_date,
        os.opp_ft_16_to_24_fg_pct_vs_opp_season_to_date,
        os.opp_ft_24_plus_fga_vs_opp_season_to_date,
        os.opp_ft_24_plus_fg_pct_vs_opp_season_to_date,
        os.opp_backcourt_fga_vs_opp_season_to_date,
        os.opp_backcourt_fg_pct_vs_opp_season_to_date,
        os.opp_total_fga_vs_opp_season_to_date,
        os.opp_total_fg_pct_vs_opp_season_to_date
    from player_game pg
    join box_scores bs on pg.game_id = bs.game_id and pg.player_id = bs.player_id
    join player_stats ps on pg.game_id = ps.game_id and pg.player_id = ps.player_id
    join player_shots psh on pg.game_id = psh.game_id and pg.player_id = psh.player_id
    join opponent_shot_defense os on pg.game_id = os.game_id and pg.opponent_team_id = os.team_id
    join team_stats tsd on pg.game_id = tsd.game_id and pg.opponent_team_id = tsd.team_id
    join team_stats tso on pg.game_id = tso.game_id and bs.team_id = tso.team_id
)

select * from player_points