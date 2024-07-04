-- models/bronze/subscriptions.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "SubscriptionID" as subscription_id,
    "CustomerID" as customer_id,
    "StartDate" as start_date,
    "EndDate" as end_date,
    "Type" as type,
    "Status" as status,
    "extracted_at",
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ source('raw', 'subscriptions') }}  -- References the raw.subscriptions table
