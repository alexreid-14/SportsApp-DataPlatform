with games as (
    select * from {{ ref('stg_games') }}
),

games_with_team_metrics as (
    select
        game_id,
        season,
        team_id,
        game_date,
        matchup,
        is_win,
        points,
        row_number() over (partition by season, team_id order by game_date) as team_game_number,
        sum(case when is_win = true then 1 else 0 end) over (partition by season, team_id order by game_date rows between unbounded preceding and 1 preceding) as team_wins_before_game,
        sum(case when is_win = false then 1 else 0 end) over (partition by season, team_id order by game_date rows between unbounded preceding and 1 preceding) as team_losses_before_game
    from games
),

home as (
    select * from games_with_team_metrics where matchup like '%vs.%'
),
away as (
    select * from games_with_team_metrics where matchup like '%@%'
)

select
    home.game_id,
    home.game_date,
    home.season,
    home.team_id as home_team_id,
    away.team_id as away_team_id,

    home.team_game_number as home_team_game_number,
    away.team_game_number as away_team_game_number,

    coalesce(home.team_wins_before_game, 0) as home_team_wins,
    coalesce(home.team_losses_before_game, 0) as home_team_losses,
    coalesce(away.team_wins_before_game, 0) as away_team_wins,
    coalesce(away.team_losses_before_game, 0) as away_team_losses,

    home.is_win as home_team_win,
    home.points as home_team_score,
    away.points as away_team_score

from home
join away
    on home.game_id = away.game_id
    with games as (
    select * from {{ ref('stg_games') }}
),

games_with_team_metrics as (
    select
        game_id,
        season,
        team_id,
        game_date,
        matchup,
        is_win,
        points,
        row_number() over (partition by season, team_id order by game_date) as team_game_number,
        sum(case when is_win = true then 1 else 0 end) over (partition by season, team_id order by game_date rows between unbounded preceding and 1 preceding) as team_wins_before_game,
        sum(case when is_win = false then 1 else 0 end) over (partition by season, team_id order by game_date rows between unbounded preceding and 1 preceding) as team_losses_before_game
    from games
),

home as (
    select * from games_with_team_metrics where matchup like '%vs.%'
),
away as (
    select * from games_with_team_metrics where matchup like '%@%'
)

select
    home.game_id,
    home.game_date,
    home.season,
    home.team_id as home_team_id,
    away.team_id as away_team_id,

    home.team_game_number as home_team_game_number,
    away.team_game_number as away_team_game_number,

    coalesce(home.team_wins_before_game, 0) as home_team_wins,
    coalesce(home.team_losses_before_game, 0) as home_team_losses,
    coalesce(away.team_wins_before_game, 0) as away_team_wins,
    coalesce(away.team_losses_before_game, 0) as away_team_losses,

    home.is_win as home_team_win,
    home.points as home_team_score,
    away.points as away_team_score

from home
join away
    on home.game_id = away.game_id
    and home.team_id != away.team_id



