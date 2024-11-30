CREATE TABLE gerente 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    correo VARCHAR(150) NOT NULL,  
    telefono VARCHAR(50) NOT NULL  
);

CREATE TABLE cliente 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    correo VARCHAR(150) NOT NULL,  
    telefono VARCHAR(50) NOT NULL  
);

CREATE TABLE categoria 
( 
    nombre VARCHAR(255) PRIMARY KEY  
);

CREATE TABLE provedor 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    telefono VARCHAR(50) NOT NULL,  
    correo VARCHAR(150) NOT NULL  
);

CREATE TABLE promocion 
( 
    id INT PRIMARY KEY,  
    porcentaje_descuento INT,  
    fecha_inicio DATE NOT NULL DEFAULT NOW(),  
    fecha_fin DATE NOT NULL DEFAULT NOW()  
);

CREATE TABLE empleado 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    correo VARCHAR(150) NOT NULL,  
    telefono VARCHAR(50) NOT NULL,  
    id_gerente INT NOT NULL,  
    FOREIGN KEY (id_gerente) REFERENCES gerente(rut)  
);

CREATE TABLE producto 
( 
    id INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    precio FLOAT NOT NULL,  
    fecha_criacion DATE NOT NULL DEFAULT NOW(),  
    fecha_atualizacion DATE NOT NULL DEFAULT NOW(),  
    categoria VARCHAR(255) NOT NULL,
    cantidad_inventario INT NOT NULL DEFAULT 0,  
    id_provedor INT NOT NULL,  
    id_promocion INT,  
    FOREIGN KEY (categoria) REFERENCES categoria(nombre),  
    FOREIGN KEY (id_provedor) REFERENCES provedor(rut),  
    FOREIGN KEY (id_promocion) REFERENCES promocion(id)  
);

CREATE TABLE detalle_venda 
( 
    id INT PRIMARY KEY,  
    cantidad INT NOT NULL,  
    precio_unitario FLOAT NOT NULL, 
    id_producto INT NOT NULL,  
    FOREIGN KEY (id_producto) REFERENCES producto(id)  
);

CREATE TABLE venda 
( 
    id INT PRIMARY KEY,  
    fecha DATE NOT NULL DEFAULT NOW(),  
    valor_total FLOAT NOT NULL,  
    metodo_pago VARCHAR(255) NOT NULL,  
    id_cliente INT NOT NULL,  
    id_empleado INT NOT NULL,  
    id_detalle_venda INT NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES cliente(rut),  
    FOREIGN KEY (id_empleado) REFERENCES empleado(rut),  
    FOREIGN KEY (id_detalle_venda) REFERENCES detalle_venda(id)  
);

CREATE TABLE devolucion 
( 
    id INT PRIMARY KEY,  
    fecha DATE NOT NULL DEFAULT NOW(),  
    motivo VARCHAR(255) NOT NULL,  
    id_cliente INT NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES cliente(rut)  
);


-- Funciones

-- Produtos mais vendidos em um intervalo de datas
CREATE OR REPLACE FUNCTION productos_mas_vendidos(fecha_inicio DATE, fecha_fin DATE)
RETURNS TABLE(nombre_producto VARCHAR, total_vendidos INT) 
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY 
    SELECT p.nombre, SUM(dv.cantidad) AS total_vendidos
    FROM producto p
    JOIN detalle_venda dv ON p.id = dv.id
    JOIN venda v ON dv.id = v.id_detalle_venda
    WHERE v.fecha BETWEEN fecha_inicio AND fecha_fin
    GROUP BY p.id
    ORDER BY total_vendidos DESC;
END;
$$;


-- Receita por cliente
CREATE OR REPLACE FUNCTION ingresos_cliente(id_cliente INT)
RETURNS FLOAT
LANGUAGE plpgsql
AS $$
DECLARE
    total_ingresos FLOAT;
BEGIN
    SELECT SUM(valor_total) INTO total_ingresos
    FROM venda 
    WHERE id_cliente = id_cliente;
    RETURN total_ingresos;
END;
$$;

