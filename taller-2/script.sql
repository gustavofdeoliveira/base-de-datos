CREATE TABLE IF NOT EXISTS cliente (
  rut INT PRIMARY KEY,  
  nombre VARCHAR(255) NOT NULL,  
  direccion VARCHAR(255) NOT NULL,  
  numero_telefono INT,  
  email VARCHAR(150) NOT NULL,  
  UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS mascota (
  id SERIAL PRIMARY KEY,  
  nombre VARCHAR(255) NOT NULL,  
  tipo VARCHAR(50) NOT NULL,  
  raza VARCHAR(50) NOT NULL,  
  fecha_nacimiento DATE NOT NULL,  
  id_cliente INT NOT NULL,  
  FOREIGN KEY (id_cliente) REFERENCES cliente(rut)
);

CREATE TABLE IF NOT EXISTS veterinario (
  rut INT PRIMARY KEY,  
  nombre VARCHAR(255) NOT NULL,  
  especialidad VARCHAR(50) NOT NULL,  
  numero_telefono VARCHAR(50) NOT NULL,  
  email VARCHAR(150) NOT NULL,  
  UNIQUE (email)
);

CREATE TABLE IF NOT EXISTS visita (
  id SERIAL PRIMARY KEY,  
  fecha DATE NOT NULL DEFAULT NOW(),  
  motivo VARCHAR(150) NOT NULL,  
  diagnostico VARCHAR(255) NOT NULL,  
  descripcion TEXT,  
  id_mascota INT NOT NULL,  
  id_veterinario INT NOT NULL,  
  FOREIGN KEY (id_mascota) REFERENCES mascota(id),
  FOREIGN KEY (id_veterinario) REFERENCES veterinario(rut)
);

CREATE TABLE IF NOT EXISTS tratamiento (
  id SERIAL PRIMARY KEY,  
  nombre VARCHAR(255) NOT NULL,  
  fecha_fin DATE NOT NULL,  
  fecha_inicio DATE NOT NULL DEFAULT NOW(),  
  precio FLOAT NOT NULL DEFAULT 0,  
  id_visita INT NOT NULL,  
  FOREIGN KEY (id_visita) REFERENCES visita(id)
);

CREATE TABLE IF NOT EXISTS contesta (
  rut_veterinario INT NOT NULL,  
  id_tratamiento INT NOT NULL,  
  id SERIAL PRIMARY KEY,  
  FOREIGN KEY (rut_veterinario) REFERENCES veterinario(rut),
  FOREIGN KEY (id_tratamiento) REFERENCES tratamiento(id)
);


-- Insertando registros en la tabla cliente
INSERT INTO cliente (rut, nombre, direccion, numero_telefono, email) VALUES 
(12345678, 'Juan Pérez', 'Av. Libertador 123, Santiago', 912345678, 'juan.perez@gmail.com'),
(87654321, 'María González', 'Calle Los Robles 456, Valparaíso', 987654321, 'maria.gonzalez@yahoo.com'),
(11223344, 'Carlos Muñoz', 'Pasaje Las Rosas 789, Concepción', 965432100, 'carlos.munoz@hotmail.com'),
(44332211, 'Ana Fernández', 'Camino a Melipilla 1010, Santiago', 998877665, 'ana.fernandez@outlook.com'),
(55667788, 'Pedro Ramírez', 'Calle Central 200, Viña del Mar', 912334455, 'pedro.ramirez@gmail.com'),
(66778899, 'Claudia Torres', 'Av. Los Leones 500, La Serena', 976543210, 'claudia.torres@gmail.com'),
(99887766, 'José Morales', 'Calle El Bosque 300, Temuco', 923456789, 'jose.morales@live.com'),
(77665544, 'Paula Castillo', 'Av. Providencia 800, Santiago', 965432123, 'paula.castillo@hotmail.com'),
(33445566, 'Fernando Soto', 'Calle La Paz 99, Antofagasta', 987654322, 'fernando.soto@gmail.com'),
(22334455, 'Sofía Rojas', 'Camino Real 250, Iquique', 932145678, 'sofia.rojas@yahoo.com');

-- Insertando registros en la tabla mascota
INSERT INTO mascota (nombre, tipo, raza, fecha_nacimiento, id_cliente) VALUES 
('Max', 'Perro', 'Labrador', '2021-05-12', 12345678),
('Luna', 'Gato', 'Siames', '2022-03-25', 87654321),
('Simba', 'Gato', 'Persa', '2020-08-15', 11223344),
('Toby', 'Perro', 'Beagle', '2021-01-30', 44332211),
('Bella', 'Perro', 'Bulldog', '2019-11-05', 55667788),
('Rocky', 'Perro', 'Pastor Alemán', '2018-07-21', 66778899),
('Milo', 'Gato', 'Angora', '2020-10-14', 99887766),
('Coco', 'Perro', 'Caniche', '2022-04-09', 77665544),
('Lola', 'Gato', 'Maine Coon', '2021-02-20', 33445566),
('Bruno', 'Perro', 'Dálmata', '2019-06-18', 22334455);
('Carlos', 'Perro', 'Dálmata', '2020-07-18', 22334455);

-- Insertando registros en la tabla veterinario
INSERT INTO veterinario (rut, nombre, especialidad, numero_telefono, email) VALUES 
(12312312, 'Dr. Martín Sánchez', 'Medicina General', '912345600', 'martin.sanchez@veterinaria.com'),
(32132132, 'Dra. Elena Pérez', 'Cirugía', '987650000', 'elena.perez@veterinaria.com'),
(45645645, 'Dr. Alejandro Ruiz', 'Dermatología', '965432001', 'alejandro.ruiz@veterinaria.com'),
(65465465, 'Dra. Camila Ortega', 'Neurología', '998877600', 'camila.ortega@veterinaria.com'),
(78978978, 'Dr. Pablo Herrera', 'Cardiología', '912333400', 'pablo.herrera@veterinaria.com'),
(98798798, 'Dra. Natalia Soto', 'Oncología', '976540000', 'natalia.soto@veterinaria.com'),
(14714714, 'Dr. Felipe Martínez', 'Medicina General', '923456600', 'felipe.martinez@veterinaria.com'),
(25825825, 'Dra. Teresa Gómez', 'Ortopedia', '965432200', 'teresa.gomez@veterinaria.com'),
(36936936, 'Dr. Ricardo Núñez', 'Nutrición', '987654300', 'ricardo.nunez@veterinaria.com'),
(74174174, 'Dra. Valentina López', 'Medicina General', '932140000', 'valentina.lopez@veterinaria.com');

-- Insertando registros en la tabla visita
INSERT INTO visita (id, fecha, motivo, diagnostico, descripcion, id_mascota, id_veterinario) VALUES 
(1, '2024-10-01', 'Vacunación', 'Vacuna anual aplicada', 'Mascota en buen estado de salud', 1, 12312312),
(2, '2024-10-05', 'Control de salud', 'Sin hallazgos relevantes', 'Peso adecuado y buen estado físico', 2, 32132132),
(3, '2024-09-28', 'Emergencia', 'Infección respiratoria', 'Antibióticos prescritos para 7 días', 3, 45645645),
(4, '2024-10-10', 'Desparasitación', 'Administrada dosis de antiparasitario', 'Recomendada repetición en 3 meses', 4, 65465465),
(5, '2024-10-15', 'Chequeo post-cirugía', 'Recuperación exitosa', 'Cicatriz en buen estado', 5, 78978978),
(6, '2024-10-07', 'Vacunación', 'Vacuna contra la rabia aplicada', 'Sin reacciones adversas', 6, 98798798),
(7, '2024-09-30', 'Control de salud', 'Peso levemente elevado', 'Recomendación de dieta', 7, 14714714),
(8, '2024-10-12', 'Emergencia', 'Corte profundo en la pata', 'Sutura y curación realizadas', 8, 25825825),
(9, '2024-10-16', 'Vacunación', 'Vacuna triple felina aplicada', 'Recomendado monitorear durante 24 horas', 9, 36936936),
(10, '2024-12-18', 'Control de salud', 'Signos de artritis', 'Recomendado suplemento para articulaciones', 10, 74174174);

-- Insertando registros en la tabla tratamiento
INSERT INTO tratamiento (id, nombre, fecha_fin, fecha_inicio, precio, id_visita) VALUES 
(1, 'Antibióticos', '2024-10-08', '2024-09-28', 5000.00, 3),
(2, 'Desparasitación oral', '2024-10-13', '2024-10-10', 1500.00, 4),
(3, 'Curación de heridas', '2024-10-20', '2024-10-12', 8000.00, 8),
(4, 'Suplemento para articulaciones', '2024-12-18', '2024-10-18', 3000.00, 10),
(5, 'Vacunación antirrábica', '2024-10-07', '2024-10-07', 2000.00, 6),
(6, 'Vacunación triple felina', '2024-10-16', '2024-10-16', 2500.00, 9),
(7, 'Antiinflamatorios', '2024-10-25', '2024-10-18', 3500.00, 10),
(8, 'Analgésicos', '2024-10-15', '2024-10-12', 4000.00, 8),
(9, 'Dieta especial', '2024-11-30', '2024-09-30', 4500.00, 7),
(10, 'Antiparasitario', '2024-12-10', '2024-10-10', 1800.00, 4);

-- Insertando registros en la tabla contesta
INSERT INTO contesta (id, rut_veterinario, id_tratamiento) VALUES 
(1, 12312312, 1),
(2, 32132132, 2),
(3, 45645645, 3),
(4, 65465465, 4),
(5, 78978978, 5),
(6, 98798798, 6),
(7, 14714714, 7),
(8, 25825825, 8),
(9, 36936936, 9),
(10, 74174174, 10);


-- 1. Encontrar todas las mascotas de un tipo específico.

select * from mascota m where m.tipo = 'Perro'

-- 2. Encontrar todas las visitas médicas realizadas por un veterinario específico.

SELECT v.id, v.fecha, v.motivo, v.diagnostico, v.descripcion, m.nombre AS mascota
FROM visita v
JOIN mascota m ON v.id_mascota = m.id
WHERE v.id_veterinario = '32132132';


-- 3. Verificar las mascotas que actualmente tienen tratamientos activos.

SELECT m.nombre, t.nombre AS tratamiento, t.fecha_inicio, t.fecha_fin
FROM mascota m
JOIN visita v ON m.id = v.id_mascota
JOIN tratamiento t ON v.id = t.id_visita
WHERE t.fecha_fin > NOW();

-- 4. Encontrar todas las visitas realizadas a una mascota específica.

SELECT v.id, v.fecha, v.motivo, v.diagnostico, v.descripcion
FROM visita v
JOIN mascota m ON v.id_mascota = m.id
WHERE m.id = 10; 

-- 5. Verificar si una mascota ha recibido un tratamiento específico en su historial.

SELECT t.nombre, m.nombre AS mascota
FROM tratamiento t
JOIN visita v ON t.id_visita = v.id
JOIN mascota m ON v.id_mascota = m.id
WHERE t.nombre = 'Antibióticos' AND m.id = 3; 

-- 6. Identificar a los dueños que tienen más de una mascota registrada.

SELECT c.nombre, c.rut, COUNT(m.id) AS cantidad_mascotas
FROM cliente c
JOIN mascota m ON c.rut = m.id_cliente
GROUP BY c.nombre, c.rut
HAVING COUNT(m.id) > 1;

-- 7. Encontrar todas las mascotas que han recibido tratamiento en un rango de fechas específico.

SELECT m.nombre, t.nombre AS tratamiento, t.fecha_inicio, t.fecha_fin
FROM mascota m
JOIN visita v ON m.id = v.id_mascota
JOIN tratamiento t ON v.id = t.id_visita
WHERE t.fecha_inicio >= '2024-10-10' AND t.fecha_fin <= '2024-10-13';

-- 8. Agrupar a los dueños por la cantidad de mascotas que poseen.

SELECT c.nombre, COUNT(m.id) AS cantidad_mascotas
FROM cliente c
JOIN mascota m ON c.rut = m.id_cliente
GROUP BY c.nombre;

-- 9. Encontrar tratamientos aplicados por un veterinario específico durante un rango de fechas.

SELECT t.nombre AS tratamiento, t.fecha_inicio, t.fecha_fin, v.fecha AS fecha_visita, m.nombre AS mascota
FROM tratamiento t
JOIN visita v ON t.id_visita = v.id
JOIN veterinario vet ON v.id_veterinario = vet.rut
JOIN mascota m ON v.id_mascota = m.id
WHERE vet.rut = 65465465
AND t.fecha_inicio >= '2024-10-10' AND t.fecha_fin <= '2024-10-13'; 

-- 10. Identificar las mascotas con más visitas médicas registradas.

SELECT m.nombre, COUNT(v.id) AS cantidad_visitas
FROM mascota m
JOIN visita v ON m.id = v.id_mascota
GROUP BY m.nombre
ORDER BY cantidad_visitas DESC;

-- 11. Encontrar los tratamientos más costosos que se han aplicado a una mascota específica.

SELECT t.nombre, t.precio
FROM tratamiento t
JOIN visita v ON t.id_visita = v.id
JOIN mascota m ON v.id_mascota = m.id
WHERE m.id = 6
ORDER BY t.precio DESC;

-- 12. Verificar si alguna mascota tiene visitas pendientes con veterinarios específicos.

SELECT m.nombre AS mascota, v.fecha AS fecha_visita, vet.nombre AS veterinario
FROM visita v
JOIN mascota m ON v.id_mascota = m.id
JOIN veterinario vet ON v.id_veterinario = vet.rut
WHERE v.fecha > NOW();

-- 13. Encontrar la visita más reciente realizada a cada mascota que no ha recibido tratamiento alguno.

SELECT m.nombre AS mascota, MAX(v.fecha) AS fecha_ultima_visita
FROM mascota m
JOIN visita v ON m.id = v.id_mascota
LEFT JOIN tratamiento t ON v.id = t.id_visita
WHERE t.id IS NULL
GROUP BY m.nombre;

-- 14. Encontrar los veterinarios que han atendido el mayor número de visitas y calcular el costo promedio de los tratamientos aplicados por cada uno.

SELECT vet.nombre AS veterinario, COUNT(v.id) AS cantidad_visitas, AVG(t.precio) AS costo_promedio_tratamiento
FROM veterinario vet
JOIN visita v ON vet.rut = v.id_veterinario
LEFT JOIN tratamiento t ON v.id = t.id_visita
GROUP BY vet.nombre
ORDER BY cantidad_visitas DESC;

--15. Encontrar las combinaciones de mascotas y dueños que han gastado más en tratamientos, mostrando el total gastado.

SELECT c.nombre AS dueño, m.nombre AS mascota, SUM(t.precio) AS total_gastado
FROM cliente c
JOIN mascota m ON c.rut = m.id_cliente
JOIN visita v ON m.id = v.id_mascota
JOIN tratamiento t ON v.id = t.id_visita
GROUP BY c.nombre, m.nombre
ORDER BY total_gastado DESC;