--AWS BILLING PROJECT
--Find out how much are we spending on each customer account
--Analyse which services are we spending money on in the internal accounts
--Check if all EC2 costs are being covered by savings plans or reserved instances

--Having an overview of the Billing Raw Table
SELECT *
FROM SQL_HACKATHON.AWS_BILLING.BILLING_RAW
LIMIT 100;

--Having an overview of the Billing Lookup Accounts Table

SELECT *
FROM SQL_HACKATHON.AWS_BILLING.LOOKUP_ACCOUNTS
LIMIT 100;



--Preview the JSON file 
SELECT data
FROM SQL_HACKATHON.AWS_BILLING.BILLING_RAW
limit 100;

--Extract important columns from the JSON
with cte as
(SELECT 
    data:bill_bill_type::STRING as bill_type
    ,data:bill_billing_entity::STRING as bill_entity
    ,data:line_item_usage_account_id::STRING as account_id
    ,data:line_item_product_code::STRING AS service
    ,data:line_item_line_item_type::STRING as type
    ,data:line_item_line_item_description::STRING as description
    ,data:line_item_unblended_cost::STRING AS cost
    ,data:line_item_currency_code::STRING AS currency
    ,data:discount_total_discount::STRING as discount
    ,data:bill_billing_period_end_date::DATE AS start_date
    ,data:bill_billing_period_end_date::DATE AS end_date
    ,data:savings_plan_offering_type::STRING as savings_plan
    ,data:reservation_start_time::STRING AS reservation_start
    ,data:savings_plan_start_time::STRING AS savings_start
    FROM SQL_HACKATHON.AWS_BILLING.BILLING_RAW )
    --where bill_type = 'Purchase'
    --limit 100000)
    
    SELECT l.name
          ,b.*
    FROM cte b
    left JOIN
    SQL_HACKATHON.AWS_BILLING.LOOKUP_ACCOUNTS l ON l.id=b.account_id  --Join to the lookup on ID
    where account_id != 229665110112 --Exclude the ID of the Parent Company to minimise rows 
    
    ;
--check which plans are majorly used for EC2 cost
    Select
    data:bill_bill_type::STRING as bill_type
    FROM SQL_HACKATHON.AWS_BILLING.BILLING_RAW
    group by 1;

--Create a view to be used for visualisation     
create or replace view SQL_HACKATHON.SUBMISSION_ZONE.VIEW_EC_2 as
with cte as
(SELECT 
    data:bill_bill_type::STRING as bill_type
    ,data:bill_billing_entity::STRING as bill_entity
    ,data:line_item_usage_account_id::STRING as account_id
    ,data:line_item_product_code::STRING AS service
    ,data:line_item_line_item_type::STRING as type
    ,data:line_item_line_item_description::STRING as description
    ,data:line_item_unblended_cost::STRING AS cost
    ,data:line_item_currency_code::STRING AS currency
    ,data:discount_total_discount::STRING as discount
    ,data:bill_billing_period_end_date::DATE AS start_date
    ,data:bill_billing_period_end_date::DATE AS end_date
    ,data:savings_plan_offering_type::STRING as savings_plan
    ,data:reservation_start_time::STRING AS reservation_start
    ,data:savings_plan_start_time::STRING AS savings_start
    --,data:product_instance_type::STRING AS inst
    FROM SQL_HACKATHON.AWS_BILLING.BILLING_RAW )
    --where bill_type = 'Purchase'
    --limit 100000)
    
    SELECT l.name
          ,b.*
    FROM cte b
    left JOIN
    SQL_HACKATHON.AWS_BILLING.LOOKUP_ACCOUNTS l ON l.id=b.account_id
    where account_id != 229665110112
    
    ;