-- Registrar automaticamente uma venda
CREATE OR REPLACE FUNCTION registrar_venta(cliente INT, empleado INT, producto INT, cantidad INT)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    -- Inserir o detalhe da venda
    INSERT INTO detalle_venda (cantidad, precio_unitario) 
    VALUES (cantidad, (SELECT precio FROM producto WHERE id = producto));

    -- Criar a venda
    INSERT INTO venda (fecha, valor_total, id_cliente, id_empleado, id_detalle_venda) 
    VALUES (NOW(), cantidad * (SELECT precio FROM producto WHERE id = producto), cliente, empleado, CURRVAL(pg_get_serial_sequence('detalle_venda', 'id')));

    -- Atualizar o estoque do produto
    UPDATE producto 
    SET cantidad_inventario = cantidad_inventario - cantidad 
    WHERE id = producto;
END;
$$;


-- Triggers

-- Trigger para actualizar el stock de un producto luego de una venta
CREATE OR REPLACE FUNCTION actualizar_stock_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE producto 
    SET cantidad_inventario = cantidad_inventario - NEW.cantidad 
    WHERE id = NEW.id_producto;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER actualizar_stock
AFTER INSERT ON detalle_venda
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock_func();

-- Función para verificar el stock antes de registrar la venta
CREATE OR REPLACE FUNCTION verificar_stock_func()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF (SELECT cantidad_inventario FROM producto WHERE id = NEW.id_producto) < NEW.cantidad THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto: %', NEW.id_producto;
    END IF;
    RETURN NEW;
END;
$$;

-- Trigger para verificar el stock antes de crear una venta y los detalles de la venta
CREATE OR REPLACE TRIGGER verificar_stock
BEFORE INSERT ON detalle_venda
FOR EACH ROW
EXECUTE FUNCTION verificar_stock_func();


-- Inserción de datos

-- Inserción de 10 clientes
INSERT INTO cliente (rut, nombre, correo, telefono) VALUES
(100000001, 'Ana Rodríguez', 'ana.rodriguez@gmail.com', '987654321'),
(100000002, 'Luis González', 'luis.gonzalez@gmail.com', '912345678'),
(100000003, 'Carlos Martínez', 'carlos.martinez@gmail.com', '987123456'),
(100000004, 'Marta López', 'marta.lopez@gmail.com', '965432789'),
(100000005, 'Pedro Fernández', 'pedro.fernandez@gmail.com', '956789123'),
(100000006, 'José García', 'jose.garcia@gmail.com', '987456321'),
(100000007, 'Laura Sánchez', 'laura.sanchez@gmail.com', '922334455'),
(100000008, 'Miguel Pérez', 'miguel.perez@gmail.com', '933223344'),
(100000009, 'Sofía Ruiz', 'sofia.ruiz@gmail.com', '944556677'),
(100000010, 'David Rodríguez', 'david.rodriguez@gmail.com', '988776655');

-- Inserción de 10 gerentes
INSERT INTO gerente (rut, nombre, correo, telefono) VALUES
(111111111, 'Ricardo Gómez', 'ricardo.gomez@gmail.com', '123456789'),
(111111112, 'Ana Martínez', 'ana.martinez@gmail.com', '234567890'),
(111111113, 'Carlos Fernández', 'carlos.fernandez@gmail.com', '345678901'),
(111111114, 'Laura Pérez', 'laura.perez@gmail.com', '456789012'),
(111111115, 'Pedro González', 'pedro.gonzalez@gmail.com', '567890123'),
(111111116, 'María Ruiz', 'maria.ruiz@gmail.com', '678901234'),
(111111117, 'José Rodríguez', 'jose.rodriguez@gmail.com', '789012345'),
(111111118, 'Sofía Herrera', 'sofia.herrera@gmail.com', '890123456'),
(111111119, 'Fernando López', 'fernando.lopez@gmail.com', '901234567'),
(111111120, 'Isabel Sánchez', 'isabel.sanchez@gmail.com', '102345678');

-- Inserción de 10 empleados
INSERT INTO empleado (rut, nombre, correo, telefono, id_gerente) VALUES
(111223344, 'Juan Pérez', 'juan.perez@gmail.com', '222222222', 111111111),
(111223345, 'María López', 'maria.lopez@gmail.com', '333333333', 111111111),
(111223346, 'Pedro González', 'pedro.gonzalez@gmail.com', '444444444', 111111113),
(111223347, 'Lucía Sánchez', 'lucia.sanchez@gmail.com', '555555555', 111111113),
(111223348, 'José Álvarez', 'jose.alvarez@gmail.com',  '666666666', 111111116),
(111223349, 'Carlos Martínez', 'carlos.martinez@gmail.com', '777777777', 111111116),
(111223350, 'Ana Rodríguez', 'ana.rodriguez@gmail.com', '888888888', 111111120),
(111223351, 'Fernando Ruiz', 'fernando.ruiz@gmail.com', '999999999', 111111120),
(111223352, 'Elena Fernández', 'elena.fernandez@gmail.com', '101010101', 111111111),
(111223353, 'Marta García', 'marta.garcia@gmail.com', '111111112', 111111111);

