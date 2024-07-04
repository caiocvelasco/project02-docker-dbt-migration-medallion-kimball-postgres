-- models/bronze/support_interactions.sql
-- Transformations:
    -- Renaming columns
    -- Updating inserted_at

select
    "InteractionID" as interaction_id,
    "CustomerID" as customer_id,
    "DateID" as date_id,
    "IssueType" as issue_type,
    "ResolutionTime" as resolution_time,
    "extracted_at",
    current_timestamp as inserted_at  -- Overwrite with current timestamp
from {{ source('raw', 'support_interactions') }}  -- References the raw.support_interactions table
