with box_scores_with_season as (
    select
        bs.player_id,
        bs.player_name,
        bs.team_id,
        bs.game_id,
        bs.minutes_played,
        g.game_date,
        g.season,
        -- Convert season string to integer (e.g., "2010-11" -> 2010)
        cast(split_part(g.season, '-', 1) as integer) as season_year
    from {{ ref('stg_box_scores') }} bs
    left join {{ ref('stg_games') }} g
        on bs.game_id = g.game_id
    -- Include all games where player appears in box score, regardless of playing time
),

player_team_periods as (
    select
        player_id,
        player_name,
        team_id,
        game_id,
        game_date,
        season,
        season_year,
        minutes_played,
        -- Create a row number to identify consecutive games with the same team
        row_number() over (
            partition by player_id, team_id
            order by game_date
        ) as game_sequence,
        -- Calculate the first game date for this player-team combination
        min(game_date) over (
            partition by player_id, team_id
        ) as first_game_date,
        -- Calculate the last game date for this player-team combination
        max(game_date) over (
            partition by player_id, team_id
        ) as last_game_date
    from box_scores_with_season
),

player_team_summary as (
    select
        player_id,
        player_name,
        team_id,
        first_game_date,
        last_game_date,
        -- Calculate duration in days
        (last_game_date - first_game_date) as duration_days,
        -- Calculate duration in years (approximate)
        extract(year from age(last_game_date, first_game_date)) as duration_years,
        -- Count total games (including DNPs)
        count(*) as total_games,
        -- Count games where player actually played
        count(case when minutes_played > 0 then 1 end) as games_played,
        -- Count games where player didn't play
        count(case when minutes_played = 0 then 1 end) as games_dnp,
        -- Get the season range using season_year for proper min/max
        min(season) as first_season,
        max(season) as last_season,
        min(season_year) as first_season_year,
        max(season_year) as last_season_year
    from player_team_periods
    group by
        player_id,
        player_name,
        team_id,
        first_game_date,
        last_game_date
)

select
    pt.player_id,
    pt.player_name,
    pt.team_id,
    t.full_name as team_name,
    t.abbreviation as team_abbreviation,
    pt.first_game_date,
    pt.last_game_date,
    pt.duration_days,
    pt.duration_years,
    pt.total_games,
    pt.games_played,
    pt.games_dnp,
    pt.first_season,
    pt.last_season,
    pt.first_season_year,
    pt.last_season_year,
    -- Create a season range string
    case
        when pt.first_season = pt.last_season
        then pt.first_season
        else pt.first_season || ' - ' || pt.last_season
    end as season_range,
    -- Calculate number of seasons played for this team
    (pt.last_season_year - pt.first_season_year + 1) as seasons_played,
    -- Flag if this is the player's current team (most recent)
    case
        when pt.last_game_date = (
            select max(last_game_date)
            from player_team_summary pts2
            where pts2.player_id = pt.player_id
        )
        then true
        else false
    end as is_current_team
from player_team_summary pt
left join {{ ref('stg_teams') }} t
    on pt.team_id = t.team_id
order by
    pt.player_id,
    pt.first_game_date