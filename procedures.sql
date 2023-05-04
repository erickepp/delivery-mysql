/*************************** Funcionalidades **************************/
/*********************** 1. Registrar restaurante **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarRestaurante $$ CREATE PROCEDURE RegistrarRestaurante (
    IN id_in VARCHAR(50),
    IN direccion_in VARCHAR(100),
    IN municipio_in VARCHAR(50),
    IN zona_in INT,
    IN telefono_in INT,
    IN personal_in INT,
    IN tiene_parqueo_in BOOLEAN
)
registrar_restaurante:BEGIN

/* YA EXISTE */
IF (SELECT COUNT(*) FROM restaurantes WHERE id = id_in) THEN
    SELECT CONCAT('RESTAURANTE \'', id_in, '\' YA EXISTENTE.') AS ERROR;
    LEAVE registrar_restaurante;
END IF;

/* VALIDAR ZONA */
IF (zona_in <= 0) THEN
    SELECT 'LA ZONA DEBE SER UN ENTERO POSITIVO.' AS ERROR;
    LEAVE registrar_restaurante;
END IF;

/* VALIDAR PERSONAL */
IF (personal_in <= 0) THEN
    SELECT 'EL PERSONAL DEBE SER UN ENTERO POSITIVO.' AS ERROR;
    LEAVE registrar_restaurante;
END IF;

INSERT INTO restaurantes (id, direccion, municipio, zona, telefono, personal, tiene_parqueo)
VALUES (id_in, direccion_in, municipio_in, zona_in, telefono_in, personal_in, tiene_parqueo_in);

/* MENSAJE */
SELECT CONCAT('RESTAURANTE \'', id_in, '\' REGISTRADO.') AS MENSAJE;
END $$


/****************** 2. Registrar puesto de trabajo *****************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarPuesto $$ CREATE PROCEDURE RegistrarPuesto (
    IN nombre_in VARCHAR(50),
    IN descripcion_in VARCHAR(100),
    IN salario_in DOUBLE
)
registrar_puesto:BEGIN

/* YA EXISTE */
IF (SELECT COUNT(*) FROM puestos WHERE LOWER(nombre) = LOWER(nombre_in)) THEN
    SELECT CONCAT('PUESTO \'', nombre_in, '\' YA EXISTENTE.') AS ERROR;
    LEAVE registrar_puesto;
END IF;

/* VALIDAR SALARIO */
IF (salario_in <= 0) THEN
    SELECT 'EL SALARIO DEBE SER UN NÚMERO POSITIVO.' AS ERROR;
    LEAVE registrar_puesto;
END IF;

INSERT INTO puestos (nombre, descripcion, salario)
VALUES (nombre_in, descripcion_in, salario_in);

/* MENSAJE */
SELECT CONCAT('PUESTO \'', nombre_in, '\' REGISTRADO.') AS MENSAJE;
END $$


/*********************** 3. Crear empleado **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS CrearEmpleado $$ CREATE PROCEDURE CrearEmpleado (
    IN nombres_in VARCHAR(100),
    IN apellidos_in VARCHAR(100),
    IN fecha_nacimiento_in VARCHAR(25),
    IN correo_in VARCHAR(50),
    IN telefono_in INT,
    IN direccion_in VARCHAR(100),
    IN numero_dpi_in BIGINT,
    IN puesto_id_in INT,
    IN fecha_inicio_in VARCHAR(25),
    IN restaurante_id_in VARCHAR(50)
)
crear_empleado:BEGIN

/* YA EXISTE */
IF (SELECT COUNT(*) FROM empleados WHERE numero_dpi = numero_dpi_in) THEN
    SELECT CONCAT('EMPLEADO CON DPI \'', numero_dpi_in, '\' YA EXISTENTE.') AS ERROR;
    LEAVE crear_empleado;
END IF;

/* VALIDAR CORREO */
IF (SELECT REGEXP_INSTR(correo_in, '^[^@]+@[^@]+\.[a-zA-Z]{2,}$') = 0) THEN
    SELECT 'EL CORREO NO ES VÁLIDO.' AS ERROR;
    LEAVE crear_empleado;
