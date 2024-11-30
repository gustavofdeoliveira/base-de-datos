CREATE TABLE gerente 
( 
    rut INT PRIMARY KEY,  
    nombre VARCHAR(255) NOT NULL,  
    correo VARCHAR(150) NOT NULL,  
    telefono VARCHAR(50) NOT NULL  
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
    id INT PRIMARY KEY AUTO_INCREMENT,  
    porcentaje_descuento INT,  
    fecha_inicio DATE NOT NULL DEFAULT NOW(),  
    fecha_fin DATE NOT NULL DEFAULT NOW()  
);

CREATE TABLE detalle_venda 
( 
    id INT PRIMARY KEY AUTO_INCREMENT,  
    cantidad INT NOT NULL,  
    precio_unitario FLOAT NOT NULL  
);

CREATE TABLE producto 
( 
    id INT PRIMARY KEY AUTO_INCREMENT,  
    nombre VARCHAR(255) NOT NULL,  
    precio FLOAT NOT NULL,  
    fecha_criacion DATE NOT NULL DEFAULT NOW(),  
    fecha_atualizacion DATE NOT NULL DEFAULT NOW(),  
    categoria VARCHAR(255) NOT NULL,  
    id_provedor INT NOT NULL,  
    id_promocion INT NOT NULL,  
    id_detalle_venda INT NOT NULL,  
    FOREIGN KEY (categoria) REFERENCES categoria(nombre),  
    FOREIGN KEY (id_provedor) REFERENCES provedor(rut),  
    FOREIGN KEY (id_promocion) REFERENCES promocion(id),  
    FOREIGN KEY (id_detalle_venda) REFERENCES detalle_venda(id)  
);

CREATE TABLE venda 
( 
    id INT PRIMARY KEY AUTO_INCREMENT,  
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
    id INT PRIMARY KEY AUTO_INCREMENT,  
    fecha DATE NOT NULL DEFAULT NOW(),  
    motivo VARCHAR(255) NOT NULL,  
    id_cliente INT NOT NULL,  
    FOREIGN KEY (id_cliente) REFERENCES cliente(rut)  
);
