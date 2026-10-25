# Proyecto Capstone: Analisis de ventas.

Descripcion:

Este proyecto simula el analisis de ventas de un comercio. El objetivo es limpiar y analizar los datos para conocer el desempeño de las ventas, los clientes con mayor gasto y los productos menos vendidos.

La base de datos esta formada por tres tablas:

 CLIENTES: contiene los datos de los clientes.
 PRODUCTOS: contiene los productos, sus categorias y precios de lista.
 PEDIDOS: contiene las ventas realizadas y relaciona clientes con productos.

Los datos utilizados son ficticios y fueron creados para este proyecto.
----------------------------------------------------------------------------------------

Problema de negocio:

El analisis busca responder las siguientes preguntas:

1. Cuales son los cinco clientes con mayor gasto total?
2. Cual es el monto total vendido por mes?
3. Cuales son los tres productos menos vendidos?
4. Cual es el ranking de pedidos por importe dentro de cada categoria?
----------------------------------------------------------------------------------------

Limpieza de datos:

En la carga de datos se incluyeron algunos valores nulos para simular datos reales.

Los precios unitarios nulos se completaron con el precio de lista del producto mediante COALESCE. La fecha nula no se reemplazo, ya que no era posible determinar la fecha correcta sin inventar informacion. Este registro queda excluido unicamente del analisis mensual.

Tambien se agrego una consulta para comprobar los nulos restantes y otra para verificar que las fechas y los precios tengan los tipos DATE y NUMERIC correspondientes.
----------------------------------------------------------------------------------------

Analisis realizado:

El archivo "analisis.sql" contiene cuatro consultas:

- Top 5 de clientes por gasto total, utilizando JOIN, GROUP BY, SUM y COUNT.
- Ventas por mes, utilizando DATE_TRUNC y funciones de agregacion.
- Tres productos menos vendidos, utilizando LEFT JOIN, CASE y COALESCE.
- Ranking de pedidos por categoria, utilizando una CTE y la funcion de ventana RANK().

Para las metricas de ventas se consideraron solamente los pedidos con estado "entregado".
------------------------------------------------------------------------------------------

Principales hallazgos:

- Ana Torres es la clienta con mayor gasto total, con $242.000 en pedidos entregados.
- Agosto es el mes con mayor facturación entre los meses analizados, con $323.000.
- Los productos con menos unidades vendidas son Lampara de Escritorio y Teclado Mecanico, con 2 unidades cada uno. Mochila Urbana aparece en tercer lugar con 3 unidades.
- El ranking por categoría permite identificar los pedidos con mayor importe sin perder el detalle de cada operación.
-------------------------------------------------------------------------------------------

Archivos:

- estructura.sql: crea las tablas, inserta los datos y realiza la limpieza.
- analisis.sql: contiene las consultas de analisis comentadas.
- README.md: describe el proyecto, sus hallazgos y la forma de ejecucion.
--------------------------------------------------------------------------------------------

Como ejecutar el proyecto:

1. Crear una base de datos en Postgre SQL llamada "capstone_project".
2. Abrir la base de datos desde pgAdmin.
3. Ejecutar primero el archivo "estructura.sql".
4. Ejecutar después el archivo "analisis.sql".
5. Revisar los resultados de las consultas.
-------------------------------------------------------------------------------------------

Conclusión:

El analisis permite identificar a los clientes de mayor valor, observar la evolución mensual de la facturacion y detectar los productos con menor rotacion. Esta informacion podria utilizarse para planificar acciones de fidelizacion, promociones y decisiones comerciales.
