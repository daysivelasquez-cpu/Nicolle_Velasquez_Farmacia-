-- ==========================================
--  FARMACIA
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
-- VERIFICAR LAS TABLAS CREADAS
-- ==========================================

SHOW TABLES;
