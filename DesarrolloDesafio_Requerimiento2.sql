-- Eliminar tablas si existen previamente
DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS sucursales;
DROP TABLE IF EXISTS clientes;

-- Crear tabla de clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    correo VARCHAR(50),
    ciudad VARCHAR(50)
);

-- Crear tabla de productos
CREATE TABLE productos (
    id_producto INT PRIMARY KEY,
    nombre_producto VARCHAR(50) NOT NULL,
    categoria VARCHAR(50),
    precio NUMERIC CHECK (precio > 0)
);

-- Crear tabla de sucursales
CREATE TABLE sucursales (
    id_sucursal INT PRIMARY KEY,
    nombre_sucursal VARCHAR(50)NOT NULL,
    ciudad VARCHAR(50)
);

-- Crear tabla de ventas
CREATE TABLE ventas (
    id_venta INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    id_sucursal INT NOT NULL,
    fecha DATE NOT NULL,
    cantidad INT CHECK (cantidad > 0),
    total NUMERIC CHECK (total >= 0),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_sucursal) REFERENCES sucursales(id_sucursal)
);

-- INSERTAR DATOS DE CLIENTES (8 registros)
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO clientes VALUES
(1, 'Camila Rojas', 'camila@mail.com', 'Valparaíso'),
(2, 'Luis Pérez', 'luis@mail.com', 'Santiago'),
(3, 'Daniela Soto', 'daniela@mail.com', 'Concepción'),
(4, 'Roberto García', 'roberto@mail.com', 'Valparaíso'),
(5, 'Ana Martínez', 'ana@mail.com', 'Santiago'),
(6, 'Jorge López', 'jorge@mail.com', 'Arica'),
(7, 'Sofía Hernández', 'sofia@mail.com', 'Santiago'),
(8, 'Marcela Torres', 'marcela@mail.com', 'Valparaíso');

-- ═══════════════════════════════════════════════════════════════════════════
-- INSERTAR DATOS DE PRODUCTOS (8 registros)
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO productos VALUES
(1, 'Notebook Lenovo', 'Tecnología', 550000),
(2, 'Mouse Inalámbrico', 'Accesorios', 15000),
(3, 'Teclado Mecánico', 'Accesorios', 45000),
(4, 'Monitor 27"', 'Tecnología', 250000),
(5, 'Webcam HD', 'Accesorios', 35000),
(6, 'Auriculares Bluetooth', 'Accesorios', 25000),
(7, 'Tablet Samsung', 'Tecnología', 180000),
(8, 'Soporte para Notebook', 'Accesorios', 12000);

-- ═══════════════════════════════════════════════════════════════════════════
-- INSERTAR DATOS DE SUCURSALES (6 registros)
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO sucursales VALUES
(1, 'Tienda Centro Santiago', 'Santiago'),
(2, 'Tienda Online', 'Internet'),
(3, 'Tienda Valpo', 'Valparaíso'),
(4, 'Tienda Concepción', 'Concepción'),
(5, 'Tienda Arica', 'Arica'),
(6, 'Tienda Providencia', 'Santiago');

-- ═══════════════════════════════════════════════════════════════════════════
-- INSERTAR DATOS DE VENTAS (16 registros)
-- ═══════════════════════════════════════════════════════════════════════════
INSERT INTO ventas VALUES
-- Junio - 
(1, 1, 1, 2, '2024-06-05', 1, 550000),
(2, 2, 2, 1, '2024-06-10', 2, 30000),
(3, 3, 3, 3, '2024-06-15', 1, 45000),
(4, 1, 4, 2, '2024-06-18', 1, 250000),
(5, 5, 5, 1, '2024-06-22', 3, 105000),
-- Julio - 
(6, 2, 6, 2, '2024-07-03', 1, 25000),
(7, 4, 1, 3, '2024-07-08', 1, 550000),
(8, 3, 7, 4, '2024-07-12', 2, 360000),
(9, 6, 2, 5, '2024-07-15', 4, 60000),
(10, 8, 3, 3, '2024-07-20', 2, 90000),
-- Agosto - 
(11, 1, 8, 2, '2024-08-05', 5, 60000),
(12, 7, 4, 6, '2024-08-10', 1, 250000),
(13, 2, 5, 1, '2024-08-15', 2, 70000),
(14, 4, 6, 3, '2024-08-20', 3, 75000),
(15, 5, 1, 4, '2024-08-25', 1, 550000),
(16, 3, 2, 2, '2024-08-28', 6, 90000);

-- ═══════════════════════════════════════════════════════════════════════════
-- 2. Escritura de consultas básicas en SQL
-- ═══════════════════════════════════════════════════════════════════════════

-- CONSULTA 1: Listar nombres y correos de clientes de "Valparaíso"

SELECT nombre, correo
FROM clientes
WHERE ciudad = 'Valparaíso'
ORDER BY nombre;

-- CONSULTA 2: Mostrar ventas en junio con nombre del cliente y total

SELECT 
    c.nombre AS nombre_cliente,
    v.fecha,
    v.cantidad,
    v.total,
    p.nombre_producto
FROM ventas v
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON v.id_producto = p.id_producto
where v.fecha >= '2024-06-01' AND v.fecha < '2024-07-01'
ORDER BY v.fecha;

-- CONSULTA 3: Total de productos vendidos por tienda

SELECT 
    s.nombre_sucursal,
    s.ciudad,
    SUM(v.cantidad) AS total_productos,
    COUNT(v.id_venta) AS cantidad_ventas,
    ROUND(AVG(v.total), 2) AS promedio_venta
FROM sucursales s
LEFT JOIN ventas v ON s.id_sucursal = v.id_sucursal
GROUP BY s.id_sucursal, s.nombre_sucursal, s.ciudad
ORDER BY total_productos DESC;