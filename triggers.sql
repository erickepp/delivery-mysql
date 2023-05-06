/******************** Triggers restaurantes ********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_restaurantes_insert $$ CREATE TRIGGER tr_restaurantes_insert
AFTER INSERT ON restaurantes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'restaurantes', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_restaurantes_update $$CREATE TRIGGER tr_restaurantes_update
AFTER UPDATE ON restaurantes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'restaurantes', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_restaurantes_delete $$CREATE TRIGGER tr_restaurantes_delete
AFTER DELETE ON restaurantes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'restaurantes', 'DELETE');
END $$


/********************** Triggers puestos **********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_puestos_insert $$CREATE TRIGGER tr_puestos_insert
AFTER INSERT ON puestos
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'puestos', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_puestos_update $$CREATE TRIGGER tr_puestos_update
AFTER UPDATE ON puestos
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'puestos', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_puestos_delete $$CREATE TRIGGER tr_puestos_delete
AFTER DELETE ON puestos
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'puestos', 'DELETE');
END $$


/********************** Triggers clientes **********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_clientes_insert $$CREATE TRIGGER tr_clientes_insert
AFTER INSERT ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'clientes', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_clientes_update $$CREATE TRIGGER tr_clientes_update
AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'clientes', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_clientes_delete $$CREATE TRIGGER tr_clientes_delete
AFTER DELETE ON clientes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'clientes', 'DELETE');
END $$


/************************ Triggers items ************************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_items_insert $$CREATE TRIGGER tr_items_insert
AFTER INSERT ON items
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'items', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_items_update $$CREATE TRIGGER tr_items_update
AFTER UPDATE ON items
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'items', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_items_delete $$CREATE TRIGGER tr_items_delete
AFTER DELETE ON items
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'items', 'DELETE');
END $$


/********************** Triggers empleados **********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_empleados_insert $$CREATE TRIGGER tr_empleados_insert
AFTER INSERT ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'empleados', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_empleados_update $$CREATE TRIGGER tr_empleados_update
AFTER UPDATE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'empleados', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_empleados_delete $$CREATE TRIGGER tr_empleados_delete
AFTER DELETE ON empleados
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'empleados', 'DELETE');
END $$


/********************* Triggers direcciones *********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_direcciones_insert $$CREATE TRIGGER tr_direcciones_insert
AFTER INSERT ON direcciones
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'direcciones', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_direcciones_update $$CREATE TRIGGER tr_direcciones_update
AFTER UPDATE ON direcciones
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'direcciones', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_direcciones_delete $$CREATE TRIGGER tr_direcciones_delete
AFTER DELETE ON direcciones
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'direcciones', 'DELETE');
END $$


/*********************** Triggers ordenes ***********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_ordenes_insert $$CREATE TRIGGER tr_ordenes_insert
AFTER INSERT ON ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'ordenes', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_ordenes_update $$CREATE TRIGGER tr_ordenes_update
AFTER UPDATE ON ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'ordenes', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_ordenes_delete $$CREATE TRIGGER tr_ordenes_delete
AFTER DELETE ON ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'ordenes', 'DELETE');
END $$


/*********************** Triggers facturas ***********************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_facturas_insert $$CREATE TRIGGER tr_facturas_insert
AFTER INSERT ON facturas
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'facturas', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_facturas_update $$CREATE TRIGGER tr_facturas_update
AFTER UPDATE ON facturas
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'facturas', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_facturas_delete $$CREATE TRIGGER tr_facturas_delete
AFTER DELETE ON facturas
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'facturas', 'DELETE');
END $$


/******************* Triggers detalle_ordenes *******************/
DELIMITER $$
DROP TRIGGER IF EXISTS tr_detalle_ordenes_insert $$CREATE TRIGGER tr_detalle_ordenes_insert
AFTER INSERT ON detalle_ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'detalle_ordenes', 'INSERT');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_detalle_ordenes_update $$CREATE TRIGGER tr_detalle_ordenes_update
AFTER UPDATE ON detalle_ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'detalle_ordenes', 'UPDATE');
END $$

DELIMITER $$
DROP TRIGGER IF EXISTS tr_detalle_ordenes_delete $$CREATE TRIGGER tr_detalle_ordenes_delete
AFTER DELETE ON detalle_ordenes
FOR EACH ROW
BEGIN
    INSERT INTO historial VALUES (NOW(), 'detalle_ordenes', 'DELETE');
END $$
