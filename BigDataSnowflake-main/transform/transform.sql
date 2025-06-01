CREATE TABLE items (
    product_id SERIAL PRIMARY KEY,
    weight INT,
    name TEXT,
    category TEXT,
    price INT,
    brand TEXT,
    reviews INT,
    material TEXT,
    size TEXT,
    description TEXT,
    rating INT,
    color TEXT,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE buyers (
    customer_id SERIAL PRIMARY KEY,
    last_name TEXT,
    email TEXT UNIQUE,
    first_name TEXT,
    postal_code TEXT,
    age INT,
    pet_type TEXT,
    country TEXT,
    pet_name TEXT,
    pet_breed TEXT
);

CREATE TABLE sellers (
    seller_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    country TEXT,
    email TEXT UNIQUE,
    postal_code TEXT
);

CREATE TABLE providers (
    supplier_id SERIAL PRIMARY KEY,
    contact TEXT,
    email TEXT,
    name TEXT,
    country TEXT,
    address TEXT,
    phone TEXT,
    city TEXT
);

CREATE TABLE shops (
    store_id SERIAL PRIMARY KEY,
    location TEXT,
    city TEXT,
    name TEXT,
    email TEXT,
    country TEXT,
    state TEXT,
    phone TEXT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    customer_id INT REFERENCES buyers(customer_id),
    product_id INT REFERENCES items(product_id),
    quantity INT,
    seller_id INT REFERENCES sellers(seller_id),
    supplier_id INT REFERENCES providers(supplier_id),
    total_price INT,
    store_id INT REFERENCES shops(store_id),
    sale_date DATE
);


-- Перенос данных
INSERT INTO items (name, category, price, weight, color, size, brand, material, description, rating, reviews, release_date, expiry_date)
SELECT DISTINCT product_name, product_category, product_price, product_weight, product_color, product_size, product_brand, product_material, product_description, product_rating, product_reviews, product_release_date, product_expiry_date
FROM data;

INSERT INTO buyers (first_name, last_name, age, email, country, postal_code, pet_type, pet_name, pet_breed)
SELECT DISTINCT customer_first_name, customer_last_name, customer_age, customer_email, customer_country, customer_postal_code, customer_pet_type, customer_pet_name, customer_pet_breed
FROM data;

INSERT INTO sellers (first_name, last_name, email, country, postal_code)
SELECT DISTINCT seller_first_name, seller_last_name, seller_email, seller_country, seller_postal_code
FROM data;

INSERT INTO providers (name, contact, email, phone, address, city, country)
SELECT DISTINCT supplier_name, supplier_contact, supplier_email, supplier_phone, supplier_address, supplier_city, supplier_country
FROM data;

INSERT INTO shops (name, location, city, state, country, phone, email)
SELECT DISTINCT store_name, store_location, store_city, store_state, store_country, store_phone, store_email
FROM data;

INSERT INTO sales (customer_id, seller_id, product_id, store_id, supplier_id, sale_date, quantity, total_price)
SELECT 
    c.customer_id, 
    s.seller_id, 
    p.product_id, 
    st.store_id, 
    sp.supplier_id, 
    m.sale_date, 
    m.sale_quantity, 
    m.sale_total_price
FROM data m
JOIN buyers c ON m.customer_email = c.email
JOIN sellers s ON m.seller_email = s.email
JOIN items p ON m.product_name = p.name AND m.product_category = p.category
JOIN shops st ON m.store_name = st.name AND m.store_city = st.city
JOIN providers sp ON m.supplier_name = sp.name AND m.supplier_email = sp.email
LIMIT 1000 OFFSET 10;
