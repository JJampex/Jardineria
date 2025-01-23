--Listar informaci¨®n b¨¢sica de las oficinas: Recupera el c¨®digo, ciudad, pa¨ªs y tel¨¦fono de todas las oficinas registradas.
select codigo_oficina, ciudad, pais, telefono
from oficina;
--Obtener los empleados por oficina: Muestra el nombre, apellidos y puesto de los empleados que trabajan en cada oficina, agrupados por c¨®digo de oficina.
select e.nombre, e.apellido1, e.apellido2, e.puesto, e.codigo_oficina
from empleado e
join oficina o on e.codigo_oficina = o.codigo_oficina
order by e.codigo_oficina;
--Calcular el promedio de salario (l¨ªmite de cr¨¦dito) de los clientes por regi¨®n: Determina el promedio del l¨ªmite de cr¨¦dito de los clientes agrupados por regi¨®n.
select region, avg(limite_credito) as promedio_limite_credito
from cliente
group by region;
--Listar clientes con sus representantes de ventas: Recupera el nombre completo del cliente junto con el nombre completo del representante de ventas asignado.
select c.nombre_cliente, e.nombre as nombre_rep_ventas, e.apellido1 as apellido_rep_ventas
from cliente c
left join empleado e on c.codigo_empleado_rep_ventas = e.codigo_empleado;
--Obtener productos disponibles y en stock: Lista el c¨®digo, nombre y cantidad en stock de todos los productos que tienen al menos 1 unidad disponible.
select codigo_producto, nombre, cantidad_en_stock
from producto
where cantidad_en_stock > 0;
--Productos con precios por debajo del promedio: Muestra los productos cuyo precio de venta es menor que el precio promedio de todos los productos.
select codigo_producto, nombre, precio_venta
from producto
where precio_venta < (select avg(precio_venta) from producto);
--Pedidos pendientes por cliente: Lista el c¨®digo y estado de todos los pedidos que no han sido entregados (estado diferente de "Entregado") junto con el nombre del cliente.
select p.codigo_pedido, p.estado, c.nombre_cliente
from pedido p
join cliente c on p.codigo_cliente = c.codigo_cliente
where p.estado != 'Entregado';
--Total de productos por categor¨ªa (gama): Obt¨¦n la cantidad total de productos agrupados por categor¨ªa (gama).
select g.gama, sum(p.cantidad_en_stock) as total_productos
from gama_producto g
join producto p on g.gama = p.gama
group by g.gama;
--Ingresos totales generados por cliente: Calcula el total de ingresos generados por cada cliente basado en los pagos realizados.
select c.nombre_cliente, sum(pa.total) as total_ingresos
from cliente c
join pago pa on c.codigo_cliente = pa.codigo_cliente
group by c.codigo_cliente;
--Pedidos realizados en un rango de fechas: Recupera los c¨®digos de pedido y las fechas de los pedidos realizados entre dos fechas espec¨ªficas.
select codigo_pedido, fecha_pedido
from pedido
where fecha_pedido between '2024-01-01' and '2024-12-31';
--Detalles de un pedido espec¨ªfico: Muestra el c¨®digo de pedido, los productos involucrados, las cantidades y el precio total de cada l¨ªnea de pedido.
select dp.codigo_pedido, dp.codigo_producto, p.nombre, dp.cantidad, dp.precio_unidad, (dp.cantidad * dp.precio_unidad) as precio_total
from detalle_pedido dp
join producto p on dp.codigo_producto = p.codigo_producto
where dp.codigo_pedido = 12345;
--Productos m¨¢s vendidos: Lista los productos con mayor cantidad vendida, ordenados de forma descendente por la cantidad total.
select p.codigo_producto, p.nombre, sum(dp.cantidad) as cantidad_total
from detalle_pedido dp
join producto p on dp.codigo_producto = p.codigo_producto
group by p.codigo_producto
order by cantidad_total desc;
--Pedidos con un valor total superior al promedio: Muestra los pedidos cuyo valor total (cantidad * precio_unidad) supera el promedio del valor total de todos los pedidos.
select p.codigo_pedido, sum(dp.cantidad * dp.precio_unidad) as valor_total
from detalle_pedido dp
join pedido p on dp.codigo_pedido = p.codigo_pedido
group by p.codigo_pedido
having sum(dp.cantidad * dp.precio_unidad) > (
    select avg(dp2.cantidad * dp2.precio_unidad)
    from detalle_pedido dp2
);
--Clientes sin representante de ventas asignado: Lista los clientes que no tienen un representante de ventas asociado.
select codigo_cliente, nombre_cliente
from cliente
where codigo_empleado_rep_ventas is null;
--N¨²mero total de empleados por oficina: Calcula la cantidad total de empleados asignados a cada oficina.
select e.codigo_oficina, o.ciudad, o.pais, count(e.codigo_empleado) as total_empleados
from empleado e
join oficina o on e.codigo_oficina = o.codigo_oficina
group by e.codigo_oficina, o.ciudad, o.pais;
--Pagos realizados en una forma espec¨ªfica: Recupera los pagos realizados con una forma de pago espec¨ªfica, como "Tarjeta de Cr¨¦dito".
select codigo_cliente, forma_pago, id_transaccion, fecha_pago, total
from pago
where forma_pago = 'Tarjeta de Cr¨¦dito';
--Ingresos mensuales: Calcula el total de ingresos generados por mes basado en las fechas de pago.
select to_char(fecha_pago, 'YYYY-MM') as mes, sum(total) as ingresos_totales
from pago
group by to_char(fecha_pago, 'YYYY-MM')
order by mes;
--Clientes con m¨²ltiples pedidos: Muestra los nombres de los clientes que tienen m¨¢s de un pedido registrado.
select c.nombre_cliente
from cliente c
join pedido p on c.codigo_cliente = p.codigo_cliente
group by c.codigo_cliente
having count(p.codigo_pedido) > 1;
--Pedidos con productos agotados: Lista los pedidos que incluyen productos cuya cantidad en stock es cero.
select distinct codigo_pedido
from detalle_pedido dp
join producto pr on dp.codigo_producto = pr.codigo_producto
where pr.cantidad_en_stock = 0;
--Promedio, m¨¢ximo y m¨ªnimo del l¨ªmite de cr¨¦dito de los clientes por pa¨ªs: Obt¨¦n el promedio, el valor m¨¢ximo y el m¨ªnimo del l¨ªmite de cr¨¦dito agrupados por pa¨ªs.
select pais,
       avg(limite_credito) as promedio_limite_credito,
       max(limite_credito) as maximo_limite_credito,
       min(limite_credito) as minimo_limite_credito
