-- models/bronze/product_usage.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "UsageID" as usage_id,
    "CustomerID" as customer_id,
    "DateID" as date_id,
    "ProductID" as product_id,
    "NumLogins" as num_logins,
    "Amount" as amount,
    "extracted_at",
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ source('raw', 'product_usage') }}  -- References the raw.product_usage table