-- Inserción de 10 categorias
INSERT INTO categoria (nombre) VALUES
('Electrónica'),
('Ropa'),
('Electrodomésticos'),
('Computadoras'),
('Telefonía'),
('Videojuegos'),
('Accesorios'),
('Muebles'),
('Deportes'),
('Hogar');

-- Inserción de 10 provedores
INSERT INTO provedor (rut, nombre, telefono, correo) VALUES
(123123123, 'Proveedor 1', '987654321', 'proveedor1@gmail.com'),
(123123124, 'Proveedor 2', '321654987', 'proveedor2@gmail.com'),
(123123125, 'Proveedor 3', '123789654', 'proveedor3@gmail.com'),
(123123126, 'Proveedor 4', '456123987', 'proveedor4@gmail.com'),
(123123127, 'Proveedor 5', '789456123', 'proveedor5@gmail.com'),
(123123128, 'Proveedor 6', '321789654', 'proveedor6@gmail.com'),
(123123129, 'Proveedor 7', '654987321', 'proveedor7@gmail.com'),
(123123130, 'Proveedor 8', '987321456', 'proveedor8@gmail.com'),
(123123131, 'Proveedor 9', '543216789', 'proveedor9@gmail.com'),
(123123132, 'Proveedor 10', '654321123', 'proveedor10@gmail.com');

-- Inserción de 10 promociones
INSERT INTO promocion (id, porcentaje_descuento, fecha_inicio, fecha_fin) VALUES
(1, 10, '2024-01-01', '2024-01-31'),
(2, 15, '2024-02-01', '2024-02-28'),
(3, 20, '2024-03-01', '2024-03-31'),
(4, 25, '2024-04-01', '2024-04-30'),
(5, 30, '2024-05-01', '2024-05-31'),
(6, 35, '2024-06-01', '2024-06-30'),
(7, 40, '2024-07-01', '2024-07-31'),
(8, 5, '2024-08-01', '2024-08-31'),
(9, 50, '2024-09-01', '2024-09-30'),
(10, 10, '2024-10-01', '2024-10-31');

-- Inserción de 10 productos
INSERT INTO producto (id, nombre, precio, categoria, cantidad_inventario, id_provedor, id_promocion) VALUES
(1, 'Laptop HP', 900000, 'Electrónica', 15, 123123123, 1),
(2, 'Smartphone Xiaomi', 350000, 'Electrónica', 10, 123123124, 2),
(3, 'Camisa Adidas', 25000, 'Ropa', 20, 123123125, NULL),
(4, 'Pantalón Levi’s', 45000, 'Ropa', 5, 123123126, NULL),
(5, 'Tablet Huawei', 400000, 'Electrónica', 22, 123123127, 1),
(6, 'Camiseta Puma', 20000, 'Ropa', 23, 123123128, 2),
(7, 'Smartwatch Samsung', 150000, 'Electrónica', 14, 123123129, NULL),
(8, 'Zapatos Nike', 70000, 'Ropa', 9, 123123130, NULL),
(9, 'Auriculares Sony', 120000, 'Electrónica', 5, 123123131, 2),
(10, 'Cámara Canon', 1200000, 'Electrónica', 4, 123123132, NULL);

-- Inserción de 10 detalles de venta
INSERT INTO detalle_venda (id, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 900000),
(2, 2, 1, 350000),
(3, 3, 2, 25000),
(4, 4, 1, 45000),
(5, 5, 1, 400000),
(6, 6, 1, 20000),
(7, 7, 1, 150000),
(8, 8, 1, 70000),
(9, 9, 1, 120000),
(10, 10, 1, 1200000);


-- Inserción de 10 vendas
INSERT INTO venda (id, fecha, valor_total, metodo_pago, id_cliente, id_empleado, id_detalle_venda) VALUES
(1, '2024-01-10', 100000, 'Crédito', 100000001, 111223344, 1),
(2, '2024-01-11', 350000, 'Débito', 100000002, 111223345, 2),
(3, '2024-01-12', 25000, 'Crédito', 100000003, 111223346, 3),
(4, '2024-01-13', 45000, 'Débito', 100000004, 111223347, 4),
(5, '2024-01-14', 400000, 'Crédito', 100000005, 111223348, 5),
(6, '2024-01-15', 20000, 'Débito', 100000006, 111223349, 6),
(7, '2024-01-16', 150000, 'Crédito', 100000007, 111223350, 7),
(8, '2024-01-17', 70000, 'Débito', 100000008, 111223351, 8),
(9, '2024-01-18', 120000, 'Crédito', 100000009, 111223352, 9),
(10, '2024-01-19', 1200000, 'Débito', 100000010, 111223353, 10);


