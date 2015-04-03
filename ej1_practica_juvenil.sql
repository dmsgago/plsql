-- Creacion de tablas
CREATE TABLE socios (
	dni VARCHAR2(10),
	nombre VARCHAR2(20) NOT NULL,
	direccion VARCHAR2(20),
	penalizaciones NUMBER(2) DEFAULT 0,
	CONSTRAINT pk_socios PRIMARY KEY (dni)
);

CREATE TABLE libros (
	reflibro VARCHAR2(10),
	nombre VARCHAR2(30) NOT NULL,
	autor VARCHAR2(20) NOT NULL,
	genero VARCHAR2(10),
	anyopublicacion NUMBER,
	editorial VARCHAR2(10),
	CONSTRAINT pk_libros PRIMARY KEY (reflibro)
);

CREATE TABLE prestamos (
	dni VARCHAR2(10) NOT NULL,
	reflibro VARCHAR2(10) NOT NULL,
	fechaprestamo VARCHAR2(10) NOT NULL,
	duracion NUMBER(2) DEFAULT 24,
	CONSTRAINT fk_dniprestamos FOREIGN KEY (dni) REFERENCES socios (dni),
	CONSTRAINT fk_refprestamos FOREIGN KEY (reflibro) REFERENCES libros (reflibro),
	CONSTRAINT pk_prestamos PRIMARY KEY (dni,reflibro,fechaprestamo)
);