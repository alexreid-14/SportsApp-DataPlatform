with all_box_scores as (
    select *
    from {{ ref('stg_box_scores') }}
),

played_box_scores as (
    select *
    from {{ ref('stg_box_scores') }}
    where minutes_played is not null and minutes_played > 0  -- ✅ Only games where player played
),

games as (
    select *,
        min(game_date) over (partition by season) as season_start_date
    from {{ ref('games') }}
),

players as (
    select *
    from {{ ref('stg_players') }}
),

-- Games where the player actually played (for lag)
player_last_played as (
    select
        bs.player_id,
        p.player_position,
        g.season,
        g.game_date,
        g.game_id,
        lag(g.game_date) over (partition by bs.player_id, g.season order by g.game_date) as previous_played_game_date,
        lag(g.game_id) over (partition by bs.player_id, g.season order by g.game_date) as previous_played_game_id
    from played_box_scores bs
    join games g on bs.game_id = g.game_id
    join players p on bs.player_id = p.player_id
),

-- Join all box scores (played or not) to games and use last played info
player_games as (
    select
        g.game_id,
        bs.player_id,
        p.player_position,
        g.game_type,
        g.game_date,
        g.season,
        case
            when bs.team_id = g.home_team_id then 1
            else 0
        end as home_team_flag,
        case
            when bs.team_id = g.home_team_id then g.away_team_id
            else g.home_team_id
        end as opponent_team_id,
        case
            when bs.team_id = g.home_team_id then g.home_team_game_number
            else g.away_team_game_number
        end as team_game_number,
        case
            when bs.team_id = g.home_team_id then g.home_team_wins
            else g.away_team_wins
        end as team_wins,
        case
            when bs.team_id = g.home_team_id then g.home_team_losses
            else g.away_team_losses
        end as team_losses,
        p.previous_played_game_date,
        p.previous_played_game_id,
        g.season_start_date

    from games g
    join all_box_scores bs on g.game_id = bs.game_id
    left join player_last_played p
        on bs.player_id = p.player_id
        and g.season = p.season
        and g.game_id = p.game_id
)

select
    game_id,
    player_id,
    game_type,
    game_date,
    season,
    home_team_flag,
    opponent_team_id,
    team_game_number,
    (team_wins::float/team_game_number::float) as team_win_percentage,
    (game_date - COALESCE(previous_played_game_date, season_start_date)) as days_since_previous_game,
    case
        when (game_date - COALESCE(previous_played_game_date, season_start_date)) = 1 then 1
        else 0
    end as is_back_to_back,
    previous_played_game_id
from player_games
order by player_id, game_date
