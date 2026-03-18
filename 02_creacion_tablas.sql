-- ============================================================
-- 02 · Creación de tablas
-- Proyecto Olist · Python → MySQL → Tableau
-- ============================================================
-- Ejecutar en MySQL Workbench antes de la inserción de datos.
--
-- Orden obligado por las claves foráneas:
-- customers · products → orders → order_items · reviews
-- ============================================================

CREATE DATABASE IF NOT EXISTS olist;
USE olist;


-- CUSTOMERS — sin dependencias, se crea primero
CREATE TABLE IF NOT EXISTS customers (
    customer_id    VARCHAR(32) NOT NULL,
    customer_state VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

-- PRODUCTS — sin dependencias, se crea antes que order_items
CREATE TABLE IF NOT EXISTS products (
    product_id            VARCHAR(32)  NOT NULL,
    product_category_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (product_id)
);

-- ORDERS — depende de customers
CREATE TABLE IF NOT EXISTS orders (
    order_id                 VARCHAR(32) NOT NULL,
    customer_id              VARCHAR(32) NOT NULL,
    order_purchase_timestamp DATETIME    NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- ORDER_ITEMS — depende de orders y products
CREATE TABLE IF NOT EXISTS order_items (
    order_id   VARCHAR(32)    NOT NULL,
    product_id VARCHAR(32)    NOT NULL,
    price      DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id)   REFERENCES orders(order_id)     ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- REVIEWS — depende de orders
CREATE TABLE IF NOT EXISTS reviews (
    order_id     VARCHAR(32) NOT NULL,
    review_score INT         NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);
