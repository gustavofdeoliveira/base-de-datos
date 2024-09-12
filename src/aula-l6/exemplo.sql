CREATE Table owner (
    rut text primary key,
    nombre text NOT NULL
);

CREATE Table pet (
    rut TEXT primary key,
    nombre text NOT NULL,
    owner_rut text NOT NULL references owner(rut)
);

INSERT INTO owner (rut, nombre) VALUES ('1-9', 'Juan');
INSERT INTO owner (rut, nombre) VALUES ('Pedro', '2-7');


INSERT INTO pet (rut, nombre, owner_rut) VALUES ('1-9', 'Firulais', '1-9');
INSERT INTO pet (rut, nombre, owner_rut) VALUES ('Pedro', 'Pirata', 'Pedro');