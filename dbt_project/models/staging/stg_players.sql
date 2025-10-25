with source as (
    select *
    from {{ source('nba', 'players') }}
)
select
    player_id,
    full_name,
    first_name,
    last_name,
    draft_year,
    from_year,
    to_year,
    position,
    height,
    weight,
    country
from source