END IF;

/* EXISTE PUESTO */
IF ((SELECT COUNT(*) FROM puestos WHERE id = puesto_id_in) = 0) THEN
    SELECT CONCAT('EL PUESTO \'', puesto_id_in ,'\' NO EXISTE.') AS ERROR;
    LEAVE crear_empleado;
END IF;

/* EXISTE RESTAURANTE */
IF ((SELECT COUNT(*) FROM restaurantes WHERE id = restaurante_id_in) = 0) THEN
    SELECT CONCAT('EL RESTAURANTE \'', restaurante_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE crear_empleado;
END IF;

/* VALIDAR LÍMITE DEL PERSONAL */
IF ((SELECT personal FROM restaurantes WHERE id = restaurante_id_in) =
    (SELECT COUNT(*) FROM empleados WHERE restaurante_id = restaurante_id_in)) THEN
    SELECT CONCAT('LÍMITE DEL PERSONAL ALCANZADO.') AS ERROR;
    LEAVE crear_empleado;
END IF;

INSERT INTO empleados (nombres, apellidos, fecha_nacimiento, correo, telefono, direccion,
    numero_dpi, fecha_inicio, restaurante_id, puesto_id)
VALUES (nombres_in, apellidos_in, STR_TO_DATE(fecha_nacimiento_in, '%Y-%m-%d'), correo_in,
    telefono_in, direccion_in, numero_dpi_in, STR_TO_DATE(fecha_inicio_in, '%Y-%m-%d'),
    restaurante_id_in, puesto_id_in);

/* MENSAJE */
SELECT CONCAT('EMPLEADO CON DPI \'', numero_dpi_in, '\' REGISTRADO.') AS MENSAJE;
END $$


/*********************** 4. Registrar cliente **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarCliente $$ CREATE PROCEDURE RegistrarCliente (
    IN numero_dpi_in BIGINT,
    IN nombre_in VARCHAR(50),
    IN apellidos_in VARCHAR(100),
    IN fecha_nacimiento_in VARCHAR(25),
    IN correo_in VARCHAR(50),
    IN telefono_in INT,
    IN nit_in INT
)
registrar_cliente:BEGIN

/* YA EXISTE */
IF (SELECT COUNT(*) FROM clientes WHERE numero_dpi = numero_dpi_in) THEN
    SELECT CONCAT('CLIENTE CON DPI \'', numero_dpi_in, '\' YA EXISTENTE.') AS ERROR;
    LEAVE registrar_cliente;
END IF;

/* VALIDAR CORREO */
IF (SELECT REGEXP_INSTR(correo_in, '^[^@]+@[^@]+\.[a-zA-Z]{2,}$') = 0) THEN
    SELECT 'EL CORREO NO ES VÁLIDO.' AS ERROR;
    LEAVE registrar_cliente;
END IF;

INSERT INTO clientes (numero_dpi, nombre, apellidos, fecha_nacimiento, correo, telefono, nit)
VALUES (numero_dpi_in, nombre_in, apellidos_in, STR_TO_DATE(fecha_nacimiento_in, '%Y-%m-%d'),
    correo_in, telefono_in, nit_in);

/* MENSAJE */
SELECT CONCAT('CLIENTE CON DPI \'', numero_dpi_in, '\' REGISTRADO.') AS MENSAJE;
END $$


/*********************** 5. Registrar dirección **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS RegistrarDireccion $$ CREATE PROCEDURE RegistrarDireccion (
    IN cliente_dpi_in BIGINT,
    IN direccion_in VARCHAR(100),
    IN municipio_in VARCHAR(50),
    IN zona_in INT
)
registrar_direccion:BEGIN

/* EXISTE CLIENTE */
IF ((SELECT COUNT(*) FROM clientes WHERE numero_dpi = cliente_dpi_in) = 0) THEN
    SELECT CONCAT('EL CLIENTE CON DPI \'', cliente_dpi_in, '\' NO EXISTE.') AS ERROR;
    LEAVE registrar_direccion;
END IF;

/* VALIDAR ZONA */
IF (zona_in <= 0) THEN
    SELECT 'LA ZONA DEBE SER UN ENTERO POSITIVO.' AS ERROR;
    LEAVE registrar_direccion;
END IF;

INSERT INTO direcciones (direccion, municipio, zona, cliente_dpi)
VALUES (direccion_in, municipio_in, zona_in, cliente_dpi_in);

/* MENSAJE */
SELECT CONCAT('DIRECCIÓN \'', direccion_in, '\' REGISTRADA.') AS MENSAJE;
END $$


/*********************** 6. Crear orden **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS CrearOrden $$ CREATE PROCEDURE CrearOrden (
    IN cliente_dpi_in BIGINT,
    IN direccion_id_in INT,
    IN canal_in CHAR(1)
)
crear_orden:BEGIN

DECLARE estado_in VARCHAR(25) DEFAULT 'INICIADA';
DECLARE restaurante_id_in VARCHAR(50);

/* EXISTE CLIENTE */
IF ((SELECT COUNT(*) FROM clientes WHERE numero_dpi = cliente_dpi_in) = 0) THEN
    SELECT CONCAT('EL CLIENTE CON DPI \'', cliente_dpi_in, '\' NO EXISTE.') AS ERROR;
    LEAVE crear_orden;
END IF;

/* VALIDAR DIRECCIÓN */
IF ((SELECT COUNT(*) FROM direcciones
    WHERE id = direccion_id_in AND cliente_dpi = cliente_dpi_in) = 0) THEN
    SELECT CONCAT('LA DIRECCIÓN, \'', direccion_id_in,
        '\' NO PERTENECE AL CLIENTE \'', cliente_dpi_in, '\'.') AS ERROR;
    LEAVE crear_orden;
END IF;

/* VALIDAR CANAL */
IF (LOWER(canal_in) NOT IN ('L', 'A')) THEN
    SELECT 'EL CANAL DEBE SER \'L\' o \'A\'.' AS ERROR;
    LEAVE crear_orden;
END IF;

SELECT restaurantes.id INTO restaurante_id_in FROM restaurantes
INNER JOIN (SELECT * FROM direcciones WHERE id = direccion_id_in) AS direccion
ON restaurantes.zona = direccion.zona
AND LOWER(restaurantes.municipio) = LOWER(direccion.municipio);

/* VALIDAR COBERTURA */
IF (restaurante_id_in IS NULL) THEN
    SET estado_in = 'SIN COBERTURA';
END IF;

INSERT INTO ordenes (canal, fecha_inicio, estado, cliente_dpi, direccion_id, restaurante_id)
VALUES (canal_in, NOW(), estado_in, cliente_dpi_in, direccion_id_in, restaurante_id_in);

/* MENSAJE */
IF (estado_in = 'INICIADA') THEN
    SELECT CONCAT('ORDEN \'', LAST_INSERT_ID(), '\' REGISTRADA.') AS MENSAJE;
ELSE
    SELECT CONCAT('ORDEN \'', LAST_INSERT_ID(), '\' REGISTRADA (SIN COBERTURA).') AS MENSAJE;
END IF;
END $$


/********************* 7. Agregar ítems a la orden ********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS AgregarItem $$ CREATE PROCEDURE AgregarItem (
    IN orden_id_in INT,
    IN tipo_producto_in CHAR(1),
    IN producto_in INT,
    IN cantidad_in INT,
    IN observacion_in VARCHAR(100)
)
agregar_item:BEGIN

DECLARE estado_orden VARCHAR(25);
SELECT estado INTO estado_orden FROM ordenes WHERE id = orden_id_in;

/* EXISTE ORDEN */
IF (estado_orden IS NULL) THEN
    SELECT CONCAT('LA ORDEN \'', orden_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE agregar_item;
END IF;

/* VALIDAR ESTADO DE ORDEN */
IF (LOWER(estado_orden) NOT IN ('iniciada', 'agregando')) THEN
    SELECT CONCAT('NO SE PUEDEN AGREGAR ITEMS, ORDEN ', estado_orden, '.') AS ERROR;
    LEAVE agregar_item;
END IF;

/* VALIDAR TIPO DE PRODUCTO */
IF (LOWER(tipo_producto_in) NOT IN ('c', 'e', 'b', 'p')) THEN
    SELECT 'EL TIPO DE PRODUCTO DEBE SER \'C\', \'E\', \'B\' o \'P\'.' AS ERROR;
    LEAVE agregar_item;
END IF;

/* VALIDAR PRODUCTO */
IF ((SELECT COUNT(*) FROM items
    WHERE LOWER(id) = LOWER(CONCAT(tipo_producto_in, producto_in))) = 0) THEN
    SELECT CONCAT('EL PRODUCTO \'',
        CASE LOWER(tipo_producto_in)
            WHEN 'c' THEN 'Combo'
            WHEN 'e' THEN 'Extra'
            WHEN 'b' THEN 'Bebida'
            ELSE 'Postre'
        END,
        ' ', producto_in, '\' NO EXISTE.') AS ERROR;
    LEAVE agregar_item;
END IF;

/* VALIDAR CANTIDAD */
IF (cantidad_in <= 0) THEN
    SELECT 'LA CANTIDAD DEBE SER UN ENTERO POSITIVO.' AS ERROR;
    LEAVE agregar_item;
END IF;

INSERT INTO detalle_ordenes (cantidad, observacion, orden_id, item_id)
VALUES (cantidad_in, observacion_in, orden_id_in, CONCAT(tipo_producto_in, producto_in));

IF (LOWER(estado_orden) = 'iniciada') THEN
    UPDATE ordenes
    SET estado = 'AGREGANDO'
    WHERE id = orden_id_in;
END IF;

/* MENSAJE */
SELECT CONCAT('ITEM \'', CONCAT(tipo_producto_in, producto_in), '\' REGISTRADO.') AS MENSAJE;
END $$


/********************* 8. Confirmar orden ********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConfirmarOrden $$ CREATE PROCEDURE ConfirmarOrden (
    IN orden_id_in INT,
    IN forma_pago_in CHAR(1),
    IN empleado_id_in INT
)
confirmar_orden:BEGIN

DECLARE estado_orden VARCHAR(25);
DECLARE numero_serie_in INT;
DECLARE monto_total_in DOUBLE;
DECLARE lugar_in VARCHAR(50);
DECLARE nit_cliente_in INT;

SELECT estado INTO estado_orden FROM ordenes WHERE id = orden_id_in;

/* EXISTE ORDEN */
IF (estado_orden IS NULL) THEN
    SELECT CONCAT('LA ORDEN \'', orden_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE confirmar_orden;
END IF;

/* VALIDAR ESTADO DE ORDEN */
IF (LOWER(estado_orden) != 'agregando') THEN
    SELECT CONCAT('NO SE PUEDE CONFIRMAR ORDEN CON ESTADO ', estado_orden, '.') AS ERROR;
    LEAVE confirmar_orden;
END IF;

/* VALIDAR FORMA DE PAGO */
IF (LOWER(forma_pago_in) NOT IN ('E', 'T')) THEN
    SELECT 'LA FORMA DE PAGO DEBE SER \'E\' o \'T\'.' AS ERROR;
    LEAVE confirmar_orden;
END IF;

/* EXISTE EMPLEADO */
IF ((SELECT COUNT(*) FROM empleados WHERE id = empleado_id_in) = 0) THEN
    SELECT CONCAT('EL EMPLEADO \'', empleado_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE confirmar_orden;
END IF;

SET numero_serie_in = CAST(CONCAT(YEAR(NOW()), orden_id_in) AS UNSIGNED);

SELECT SUM(cantidad * precio) + (0.12 * SUM(cantidad * precio))
INTO monto_total_in FROM detalle_ordenes
INNER JOIN items
ON LOWER(detalle_ordenes.item_id) = LOWER(items.id)
WHERE detalle_ordenes.orden_id = orden_id_in;

SELECT direcciones.municipio INTO lugar_in FROM ordenes
INNER JOIN direcciones
ON ordenes.direccion_id = direcciones.id
WHERE ordenes.id = orden_id_in;

SELECT clientes.nit INTO nit_cliente_in FROM ordenes
INNER JOIN clientes
ON ordenes.cliente_dpi = clientes.numero_dpi
WHERE ordenes.id = orden_id_in;

INSERT INTO facturas (numero_serie, monto_total, lugar, fecha, nit_cliente, forma_pago, orden_id)
VALUES (numero_serie_in, monto_total_in, lugar_in, NOW(), nit_cliente_in, forma_pago_in, orden_id_in);

UPDATE ordenes
SET estado = 'EN CAMINO', empleado_id = empleado_id_in
WHERE id = orden_id_in;

SELECT
    numero_serie,
    monto_total,
    lugar,
    fecha,
    orden_id,
    COALESCE(nit_cliente, 'C/F') AS nit_cliente,
    CASE LOWER(forma_pago)
        WHEN 'e' THEN 'Efectivo'
        WHEN 't' THEN 'Tarjeta'
    END AS forma_pago
FROM facturas WHERE numero_serie = numero_serie_in;
END $$


/********************* 9. Finalizar orden ********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS FinalizarOrden $$ CREATE PROCEDURE FinalizarOrden (
    IN orden_id_in INT
)
finalizar_orden:BEGIN

DECLARE estado_orden VARCHAR(25);
SELECT estado INTO estado_orden FROM ordenes WHERE id = orden_id_in;

/* EXISTE ORDEN */
IF (estado_orden IS NULL) THEN
    SELECT CONCAT('LA ORDEN \'', orden_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE finalizar_orden;
END IF;

/* VALIDAR ESTADO DE ORDEN */
IF (LOWER(estado_orden) != 'en camino') THEN
    SELECT CONCAT('NO SE PUEDE FINALIZAR ORDEN CON ESTADO ', estado_orden, '.') AS ERROR;
    LEAVE finalizar_orden;
END IF;

UPDATE ordenes
SET estado = 'ENTREGADA', fecha_entrega = NOW()
WHERE id = orden_id_in;

/* MENSAJE */
SELECT CONCAT('ORDEN \'', orden_id_in, '\' FINALIZADA.') AS MENSAJE;
END $$


/***************************** Reportería ****************************/
/*********************** 1. Listar restaurantes **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ListarRestaurantes $$ CREATE PROCEDURE ListarRestaurantes ()
BEGIN
SELECT id, direccion, municipio, zona, telefono, personal,
    CASE tiene_parqueo
        WHEN 0 THEN 'No'
        WHEN 1 THEN 'Sí'
    END AS tiene_parqueo
FROM restaurantes;
END $$


/*********************** 2. Consultar empleado **********************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarEmpleado $$ CREATE PROCEDURE ConsultarEmpleado (
    IN empleado_id_in INT
)
consultar_empleado:BEGIN

/* EXISTE EMPLEADO */
IF ((SELECT COUNT(*) FROM empleados WHERE id = empleado_id_in) = 0) THEN
    SELECT CONCAT('EL EMPLEADO \'', empleado_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE consultar_empleado;
END IF;

SELECT
    LPAD(empleados.id, 8, 0) AS id,
    CONCAT(empleados.nombres, ' ', empleados.apellidos) AS nombre_completo,
    empleados.fecha_nacimiento,
    empleados.correo,
    empleados.telefono,
    empleados.direccion,
    empleados.numero_dpi,
    puestos.nombre AS nombre_puesto,
    empleados.fecha_inicio,
    puestos.salario
FROM empleados
INNER JOIN puestos
ON empleados.puesto_id = puestos.id
WHERE empleados.id = empleado_id_in;
END $$


/******************* 3. Consultar detalle del pedido ******************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarPedidosCliente $$ CREATE PROCEDURE ConsultarPedidosCliente (
    IN orden_id_in INT
)
consultar_pedidos_cliente:BEGIN

/* EXISTE ORDEN */
IF ((SELECT COUNT(*) FROM ordenes WHERE id = orden_id_in) = 0) THEN
    SELECT CONCAT('LA ORDEN \'', orden_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE consultar_pedidos_cliente;
END IF;

/* EXISTE CLIENTE */
IF ((SELECT COUNT(*) FROM ordenes WHERE id = orden_id_in) = 0) THEN
    SELECT CONCAT('LA ORDEN \'', orden_id_in, '\' NO EXISTE.') AS ERROR;
    LEAVE consultar_pedidos_cliente;
END IF;

SELECT
    items.producto AS producto,
    CASE LOWER(SUBSTRING(items.id, 1, 1))
        WHEN 'c' THEN 'Combo'
        WHEN 'e' THEN 'Extra'
        WHEN 'b' THEN 'Bebida'
        ELSE 'Postre'
    END AS tipo_producto,
    items.precio,
    detalle_ordenes.cantidad,
    detalle_ordenes.observacion
FROM detalle_ordenes
INNER JOIN items
ON LOWER(detalle_ordenes.item_id) = LOWER(items.id)
WHERE detalle_ordenes.orden_id = orden_id_in;
END $$


/********** 4. Consultar el historial de órdenes de un cliente *********/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarHistorialOrdenes $$ CREATE PROCEDURE ConsultarHistorialOrdenes (
    IN cliente_dpi_in BIGINT
)
consultar_historial_ordenes:BEGIN

/* EXISTE CLIENTE */
IF ((SELECT COUNT(*) FROM clientes WHERE numero_dpi = cliente_dpi_in) = 0) THEN
    SELECT CONCAT('EL CLIENTE CON DPI \'', cliente_dpi_in, '\' NO EXISTE.') AS ERROR;
    LEAVE consultar_historial_ordenes;
END IF;

SELECT
    ordenes.id,
    ordenes.fecha_inicio AS fecha,
    COALESCE(facturas.monto_total, 0) AS monto,
    COALESCE(restaurantes.id, '') AS restaurante,
    COALESCE(CONCAT(empleados.nombres, ' ', empleados.apellidos), '') AS repartidor,
    direcciones.direccion AS direccion_envio,
    CASE LOWER(ordenes.canal)
        WHEN 'l' THEN 'Llamada'
        WHEN 'a' THEN 'Aplicación'
    END AS canal
FROM ordenes
LEFT JOIN facturas
ON ordenes.id = facturas.orden_id
LEFT JOIN restaurantes
ON ordenes.restaurante_id = restaurantes.id
LEFT JOIN empleados
ON ordenes.empleado_id = empleados.id
INNER JOIN direcciones
ON ordenes.direccion_id = direcciones.id
WHERE ordenes.cliente_dpi = cliente_dpi_in;
END $$


/**************** 5. Consultar direcciones de un cliente ***************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarDirecciones $$ CREATE PROCEDURE ConsultarDirecciones (
    IN cliente_dpi_in BIGINT
)
consultar_direcciones:BEGIN

/* EXISTE CLIENTE */
IF ((SELECT COUNT(*) FROM clientes WHERE numero_dpi = cliente_dpi_in) = 0) THEN
    SELECT CONCAT('EL CLIENTE CON DPI \'', cliente_dpi_in, '\' NO EXISTE.') AS ERROR;
    LEAVE consultar_direcciones;
END IF;

SELECT direccion AS direccion_completa, municipio, zona
FROM direcciones
WHERE cliente_dpi = cliente_dpi_in;
END $$


/******************* 6. Mostrar órdenes según estado ******************/
DELIMITER $$
DROP PROCEDURE IF EXISTS MostrarOrdenes $$ CREATE PROCEDURE MostrarOrdenes (
    IN estado_in INT
)
mostrar_ordenes:BEGIN

DECLARE estado_orden VARCHAR(25);

/* VALIDAR ESTADO */
IF (estado_in = 1) THEN
    SET estado_orden = 'iniciada';
ELSEIF (estado_in = 2) THEN
    SET estado_orden = 'agregando';
ELSEIF (estado_in = 3) THEN
    SET estado_orden = 'en camino';
ELSEIF (estado_in = 4) THEN
    SET estado_orden = 'entregada';
ELSEIF (estado_in = -1) THEN
    SET estado_orden = 'sin cobertura';
ELSE
    SELECT 'EL ESTADO DEBE SER 1, 2, 3, 4 o -1.' AS ERROR;
    LEAVE mostrar_ordenes;
END IF;

SELECT
    ordenes.id,
    ordenes.estado,
    ordenes.fecha_inicio AS fecha,
    clientes.numero_dpi AS dpi_cliente,
    direcciones.direccion AS direccion_cliente,
    COALESCE(restaurantes.id, '') AS restaurante,
    CASE LOWER(ordenes.canal)
        WHEN 'l' THEN 'Llamada'
        WHEN 'a' THEN 'Aplicación'
    END AS canal
FROM ordenes
INNER JOIN clientes
ON ordenes.cliente_dpi = clientes.numero_dpi
INNER JOIN direcciones
ON ordenes.direccion_id = direcciones.id
LEFT JOIN restaurantes
ON ordenes.restaurante_id = restaurantes.id
WHERE LOWER(ordenes.estado) = estado_orden;
END $$


/************ 7. Retornar encabezados de factura según el día ***********/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarFacturas $$ CREATE PROCEDURE ConsultarFacturas (
    IN dia_in INT,
    IN mes_in INT,
    IN anio_in INT
)
consultar_facturas:BEGIN

DECLARE fecha_in DATE;
SET sql_mode = '';
SET fecha_in = STR_TO_DATE(CONCAT(anio_in, '-', mes_in, '-', dia_in), '%Y-%m-%d');

/* VALIDAR FECHA */
IF (fecha_in IS NULL) THEN
    SELECT CONCAT('LA FECHA NO ES VÁLIDA.') AS ERROR;
    LEAVE consultar_facturas;
END IF;

SELECT
    numero_serie,
    monto_total,
    lugar,
    fecha,
    orden_id,
    COALESCE(nit_cliente, 'C/F') AS nit_cliente,
    CASE LOWER(forma_pago)
        WHEN 'e' THEN 'Efectivo'
        WHEN 't' THEN 'Tarjeta'
    END AS forma_pago
FROM facturas WHERE DATE(fecha) = fecha_in;
END $$


/******************** 8. Consultar tiempos de espera *******************/
DELIMITER $$
DROP PROCEDURE IF EXISTS ConsultarTiempos $$ CREATE PROCEDURE ConsultarTiempos (
    IN minutos_in INT
)
consultar_tiempos:BEGIN

/* VALIDAR MINUTOS */
IF (minutos_in <= 0) THEN
    SELECT 'LOS MINUTOS DEBEN SER UN ENTERO POSITIVO.' AS ERROR;
    LEAVE consultar_tiempos;
END IF;

SELECT
    ordenes.id,
    direcciones.direccion AS direccion_entrega,
    ordenes.fecha_inicio AS fecha,
    TIMESTAMPDIFF(MINUTE, ordenes.fecha_inicio, ordenes.fecha_entrega) AS tiempo_espera_minutos,
    COALESCE(CONCAT(empleados.nombres, ' ', empleados.apellidos), '') AS repartidor
FROM ordenes
INNER JOIN direcciones
ON ordenes.direccion_id = direcciones.id
INNER JOIN empleados
ON ordenes.empleado_id = empleados.id
WHERE ordenes.fecha_entrega IS NOT NULL
AND TIMESTAMPDIFF(MINUTE, ordenes.fecha_inicio, ordenes.fecha_entrega) >= minutos_in;
END $$
