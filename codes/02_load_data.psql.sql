-- Loads the 9 Olist CSV files into the raw schema.
-- Run from psql (NOT from pgAdmin Query Tool, \copy only works in psql).
-- Update DATA_PATH to the folder where the CSV files are stored.

\copy raw.customers FROM 'C:/path/to/Olist_data/olist_customers_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.geolocation FROM 'C:/path/to/Olist_data/olist_geolocation_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.orders FROM 'C:/path/to/Olist_data/olist_orders_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.order_items FROM 'C:/path/to/Olist_data/olist_order_items_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.order_payments FROM 'C:/path/to/Olist_data/olist_order_payments_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.order_reviews FROM 'C:/path/to/Olist_data/olist_order_reviews_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.products FROM 'C:/path/to/Olist_data/olist_products_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.sellers FROM 'C:/path/to/Olist_data/olist_sellers_dataset.csv' CSV HEADER ENCODING 'UTF8'
\copy raw.product_category_translation FROM 'C:/path/to/Olist_data/product_category_name_translation.csv' CSV HEADER ENCODING 'UTF8'

