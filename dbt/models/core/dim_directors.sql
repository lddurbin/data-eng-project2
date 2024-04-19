{{ config(materialized='table') }}

select
    name, 
    term,
    note_s as notes 
    term_start,
    term_end
from {{ ref('directors') }}