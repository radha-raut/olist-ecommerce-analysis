# DAX Measures and Calculated Columns

All measures live in the `Olist_Measures` table. Table names are as they appear in the Power BI model (`analytics` schema).

## Sales and Orders

```
Total Revenue =
CALCULATE ( SUM ( 'analytics fact_order_items'[price] ), 'analytics fact_order_items'[is_delivered] = TRUE () )

Delivered Orders =
CALCULATE ( COUNTROWS ( 'analytics fact_orders' ), 'analytics fact_orders'[is_delivered] = TRUE () )

AOV =
DIVIDE ( [Total Revenue], [Delivered Orders] )

Revenue PM =
CALCULATE ( [Total Revenue], DATEADD ( 'analytics dim_date'[date_key], -1, MONTH ) )

Revenue MoM % =
DIVIDE ( [Total Revenue] - [Revenue PM], [Revenue PM] )
```

## Delivery and Satisfaction

```
Avg Review Score =
CALCULATE ( AVERAGE ( 'analytics fact_orders'[review_score] ), 'analytics fact_orders'[is_delivered] = TRUE () )

Avg Delivery Days =
CALCULATE ( AVERAGE ( 'analytics fact_orders'[delivery_days] ), 'analytics fact_orders'[is_delivered] = TRUE () )

Late Orders =
CALCULATE (
    COUNTROWS ( 'analytics fact_orders' ),
    'analytics fact_orders'[is_delivered] = TRUE (),
    'analytics fact_orders'[is_late] = TRUE ()
)

Late Delivery % =
DIVIDE ( [Late Orders], [Delivered Orders] )

Bad Review % =
DIVIDE (
    CALCULATE (
        COUNTROWS ( 'analytics fact_orders' ),
        'analytics fact_orders'[is_delivered] = TRUE (),
        'analytics fact_orders'[review_score] IN { 1, 2 }
    ),
    CALCULATE (
        COUNTROWS ( 'analytics fact_orders' ),
        'analytics fact_orders'[is_delivered] = TRUE (),
        NOT ISBLANK ( 'analytics fact_orders'[review_score] )
    )
)
```

`IN { 1, 2 }` is used instead of `<= 2` so that blank review scores are not counted as bad reviews.

## Customers

```
Customers =
COUNTROWS ( 'analytics customer_rfm' )

Repeat Customer % =
DIVIDE (
    CALCULATE ( COUNTROWS ( 'analytics customer_rfm' ), 'analytics customer_rfm'[frequency] > 1 ),
    COUNTROWS ( 'analytics customer_rfm' )
)

RFM Revenue =
SUM ( 'analytics customer_rfm'[monetary] )

RFM Revenue % =
DIVIDE ( [RFM Revenue], CALCULATE ( [RFM Revenue], ALL ( 'analytics customer_rfm' ) ) )

Avg Retention % =
AVERAGE ( 'analytics cohort_retention'[retention_pct] ) / 100
```

## Sellers

```
Active Sellers =
CALCULATE ( DISTINCTCOUNT ( 'analytics fact_order_items'[seller_id] ), 'analytics fact_order_items'[is_delivered] = TRUE () )

Revenue per Seller =
DIVIDE ( [Total Revenue], [Active Sellers] )
```

## Calculated Columns

```
-- Table: analytics fact_orders
Delivery Status =
IF (
    ISBLANK ( 'analytics fact_orders'[is_late] ),
    BLANK (),
    IF ( 'analytics fact_orders'[is_late] = TRUE (), "Late", "On time / early" )
)

-- Table: analytics fact_orders
Delay Bucket =
SWITCH (
    TRUE (),
    ISBLANK ( 'analytics fact_orders'[delay_days] ), BLANK (),
    'analytics fact_orders'[delay_days] <= 0, "1. On time / early",
    'analytics fact_orders'[delay_days] <= 3, "2. 1-3 days late",
    'analytics fact_orders'[delay_days] <= 7, "3. 4-7 days late",
    "4. 8+ days late"
)

-- Table: analytics dim_sellers
Seller Label =
'analytics dim_sellers'[city] & " (" & LEFT ( 'analytics dim_sellers'[seller_id], 6 ) & ")"
```

## Model Relationships (all many-to-one, single direction)
`fact_orders[customer_id]` ---> `dim_customers[customer_id]` 
`fact_orders[purchase_date]` ---> `dim_date[date_key]` 
`fact_order_items[order_id]` ---> `fact_orders[order_id]` 
`fact_order_items[product_id]` ---> `dim_products[product_id]` 
`fact_order_items[seller_id]` ---> `dim_sellers[seller_id]` 

`customer_rfm` and `cohort_retention` are intentionally not related to other tables (`customer_unique_id` is not unique in `dim_customers`).