from cliente
group by pais;
--Historial de transacciones de un cliente: Recupera el historial de pagos realizados por un cliente espec¨ªfico, mostrando fecha, total y forma de pago.
select fecha_pago, total, forma_pago
from pago
where codigo_cliente = --[codigo_cliente_especifico];
--Empleados sin jefe directo asignado: Muestra los empleados que no tienen asignado un c¨®digo de jefe.
select nombre, apellido1, apellido2
from empleado
where codigo_jefe is null;
--Productos cuyo precio supera el promedio de su categor¨ªa (gama): Lista los productos cuyo precio de venta es mayor que el promedio de su gama.
select p.codigo_producto, p.nombre, p.precio_venta, p.gama
from producto p
join (
    select gama, avg(precio_venta) as precio_promedio
    from producto
    group by gama
) avg_price on p.gama = avg_price.gama
where p.precio_venta > avg_price.precio_promedio;
--Promedio de d¨ªas de entrega por estado: Calcula el promedio de d¨ªas entre la fecha de pedido y la fecha de entrega agrupados por estado del pedido.
select estado, 
       avg(datediff(fecha_entrega, fecha_pedido)) as promedio_dias_entrega
from pedido
where fecha_entrega is not null
group by estado;
--Clientes por pa¨ªs con m¨¢s de un pedido: Lista los pa¨ªses con la cantidad de clientes que tienen m¨¢s de un pedido registrado.
select c.pais, count(distinct c.codigo_cliente) as cantidad_clientes
from cliente c
join pedido p on c.codigo_cliente = p.codigo_cliente
group by c.pais
having count(distinct p.codigo_pedido) > 1;
