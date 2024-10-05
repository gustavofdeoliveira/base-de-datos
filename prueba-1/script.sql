CREATE TABLE IF NOT EXISTS cliente 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    fecha_nascimento DATE NOT NULL,  
    direccion VARCHAR(255) NOT NULL,  
    telefono VARCHAR(50) NOT NULL  
);

CREATE TABLE IF NOT EXISTS empleado 
( 
    rut INT PRIMARY KEY,  
    posicion VARCHAR(50) NOT NULL,  
    email VARCHAR(150) NOT NULL,  
    nombre VARCHAR(255) NOT NULL,  
    telefono VARCHAR(50) NOT NULL  
);

CREATE TABLE IF NOT EXISTS empresa_transporte 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL  
);

CREATE TABLE IF NOT EXISTS material 
( 
    id SERIAL PRIMARY KEY,  
    cantidad INT NOT NULL,  
    nombre VARCHAR(255) NOT NULL  
);

CREATE TABLE IF NOT EXISTS presupuesto 
( 
    id SERIAL PRIMARY KEY,  
    descripcion_producto VARCHAR(500) NOT NULL,  
    valoracion FLOAT NOT NULL,  
    fecha DATE NOT NULL,  
    status VARCHAR(50) NOT NULL DEFAULT 'Analizando',  
    id_cliente INT NOT NULL,  
    id_empleados INT NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES cliente(rut),
    FOREIGN KEY (id_empleados) REFERENCES empleado(rut)
);

CREATE TABLE IF NOT EXISTS producto 
( 
    id SERIAL PRIMARY KEY,  
    descripcion VARCHAR(500) NOT NULL,  
    estado_pago VARCHAR(50) NOT NULL DEFAULT 'No pagado',  
    id_presupuesto INT NOT NULL,   
    FOREIGN KEY (id_presupuesto) REFERENCES presupuesto(id)
);

CREATE TABLE IF NOT EXISTS orden 
( 
    id SERIAL PRIMARY KEY,  
    fecha_aceptacion DATE NOT NULL,  
    status VARCHAR(50) NOT NULL,  
    fecha_finalizacion DATE,
    id_producto INT,  -- Adicionado
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);

CREATE TABLE IF NOT EXISTS factura 
( 
    id SERIAL PRIMARY KEY,  
    metodo_pago VARCHAR(50),  
    valor FLOAT NOT NULL,  
    fecha DATE,  
    id_orden INT,  
    FOREIGN KEY (id_orden) REFERENCES orden(id)
);

CREATE TABLE IF NOT EXISTS presupuesto_material 
( 
    id SERIAL PRIMARY KEY,  
    cantidad_necesaria INT NOT NULL,  
    id_material INT NOT NULL,  
    id_presupuesto INT NOT NULL,  
    FOREIGN KEY (id_material) REFERENCES material(id),
    FOREIGN KEY (id_presupuesto) REFERENCES presupuesto(id)
);

CREATE TABLE IF NOT EXISTS empleado_orden 
( 
    id SERIAL PRIMARY KEY,  
    rut_empleado INT NOT NULL,  
    order_id INT NOT NULL,  
    FOREIGN KEY (rut_empleado) REFERENCES empleado(rut),
    FOREIGN KEY (order_id) REFERENCES orden(id)
);

CREATE TABLE IF NOT EXISTS producto_empresa_transporte 
( 
    id SERIAL PRIMARY KEY,  
    rut_empresa INT NOT NULL,  
    id_producto INT NOT NULL,  
    FOREIGN KEY (rut_empresa) REFERENCES empresa_transporte(rut),
    FOREIGN KEY (id_producto) REFERENCES producto(id)
);

-- 4. A)
-- Cliente A
INSERT INTO cliente (rut, nombre, fecha_nascimento, direccion, telefono) 
VALUES (1, 'Cliente A', '1985-04-12', 'Rua Exemplo 123, Cidade A', '555-1234');

