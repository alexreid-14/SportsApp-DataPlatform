with source as (
    select *
    from {{ source('nba', 'teams') }}
)
select
    team_id,
    full_name,
    abbreviation,
    nickname,
    city,
    state,
    year_founded
from source