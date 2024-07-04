-- models/bronze/customers.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "CustomerID" as customer_id,
    "Name" as name,
    "Age" as age,
    "Gender" as gender,
    "SignupDate" as signup_date,
    "extracted_at",
    current_timestamp as inserted_at  -- -- Overwrite with current timestamp
from {{ source('raw','customers') }}  -- References the bronze.customers table