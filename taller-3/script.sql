-- Tabla Cliente
CREATE TABLE IF NOT EXISTS cliente (
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    direccion VARCHAR(255) NOT NULL,  
    email VARCHAR(100) NOT NULL,  
    telefone VARCHAR(50) NOT NULL,  
    contrasena VARCHAR(150) NOT NULL
);

-- Tabla Cuenta
CREATE TABLE IF NOT EXISTS cuenta (
    numero INT PRIMARY KEY,  
    saldo FLOAT NOT NULL DEFAULT 1000,  
    fecha_creacion DATE NOT NULL DEFAULT CURRENT_DATE,  
    id_cliente INT NOT NULL,
    CONSTRAINT fk_cuenta_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (rut)
);

-- Tabla Tipo Operacion
CREATE TABLE IF NOT EXISTS tipo_operacion (
    nombre VARCHAR(50) PRIMARY KEY
);

-- Tabla Operacion Status
CREATE TABLE IF NOT EXISTS operacion_status (
    nombre VARCHAR(50) PRIMARY KEY
);

-- Tabla Operacion Financeira
CREATE TABLE IF NOT EXISTS operacion_financeira (
    id INT PRIMARY KEY,  
    valor FLOAT NOT NULL,  
    fecha_creacion DATE NOT NULL DEFAULT CURRENT_DATE,  
    cuenta_operacion INT,  
    id_cliente INT NOT NULL,  
    tipo VARCHAR(50) NOT NULL,  
    status VARCHAR(50) NOT NULL,  
    id_cuenta INT NOT NULL,
    CONSTRAINT fk_operacion_cliente FOREIGN KEY (id_cliente) REFERENCES cliente (rut),
    CONSTRAINT fk_operacion_tipo FOREIGN KEY (tipo) REFERENCES tipo_operacion (nombre),
    CONSTRAINT fk_operacion_status FOREIGN KEY (status) REFERENCES operacion_status (nombre),
    CONSTRAINT fk_operacion_cuenta FOREIGN KEY (id_cuenta) REFERENCES cuenta (numero)
);

-- Insertar tipos de operación
INSERT INTO tipo_operacion (nombre) VALUES ('depósitos'), ('retiros'), ('transferencias') ON CONFLICT DO NOTHING;

-- Insertar estados de operación
INSERT INTO operacion_status (nombre) VALUES ('creado'), ('comenzo'), ('finalizado') ON CONFLICT DO NOTHING;

-- Insertando datos en la tabla Cliente
INSERT INTO cliente (rut, nombre, direccion, email, telefone, contrasena) VALUES
(101234567, 'Carlos Soto', 'Av. Las Flores 123', 'carlos.soto@gmail.com', '+56912345678', 'password123'),
(102345678, 'Ana Pérez', 'Calle Los Robles 456', 'ana.perez@hotmail.com', '+56987654321', 'securepass456'),
(103456789, 'Javier Morales', 'Pasaje Los Álamos 789', 'javier.morales@yahoo.com', '+56911223344', 'mypassword789'),
(104567890, 'Laura Díaz', 'Av. Principal 1011', 'laura.diaz@outlook.com', '+56933445566', 'laura1234'),
(105678901, 'Roberto Gómez', 'Calle Central 1415', 'roberto.gomez@gmail.com', '+56955667788', 'robgomez567');

-- Insertando datos en la tabla Cuenta
INSERT INTO cuenta (numero, saldo, fecha_creacion, id_cliente) VALUES
(2001, 2500.50, '2024-01-15', 101234567),
(2002, 1500.00, '2024-02-20', 102345678),
(2003, 3200.75, '2024-03-10', 103456789),
(2004, 4000.00, '2024-04-05', 104567890),
(2005, 500.25, '2024-05-18', 105678901);

-- Insertando datos en la tabla Operacion Financeira
INSERT INTO operacion_financeira (id, valor, fecha_creacion, cuenta_operacion, id_cliente, tipo, status, id_cuenta) VALUES
(3001, 500.00, '2024-06-01', 2001, 101234567, 'depósitos', 'creado', 2001),
(3002, 200.00, '2024-06-02', 2002, 102345678, 'retiros', 'finalizado', 2002),
(3003, 300.00, '2024-06-03', 2003, 103456789, 'transferencias', 'comenzo', 2003),
(3004, 100.00, '2024-06-04', 2004, 104567890, 'retiros', 'finalizado', 2004),
(3005, 150.00, '2024-06-05', 2005, 105678901, 'depósitos', 'creado', 2005);

-- Función para verificar saldo negativo
CREATE OR REPLACE FUNCTION verificar_saldo_negativo()
RETURNS TRIGGER AS $$
DECLARE
    saldo_actual FLOAT; -- Declarar la variable antes de las instrucciones
BEGIN
    -- Verificar si el tipo de operación es 'retiros' o 'transferencias'
    IF NEW.tipo = 'retiros' OR NEW.tipo = 'transferencias' THEN
        -- Obtener el saldo actual de la cuenta de origen
        SELECT saldo INTO saldo_actual FROM cuenta WHERE numero = NEW.id_cuenta;

        -- Verificar si la operación resultaría en un saldo negativo
        IF saldo_actual - NEW.valor < 0 THEN
            RAISE EXCEPTION 'Operación cancelada: saldo insuficiente para completar la transacción.';
        END IF;
    END IF;

    -- Permitir la operación si el saldo es suficiente
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger
CREATE TRIGGER trigger_verificar_saldo_negativo
BEFORE INSERT ON operacion_financeira
FOR EACH ROW
EXECUTE FUNCTION verificar_saldo_negativo();

-- Operación inválida: Retiro que deja saldo negativo
INSERT INTO operacion_financeira (id, valor, cuenta_operacion, id_cliente, tipo, status, id_cuenta) 
VALUES (4003, 5000.00, 2003, 103456789, 'retiros', 'comenzo', 2003);

-- Operación inválida: Transferencia que deja saldo negativo
INSERT INTO operacion_financeira (id, valor, cuenta_operacion, id_cliente, tipo, status, id_cuenta) 
VALUES (4004, 7000.00, 2004, 104567890, 'transferencias', 'creado', 2004);
