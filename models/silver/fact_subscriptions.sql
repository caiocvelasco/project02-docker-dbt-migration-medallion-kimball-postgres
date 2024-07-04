-- models/silver/fact_subscriptions.sql
-- Transformations:
    -- Ensuring data types are correct
select
    subscription_id,
    customer_id,
    cast(start_date as date) as start_date,  -- Convert to date format
    cast(end_date as date) as end_date,  -- Convert to date format
    type,
    status,
    extracted_at,
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ ref('subscriptions') }}  -- References the bronze.subscriptions table