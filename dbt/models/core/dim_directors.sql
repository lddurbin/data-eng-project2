{{ config(materialized='table') }}

select
    name, 
    term,
    note_s as notes,
    cast(term_start as date) as term_start_date,
    CASE 
        WHEN term_end = 'NA' THEN CURRENT_DATE
        ELSE CAST(term_end AS DATE)
  END AS term_end_date
from {{ ref('directors') }}