-- Inserción de 10 devoluciones
INSERT INTO devolucion (id, fecha, motivo, id_cliente) VALUES
(1, '2024-02-01', 'Produto danificado', 100000001),
(2, '2024-02-02', 'Produto não funciona', 100000002),
(3, '2024-02-03', 'Cor errada', 100000003),
(4, '2024-02-04', 'Produto não corresponde à descrição', 100000004),
(5, '2024-02-05', 'Defeito de fábrica', 100000005),
(6, '2024-02-06', 'Problema com a bateria', 100000006),
(7, '2024-02-07', 'Tamanho errado', 100000007),
(8, '2024-02-08', 'Produto recebido com defeito', 100000008),
(9, '2024-02-09', 'Produto com defeito de cor', 100000009),
(10, '2024-02-10', 'Defeito de fabricação', 100000010);


-- Consultas

-- a. Liste todos los clientes y sus compras, incluyendo aquellos sin compras
SELECT c.rut, c.nombre, v.id AS id_venda, v.valor_total
FROM cliente c
LEFT JOIN venda v ON c.rut = v.id_cliente;

-- b. Liste los productos con stock actual, y si están en promoción, muestre el precio con descuento
SELECT p.nombre, p.precio, 
       CASE WHEN pr.id IS NOT NULL THEN p.precio - (p.precio * pr.porcentaje_descuento / 100) ELSE p.precio END AS precio_con_descuento
FROM producto p
LEFT JOIN promocion pr ON p.id_promocion = pr.id;

-- c. Identifique a los empleados que no han gestionado ninguna venta
SELECT e.nombre
FROM empleado e
LEFT JOIN venda v ON e.rut = v.id_empleado
WHERE v.id IS NULL;

-- d. Liste los productos devueltos, indicando la razón
SELECT d.motivo, p.nombre AS producto
FROM devolucion d
JOIN venda v ON d.id_cliente = v.id_cliente
JOIN detalle_venda dv ON v.id_detalle_venda = dv.id
JOIN producto p ON dv.id_producto = p.id;

-- e. Producto más y menos vendido
SELECT p.nombre, SUM(dv.cantidad) AS total_vendido
FROM producto p
JOIN detalle_venda dv ON p.id = dv.id
GROUP BY p.id
ORDER BY total_vendido DESC;

-- f. Ingresos totales por categoría
SELECT c.nombre AS categoria, SUM(v.valor_total) AS receita_total
FROM categoria c
JOIN producto p ON c.nombre = p.categoria
JOIN detalle_venda dv ON p.id = dv.id_producto
JOIN venda v ON v.id_detalle_venda = dv.id
GROUP BY c.nombre;

-- g. Proveedor que suministró más productos
SELECT pv.nombre, COUNT(p.id) AS produtos_fornecidos
FROM provedor pv
JOIN producto p ON pv.rut = p.id_provedor
GROUP BY pv.rut
ORDER BY produtos_fornecidos DESC;

-- h. Liste los gerentes y empleados bajo su supervisión
SELECT g.nombre AS gerente, e.nombre AS empleado
FROM gerente g
LEFT JOIN empleado e ON g.rut = e.id_gerente;

-- Probando Triggers

-- Actualizar el stock de un producto después de una venta

-- Consultar el stock de la Laptop HP antes de la venta
SELECT id, nombre, cantidad_inventario 
FROM producto 
WHERE id = 1;

-- Registrar una venta
INSERT INTO detalle_venda (id, id_producto, cantidad, precio_unitario) 
VALUES (11, 1, 5, 900000); -- 5 unidades de la Laptop HP

-- Consultar el stock de la Laptop HP después de la venta
SELECT id, nombre, cantidad_inventario 
FROM producto 
WHERE id = 1;

-- Verificar el stock antes de registrar la venta
INSERT INTO detalle_venda (id, id_producto, cantidad, precio_unitario) 
VALUES (12, 1, 100, 900000); -- Stock insuficiente