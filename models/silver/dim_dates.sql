-- models/silver/dim_dates.sql
-- Transformations:
    -- Ensuring a date format to date
select
    date_id,
    cast(date as date) as date,  -- Convert to date format
    week,
    month,
    quarter,
    year,
    extracted_at,
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ ref('dates') }}  -- References the bronze.dates table