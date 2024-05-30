/* Consulta 1: Obtener el nombre del cliente, nombre del empleado, fecha
del pedido, nombre del producto, cantidad y precio unitario de cada
producto en cada pedido.*/

SELECT
    c.nombre_cliente,
    e.nombre_empleado,
    p.fecha_pedido,
    pr.nombre_producto,
    dp.cantidad,
    dp.precio_unitario
FROM
    pedidos p
JOIN
    empleados e ON p.empleado_id = e.empleado_id
JOIN
    clientes c ON p.cliente_id = c.cliente_id
JOIN
    detalles_pedido dp ON p.pedido_id = dp.pedido_id
JOIN
    productos pr ON dp.producto_id = pr.producto_id;

/* Consulta 2: Calcular el total de ventas realizadas por cada empleado
durante el último mes, mostrando el nombre del empleado y el monto
total de sus ventas.*/

SELECT
    e.nombre_empleado,
    SUM(dp.cantidad * dp.precio_unitario) AS monto_total_ventas
FROM
    empleados e
JOIN
    pedidos p ON e.empleado_id = p.empleado_id
JOIN
    detalles_pedido dp ON p.pedido_id = dp.pedido_id
WHERE
    p.fecha_pedido BETWEEN date('now', '-1 month') AND date('now')
GROUP BY
    e.nombre_empleado
ORDER BY
    monto_total_ventas DESC;

/*Consulta 3: Encontrar los clientes que han realizado al menos 3 pedidos
durante el último trimestre, mostrando el nombre del cliente y la
cantidad de pedidos realizados*/

SELECT
    c.nombre_cliente,
    COUNT(p.pedido_id) AS cantidad_pedidos
FROM
    pedidos p
JOIN
    clientes c ON p.cliente_id = c.cliente_id
WHERE
    p.fecha_pedido BETWEEN date('now', '-6 months') AND date('now')
GROUP BY
    c.nombre_cliente
HAVING
    COUNT(p.pedido_id) >= 3;


/*Consulta 4: Calcular el promedio de gastos mensuales por cliente
durante el último año, excluyendo aquellos clientes que hayan gastado
menos de $1000 en total.*/

SELECT clientes.nombre_cliente, SUM(detalles_pedido.precio_unitario * detalles_pedido.cantidad) / 12 AS prom_men
FROM clientes
JOIN pedidos ON clientes.cliente_id = pedidos.cliente_id
JOIN detalles_pedido ON pedidos.pedido_id = detalles_pedido.pedido_id
WHERE fecha_pedido BETWEEN date('now', '-1 year') AND date('now')
GROUP BY clientes.nombre_cliente
HAVING SUM(detalles_pedido.precio_unitario * detalles_pedido.cantidad) >= 1000
ORDER BY clientes.nombre_cliente;

/*
 Consulta 5: Determinar el producto más vendido en el último mes.
 */
SELECT productos.nombre_producto, SUM(detalles_pedido.cantidad) AS total_vendido
FROM productos
JOIN detalles_pedido ON productos.producto_id = detalles_pedido.producto_id
JOIN pedidos ON detalles_pedido.pedido_id = pedidos.pedido_id
WHERE fecha_pedido BETWEEN date('now', '-1 month') AND date('now')
GROUP BY productos.nombre_producto
ORDER BY total_vendido DESC
LIMIT 1;

/*
 Consulta 6: Encontrar los empleados que hayan realizado más de 5
pedidos en un día, mostrando el nombre del empleado y la fecha en la
que realizó esos pedidos.
 */
SELECT empleados.nombre_empleado, pedidos.fecha_pedido, COUNT(pedidos.pedido_id) AS cant_pedidos
FROM empleados
JOIN pedidos ON empleados.empleado_id = pedidos.empleado_id
JOIN detalles_pedido ON pedidos.pedido_id = detalles_pedido.pedido_id
GROUP BY empleados.nombre_empleado, pedidos.fecha_pedido
HAVING COUNT(pedidos.pedido_id) >= 2
ORDER BY empleados.nombre_empleado, pedidos.fecha_pedido;

/*
 Consulta 7: Calcular el total de ingresos generados por cada empleado
durante el último trimestre, mostrando el nombre del empleado y el
monto total de ingresos.
 */

SELECT empleados.nombre_empleado, SUM(detalles_pedido.cantidad * detalles_pedido.precio_unitario) AS total_ventas
FROM empleados
JOIN pedidos ON empleados.empleado_id = pedidos.empleado_id
JOIN detalles_pedido ON pedidos.pedido_id = detalles_pedido.pedido_id
WHERE fecha_pedido BETWEEN date('now', '-1 month') AND date('now')
GROUP BY empleados.nombre_empleado
ORDER BY total_ventas DESC;


/*
 Consulta 8: Determinar los clientes que han realizado pedidos por un
total de más de $2000 en el último semestre, ordenados por el total
gastado de forma descendente.
 */


SELECT clientes.nombre_cliente,
       SUM(detalles_pedido.precio_unitario * detalles_pedido.cantidad) AS total_gastado
FROM clientes
JOIN pedidos ON clientes.cliente_id = pedidos.cliente_id
JOIN detalles_pedido ON pedidos.pedido_id = detalles_pedido.pedido_id
WHERE pedidos.fecha_pedido BETWEEN date('now', '-6 months') AND date('now')
GROUP BY clientes.nombre_cliente
HAVING total_gastado >= 2000
ORDER BY total_gastado DESC;

/*
 Consulta 9: Encontrar los empleados que hayan procesado al menos un
pedido en cada mes del último año, mostrando el nombre del empleado
y el mes en el que lo haya logrado
 */


/*
 Consulta 10: Calcular el promedio de pedidos por día durante el último
trimestre
 */

SELECT AVG(pedidos_por_dia.cantidad_pedidos) AS promedio_pedidos_por_dia
FROM (
    SELECT fecha_pedido, COUNT(pedido_id) AS cantidad_pedidos
    FROM pedidos
    WHERE fecha_pedido BETWEEN date('now', '-3 months') AND date('now')
    GROUP BY fecha_pedido
) AS pedidos_por_dia;
