-- Proyecto Capstone: consultas de analisis.
-- Para las metricas comerciales se excluyen pedidos cancelados.

-- 1. Top 5 de clientes por gasto total.
-- Buscamos identificar a los clientes de mayor valor para acciones de fidelización y segmentacion de clientes.
SELECT
    c.cliente_id,
    c.nombre,
    c.ciudad,
    COUNT(pe.pedido_id) AS pedidos_entregados,
    SUM(
        pe.cantidad * COALESCE(pe.precio_unitario, pr.precio_lista)
    ) AS gasto_total
FROM clientes AS c
JOIN pedidos AS pe
    ON pe.cliente_id = c.cliente_id
JOIN productos AS pr
    ON pr.producto_id = pe.producto_id
WHERE pe.estado = 'entregado'
GROUP BY
    c.cliente_id,
    c.nombre,
    c.ciudad
ORDER BY gasto_total DESC
LIMIT 5;

-- 2. Ventas totales por mes.
-- La fecha null se excluye porque asignarle un mes inventado distorsionaria la tendencia.
SELECT
    DATE_TRUNC('month', fecha_pedido)::DATE AS mes,
    SUM(cantidad * precio_unitario) AS ventas_totales,
    COUNT(*) AS cantidad_pedidos
FROM pedidos
WHERE estado = 'entregado'
  AND fecha_pedido IS NOT NULL
GROUP BY DATE_TRUNC('month', fecha_pedido)
ORDER BY mes;

-- 3. Tres productos menos vendidos por unidades.
-- Se usa LEFT JOIN para mantener tambien productos sin ventas, si aparecieran en el futuro.
SELECT
    pr.producto_id,
    pr.nombre_producto,
    pr.categoria,
    COALESCE(SUM(CASE WHEN pe.estado = 'entregado' THEN pe.cantidad ELSE 0 END), 0) AS unidades_vendidas
FROM productos AS pr
LEFT JOIN pedidos AS pe ON pe.producto_id = pr.producto_id
GROUP BY pr.producto_id, pr.nombre_producto, pr.categoria
ORDER BY unidades_vendidas ASC, pr.nombre_producto
LIMIT 3;

-- 4. Ranking de pedidos dentro de cada categoria.
-- El ranking ayuda a detectar que operaciones explican la mayor parte de la facturacion.
WITH pedidos_valorizados AS (
    SELECT
        pe.pedido_id,
        pe.fecha_pedido,
        pr.categoria,
        pr.nombre_producto,
        pe.cantidad * COALESCE(pe.precio_unitario, pr.precio_lista) AS importe_pedido
    FROM pedidos AS pe
    JOIN productos AS pr ON pr.producto_id = pe.producto_id
    WHERE pe.estado = 'entregado'
)
SELECT
    pedido_id,
    fecha_pedido,
    categoria,
    nombre_producto,
    importe_pedido,
    RANK() OVER (
        PARTITION BY categoria
        ORDER BY importe_pedido DESC
    ) AS ranking_en_categoria
FROM pedidos_valorizados
ORDER BY categoria, ranking_en_categoria, pedido_id;
