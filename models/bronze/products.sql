-- models/bronze/products.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "ProductID" as product_id,
    "ProductName" as product_name,
    "Category" as category,
    "Price" as price,
    "extracted_at",
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ source('raw', 'products') }}  -- References the raw.products table