-- Cliente B
INSERT INTO cliente (rut, nombre, fecha_nascimento, direccion, telefono) 
VALUES (2, 'Cliente B', '1990-08-25', 'Avenida Teste 456, Cidade B', '555-5678');

-- Cliente C
INSERT INTO cliente (rut, nombre, fecha_nascimento, direccion, telefono) 
VALUES (3, 'Cliente C', '2000-11-03', 'Travessa Demo 789, Cidade C', '555-9101');

-- 4. B)
-- Empregado A
INSERT INTO empleado (rut, posicion, email, nombre, telefono) 
VALUES (101, 'Gerente', 'empregadoA@email.com', 'Empregado A', '555-1111');

-- Empregado B
INSERT INTO empleado (rut, posicion, email, nombre, telefono) 
VALUES (102, 'Analista', 'empregadoB@email.com', 'Empregado B', '555-2222');

-- Empregado C
INSERT INTO empleado (rut, posicion, email, nombre, telefono) 
VALUES (103, 'Desenvolvedor', 'empregadoC@email.com', 'Empregado C', '555-3333');

-- 4. C)

-- Empresa de Transporte T1
INSERT INTO empresa_transporte (rut, nombre) 
VALUES (201, 'Transporte T1');

-- Empresa de Transporte T2
INSERT INTO empresa_transporte (rut, nombre) 
VALUES (202, 'Transporte T2');

-- Empresa de Transporte T3
INSERT INTO empresa_transporte (rut, nombre) 
VALUES (203, 'Transporte T3');

-- Material M1
INSERT INTO material (cantidad, nombre) 
VALUES (500, 'Papel A4');

-- Material M2
INSERT INTO material (cantidad, nombre) 
VALUES (200, 'Tinta para Impressora');

-- Material M3
INSERT INTO material (cantidad, nombre) 
VALUES (100, 'Cartolina');

-- Presupuesto Material
INSERT INTO presupuesto_material (cantidad_necesaria, id_material, id_presupuesto) 
VALUES (300, 1, 1);

-- Presupuesto Material
INSERT INTO presupuesto_material (cantidad_necesaria, id_material, id_presupuesto) 
VALUES (200, 2, 2);

-- Presupuesto Material
INSERT INTO presupuesto_material (cantidad_necesaria, id_material, id_presupuesto) 
VALUES (50, 3, 3);

-- 4. D)
-- Presupuesto C1
INSERT INTO presupuesto (descripcion_producto, valoracion, fecha, status, id_cliente, id_empleados) 
VALUES ('Imprimir 100 trípticos UCN', 360000, '2024-03-01', 'Analizando', 1, 101);

-- Presupuesto C2
INSERT INTO presupuesto (descripcion_producto, valoracion, fecha, status, id_cliente, id_empleados) 
VALUES ('Imprimir 70 ejemplares del libro guía de Programación', 700000, '2024-01-01', 'Analizando', 2, 102);

-- Presupuesto C3
INSERT INTO presupuesto (descripcion_producto, valoracion, fecha, status, id_cliente, id_empleados) 
VALUES ('Construir 2 pendones de la Escuela de Ingeniería', 220000, '2024-04-01', 'Analizando', 2, 103);

-- 4. E)

UPDATE presupuesto 
SET status = 'Aceptada', fecha = '2024-01-15' 
WHERE id = 2;

INSERT INTO producto (descripcion, estado_pago, id_presupuesto) 
VALUES ('Produto C2', 'No pagado', 2);


INSERT INTO orden (fecha_aceptacion, status, fecha_finalizacion, id_producto) 
VALUES ('2024-01-15', 'Aceptada', NULL, 2);

INSERT INTO empleado_orden (rut_empleado, order_id)
VALUES 
(102, 1),
(103, 1);


--4. F)
UPDATE presupuesto 
SET status = 'Aceptada', fecha = '2024-04-28' 
WHERE id = 3;

INSERT INTO producto (descripcion, estado_pago, id_presupuesto) 
VALUES ('Produto C3', 'No pagado', 3);

