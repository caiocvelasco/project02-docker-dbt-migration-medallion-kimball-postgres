-- models/bronze/dates.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "DateID" as date_id,
    "Date" as date,
    "Week" as week,
    "Month" as month,
    "Quarter" as quarter,
    "Year" as year,
    "extracted_at",
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ source('raw', 'dates') }}  -- References the raw.dates table