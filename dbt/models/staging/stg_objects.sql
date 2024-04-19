{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('staging','met_objects') }}
    where accession_year is not null
),

renamed as (
    select
    {{ dbt.safe_cast("object_id", api.Column.translate_type("string")) }} as id,
    department,
    accession_year,
    culture,
    classification

    from source
)

select * from renamed

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}