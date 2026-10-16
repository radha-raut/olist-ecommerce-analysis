# Data Quality Notes: Olist E-commerce Dataset

**Source:** Kaggle Olist Brazilian E-commerce (9 tables, loaded into PostgreSQL)
**Data period:** September 2016 to October 2018 

## Row counts after loading
All 9 tables matched the source CSV counts.

## Issues found and treatment

1. Missing approval date
Table: orders
Count: 160
Treatment: Kept; not used in core analysis

2. Missing delivery date
Table: orders
Count:2965 
Treatment: Excluded from delivery-time analysis

3. Delivered status but no delivery date
Table: orders
Count: 8
Treatment: Excluded from delivery-time analysis

4. Non-delivered orders (canceled, unavailable, etc.)
Table: orders
Count: 2963 (2.98%)
Treatment: Revenue analysis uses delivered orders only

5. Missing product category
Table: products
Count: 610
Treatment: Labelled as 'unknown'

6. Category missing English translation
Table: products
Count: 2 categories
Treatment: Mapped manually / kept original name

7. Duplicate review_id
Table: order_reviews
Count: 789
Treatment: Keep latest review per order

8. Orders with multiple reviews
Table: order_reviews
Count: 547
Treatment: Keep latest review per order

9. Duplicate zip code rows
Table: geolocation
Count: 1000163 rows for 19015 unique zips
Treatment: Aggregated to one row per zip (average lat/lng)

## Integrity checks passed (0 issues)
- Orders without customer: 0
- Order items without order: 0
- Order items without product: 0
- Delivered before purchase date: 0
- Invalid review scores (outside 1-5): 0
- Non-positive price / negative freight: 0

## Key decisions
1. Analysis scope: delivered orders only for revenue and delivery metrics.
2. Reviews deduplicated to one per order before joining.
3. Geolocation reduced to one row per zip code.