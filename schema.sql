DROP DATABASE IF EXISTS delivery;
CREATE DATABASE delivery;
USE delivery;

CREATE TABLE restaurantes (
    id VARCHAR(50) PRIMARY KEY,
    direccion VARCHAR(100) NOT NULL,
    municipio VARCHAR(50) NOT NULL,
    zona INT NOT NULL,
    telefono INT NOT NULL,
    personal INT NOT NULL,
    tiene_parqueo BOOLEAN NOT NULL
);

CREATE TABLE puestos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    salario DOUBLE NOT NULL
);

CREATE TABLE clientes (
    numero_dpi BIGINT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono INT NOT NULL,
    nit INT
);

CREATE TABLE items (
    id VARCHAR(5) PRIMARY KEY,
    producto VARCHAR(50) NOT NULL,
    precio DOUBLE NOT NULL
);

CREATE TABLE empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    correo VARCHAR(50) NOT NULL,
    telefono INT NOT NULL,
    direccion VARCHAR(100) NOT NULL,
    numero_dpi BIGINT NOT NULL,
    fecha_inicio DATE NOT NULL,
    restaurante_id VARCHAR(50) NOT NULL REFERENCES restaurantes(id),
    puesto_id INT NOT NULL REFERENCES puestos(id)
);

CREATE TABLE direcciones (
    id INT PRIMARY KEY AUTO_INCREMENT,
    direccion VARCHAR(100) NOT NULL,
    municipio VARCHAR(50) NOT NULL,
    zona INT NOT NULL,
    cliente_dpi BIGINT NOT NULL REFERENCES clientes(numero_dpi)
);

CREATE TABLE ordenes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    canal CHAR(1) NOT NULL,
    fecha_inicio DATETIME NOT NULL,
    fecha_entrega DATETIME,
    estado VARCHAR(25) NOT NULL,
    cliente_dpi BIGINT NOT NULL REFERENCES clientes(numero_dpi),
    direccion_id INT NOT NULL REFERENCES direcciones(id),
    restaurante_id VARCHAR(50) REFERENCES restaurantes(id),
    empleado_id INT REFERENCES empleados(id)
);

CREATE TABLE facturas (
    numero_serie INT PRIMARY KEY,
    monto_total DOUBLE NOT NULL,
    lugar VARCHAR(100) NOT NULL,
    fecha DATETIME NOT NULL,
    nit_cliente INT,
    forma_pago CHAR(1) NOT NULL,
    orden_id INT NOT NULL REFERENCES ordenes(id)
);

CREATE TABLE detalle_ordenes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cantidad INT NOT NULL,
    observacion VARCHAR(100),
    orden_id INT NOT NULL REFERENCES ordenes(id),
    item_id VARCHAR(5) NOT NULL REFERENCES items(id)
);

CREATE TABLE historial (
    fecha DATETIME NOT NULL,
    tabla VARCHAR(100) NOT NULL,
    tipo VARCHAR(25) NOT NULL
);

INSERT INTO items (id, producto, precio)
VALUES
    ('C1', 'Cheeseburger', 41.00),
    ('C2', 'Chicken Sandwinch', 32.00),
    ('C3', 'BBQ Ribs', 54.00),
    ('C4', 'Pasta Alfredo', 47.00),
    ('C5', 'Pizza Espinator', 85.00),
    ('C6', 'Buffalo Wings', 36.00),
    ('E1', 'Papas fritas', 15.00),
    ('E2', 'Aros de cebolla', 17.00),
    ('E3', 'ColeCslaw', 12.00),
    ('B1', 'Coca-Cola', 12.00),
    ('B2', 'Fanta', 12.00),
    ('B3', 'Sprite', 12.00),
    ('B4', 'Té frío', 12.00),
    ('B5', 'Cerveza de barril', 18.00),
    ('P1', 'Copa de helado', 13.00),
    ('P2', 'Cheesecake', 15.00),
    ('P3', 'Cupcake de chocolate', 8.00),
    ('P4', 'Flan', 10.00);
