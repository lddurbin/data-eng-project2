{{ config(materialized='table') }}

with collections_profile as (
    select * from {{ ref('fact_objects') }}
)
select
accession_year,
department,
culture,
classification,
name,
count(distinct id) as total_objects
from collections_profile
where name is not null
group by 1, 2, 3, 4, 5
order by accession_year, total_objects desc