-- ============================================================
-- 04 · Consultas de análisis
--
-- Pregunta de negocio:
-- ¿Quién es el cliente de Olist, qué compra, cuándo lo compra
-- y está satisfecho?
--
-- Estas consultas responden las mismas preguntas que el dashboard.
-- Los resultados se leen e interpretan aquí, en Workbench.
-- ============================================================

USE olist;


-- ── KPIs GENERALES ──────────────────────────────────────────

-- Total de pedidos
SELECT COUNT(DISTINCT order_id) AS total_pedidos
FROM orders;

-- Gasto típico por pedido
-- Usamos AVG como aproximación al precio típico.
-- En datos de negocio es habitual encontrar outliers — la mayoría de valores
-- se concentran abajo pero existen algunos muy altos que distorsionan la media.
-- La mediana es más robusta frente a outliers. MySQL no tiene función nativa
-- para calcularla, pero Tableau sí — en el dashboard usamos la mediana.
SELECT ROUND(AVG(precio_total), 2) AS gasto_medio_por_pedido
FROM (
    SELECT order_id, SUM(price) AS precio_total
    FROM order_items
    GROUP BY order_id
) AS pedidos_agrupados;

-- Porcentaje de clientes satisfechos (score 4 o 5)
SELECT
    ROUND(SUM(CASE WHEN review_score >= 4 THEN 1 ELSE 0 END) * 100.0
          / COUNT(*), 1) AS porcentaje_satisfechos
FROM reviews;


-- ── ¿DÓNDE ESTÁN LOS CLIENTES? ──────────────────────────────
SELECT
    c.customer_state                                              AS estado,
    COUNT(DISTINCT o.order_id)                                    AS total_pedidos,
    ROUND(COUNT(DISTINCT o.order_id) * 100.0
          / SUM(COUNT(DISTINCT o.order_id)) OVER (), 1)          AS porcentaje
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_state
ORDER BY total_pedidos DESC
LIMIT 10;


-- ── ¿QUÉ COMPRAN? ───────────────────────────────────────────
SELECT
    p.product_category_name                AS categoria,
    COUNT(oi.order_id)                     AS total_ventas,
    ROUND(AVG(oi.price), 2)               AS precio_medio
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY total_ventas DESC
LIMIT 10;


-- ── ¿CUÁNDO COMPRAN? — día de la semana ─────────────────────
SELECT
    DAYNAME(order_purchase_timestamp) AS dia_semana,
    COUNT(*)                          AS total_pedidos
FROM orders
GROUP BY dia_semana
ORDER BY FIELD(dia_semana,
    'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday');


-- ── ¿EL NEGOCIO CRECE? — evolución mensual ──────────────────
SELECT
    DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS mes,
    COUNT(*)                                        AS total_pedidos
FROM orders
GROUP BY mes
ORDER BY mes;


-- ── ¿ESTÁN SATISFECHOS? — distribución de valoraciones ──────
SELECT
    review_score                                                        AS valoracion,
    COUNT(*)                                                            AS total_reviews,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM reviews), 1)        AS porcentaje
FROM reviews
GROUP BY review_score
ORDER BY review_score;