INSERT INTO orden (fecha_aceptacion, status, fecha_finalizacion, id_producto) 
VALUES ('2024-04-28', 'Aceptada', NULL, 3);

INSERT INTO empleado_orden (rut_empleado, order_id)
VALUES 
(102, 2);

-- 4. G)

UPDATE orden SET status = 'Terminada', fecha_finalizacion = '2024-05-01' WHERE id = 2;

INSERT INTO factura (id, metodo_pago, valor, fecha, id_orden) values (1, 'Efectivo', 100000, '2024-04-20', 2);

INSERT INTO factura (id, metodo_pago, valor, fecha, id_orden) values (2,'Efectivo', 120000, '2024-05-10', 2)


-- 4. H)

UPDATE orden SET status = 'Terminada', fecha_finalizacion = '2024-02-20' WHERE id = 1;

INSERT INTO factura (id, metodo_pago, valor, fecha, id_orden) values (3,'Efectivo', 700000, '2024-02-25', 1)


-- 4. I)

INSERT INTO producto_empresa_transporte (rut_empresa, id_producto) values (203, 3);

-- 4. J)

INSERT INTO producto_empresa_transporte (rut_empresa, id_producto) values (202, 2);

-- 5. A)

SELECT c.rut, c.nombre, p.descripcion_producto, p.valoracion, p.fecha, p.status
FROM cliente c
LEFT JOIN presupuesto p ON c.rut = p.id_cliente;

-- 5. B)

SELECT e.rut, e.nombre, p.descripcion_producto, p.valoracion, p.fecha, p.status
FROM empleado e
LEFT JOIN presupuesto p ON e.rut = p.id_empleados;

-- 5. C)

SELECT p.id, p.descripcion_producto, p.valoracion, p.fecha, p.status
FROM presupuesto p
WHERE p.status = 'Analizando' AND (CURRENT_DATE - p.fecha) > 30;


-- 5. D)

SELECT m.nombre, COUNT(pm.id_presupuesto) AS quantidade_utilizada
FROM material m
JOIN presupuesto_material pm ON m.id = pm.id_material
GROUP BY m.nombre
ORDER BY quantidade_utilizada DESC
LIMIT 1;

-- 5. E)

SELECT p.id, p.descripcion_producto, p.valoracion, p.fecha, p.status
FROM presupuesto p
JOIN orden o ON o.id_producto = p.id
WHERE p.status = 'Lista' AND NOT EXISTS (
    SELECT 1 FROM producto_empresa_transporte pet WHERE pet.id_producto = p.id
);

-- 5. F)

SELECT et.nombre, COUNT(pet.id_producto) AS quantidade_envios
FROM empresa_transporte et
JOIN producto_empresa_transporte pet ON et.rut = pet.rut_empresa
GROUP BY et.nombre
ORDER BY quantidade_envios DESC
LIMIT 1;


-- 5. G)

SELECT c.nombre,
    SUM(CASE 
        WHEN p.status = 'Analizando' AND (CURRENT_DATE - p.fecha) <= 30 THEN 1
        ELSE 0
    END) AS cotizacoes_pendentes,
    SUM(CASE 
        WHEN p.status = 'Analizando' AND (CURRENT_DATE - p.fecha) > 30 THEN 1
        ELSE 0
    END) AS cotizacoes_abandonadas,
    SUM(CASE 
        WHEN p.status = 'Trabajando' THEN 1
        ELSE 0
    END) AS cotizacoes_trabalhando,
    SUM(CASE 
        WHEN p.status = 'Lista' THEN 1
        ELSE 0
    END) AS cotizacoes_listas,
    SUM(CASE 
        WHEN EXISTS (SELECT 1 FROM producto_empresa_transporte pet WHERE pet.id_producto = p.id) THEN 1
        ELSE 0
    END) AS cotizacoes_despachadas
FROM cliente c
LEFT JOIN presupuesto p ON c.rut = p.id_cliente
GROUP BY c.nombre;

