-- ==========================================
--                FARMACIA
-- ==========================================

CREATE DATABASE IF NOT EXISTS farmacia_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE farmacia_db;

-- ==========================================
-- 1. TABLA CATEGORIAS
-- ==========================================

CREATE TABLE IF NOT EXISTS categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255)
) ENGINE=InnoDB;

-- ==========================================
-- 2. TABLA PRODUCTOS
-- ==========================================

CREATE TABLE IF NOT EXISTS productos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    categoria_id INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    requiere_receta BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT fk_productos_categorias
        FOREIGN KEY (categoria_id)
        REFERENCES categorias(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================
-- 3. TABLA PROVEEDORES
-- ==========================================

CREATE TABLE IF NOT EXISTS proveedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(150) NOT NULL,
    ruc VARCHAR(30),
    contacto VARCHAR(100),
    telefono VARCHAR(20),

    CONSTRAINT uq_proveedores_ruc UNIQUE (ruc)
) ENGINE=InnoDB;

-- ==========================================
-- 4. TABLA LOTES
-- ==========================================

CREATE TABLE IF NOT EXISTS lotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto_id INT NOT NULL,
    proveedor_id INT NOT NULL,
    numero_lote VARCHAR(50) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    cantidad INT NOT NULL DEFAULT 0,

    CONSTRAINT uq_lote_producto_numero
        UNIQUE (producto_id, numero_lote),

    CONSTRAINT fk_lotes_productos
        FOREIGN KEY (producto_id)
        REFERENCES productos(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_lotes_proveedores
        FOREIGN KEY (proveedor_id)
        REFERENCES proveedores(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================
-- 5. TABLA USUARIOS
-- ==========================================

CREATE TABLE IF NOT EXISTS usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL,

    CONSTRAINT uq_usuarios_username UNIQUE (username)
) ENGINE=InnoDB;

-- ==========================================
-- 6. TABLA VENTAS
-- ==========================================

CREATE TABLE IF NOT EXISTS ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    usuario_id INT NOT NULL,

    CONSTRAINT fk_ventas_usuarios
        FOREIGN KEY (usuario_id)
        REFERENCES usuarios(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================
-- 7. TABLA DETALLE_VENTA
-- ==========================================

CREATE TABLE IF NOT EXISTS detalle_venta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venta_id INT NOT NULL,
    lote_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_detalle_venta_ventas
        FOREIGN KEY (venta_id)
        REFERENCES ventas(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT fk_detalle_venta_lotes
        FOREIGN KEY (lote_id)
        REFERENCES lotes(id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ==========================================
-- DATOS DE PRUEBA
-- ==========================================

-- 1. CATEGORIAS

INSERT INTO categorias (nombre, descripcion) VALUES
('Analgésicos', 'Medicamentos para aliviar el dolor'),
('Antigripales', 'Productos para síntomas de gripe'),
('Vitaminas', 'Vitaminas y suplementos'),
('Higiene', 'Productos de higiene personal');

-- 2. PRODUCTOS

INSERT INTO productos
(nombre, categoria_id, precio, stock, requiere_receta) VALUES
('Paracetamol 500 mg', 1, 35.00, 100, FALSE),
('Ibuprofeno 400 mg', 1, 55.00, 80, FALSE),
('Antigripal tabletas', 2, 85.00, 50, FALSE),
('Vitamina C', 3, 65.00, 60, FALSE),
('Amoxicilina 500 mg', 1, 120.00, 30, TRUE),
('Alcohol antiséptico', 4, 40.00, 45, FALSE);

-- 3. PROVEEDORES

INSERT INTO proveedores
(razon_social, ruc, contacto, telefono) VALUES
('Distribuidora Farmacéutica Central', '08011999123456', 'Carlos López', '98765432'),
('Medicamentos del Valle', '08011999876543', 'María Flores', '97654321'),
('Suministros Médicos Honduras', '08011999765432', 'José Martínez', '96543210');

-- 4. LOTES

INSERT INTO lotes
(producto_id, proveedor_id, numero_lote, fecha_vencimiento, cantidad) VALUES
(1, 1, 'PAR-2026-001', '2027-12-31', 100),
(2, 1, 'IBU-2026-001', '2027-08-30', 80),
(3, 2, 'ANT-2026-001', '2027-06-30', 50),
(4, 3, 'VIT-2026-001', '2028-01-31', 60),
(5, 2, 'AMO-2026-001', '2027-10-31', 30),
(6, 3, 'ALC-2026-001', '2028-03-31', 45);

-- 5. USUARIOS
-- Las contraseñas siguientes son datos ficticios de prueba.
-- No son hashes válidos para autenticación real.

INSERT INTO usuarios (username, password_hash, rol) VALUES
('admin', 'HASH_DE_PRUEBA_ADMIN', 'Administrador'),
('vendedor1', 'HASH_DE_PRUEBA_VENDEDOR', 'Vendedor'),
('vendedor2', 'HASH_DE_PRUEBA_VENDEDOR2', 'Vendedor');

-- 6. VENTAS

INSERT INTO ventas (fecha, total, usuario_id) VALUES
('2026-10-20 09:30:00', 105.00, 2),
('2026-10-21 11:15:00', 195.00, 3),
('2026-10-22 14:00:00', 130.00, 2);

-- 7. DETALLES DE VENTA

INSERT INTO detalle_venta
(venta_id, lote_id, cantidad, precio) VALUES
(1, 1, 2, 35.00),
(1, 6, 1, 35.00),
(2, 2, 1, 55.00),
(2, 3, 1, 85.00),
(2, 4, 1, 55.00),
(3, 4, 2, 65.00);

-- ==========================================
-- CONSULTAS PARA VERIFICAR LOS DATOS
-- ==========================================

SHOW TABLES;

SELECT * FROM categorias;
SELECT * FROM productos;
SELECT * FROM proveedores;
SELECT * FROM lotes;
SELECT * FROM usuarios;
SELECT * FROM ventas;
SELECT * FROM detalle_venta;

-- Consultar ventas con el usuario que las registró

SELECT
    v.id AS venta_id,
    v.fecha,
    u.username AS usuario,
    v.total
FROM ventas v
INNER JOIN usuarios u ON v.usuario_id = u.id;

-- Consultar detalles de ventas con productos y lotes

SELECT
    dv.id AS detalle_id,
    dv.venta_id,
    p.nombre AS producto,
    l.numero_lote,
    dv.cantidad,
    dv.precio,
    dv.cantidad * dv.precio AS subtotal
FROM detalle_venta dv
INNER JOIN lotes l ON dv.lote_id = l.id
INNER JOIN productos p ON l.producto_id = p.id;
