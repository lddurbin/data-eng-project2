{{
    config(
        materialized='table'
    )
}}

with objects as (
    select *
    from {{ ref('stg_objects') }}
), 
dim_directors as (
    select * from {{ ref('dim_directors') }}
)
select objects.id,
objects.department,
objects.accession_year,
objects.culture,
objects.classification,
directors.name, 
directors.term,
directors.notes,
directors.term_start_date,
directors.term_end_date
from objects
left join dim_directors as directors
on objects.accession_year BETWEEN directors.term_start_date and directors.term_end_date
order by accession_year