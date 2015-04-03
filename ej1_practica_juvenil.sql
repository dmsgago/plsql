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
	fechaprestamo DATE NOT NULL,
	duracion NUMBER(2) DEFAULT 24,
	CONSTRAINT fk_dniprestamos FOREIGN KEY (dni) REFERENCES socios (dni),
	CONSTRAINT fk_refprestamos FOREIGN KEY (reflibro) REFERENCES libros (reflibro),
	CONSTRAINT pk_prestamos PRIMARY KEY (dni,reflibro,fechaprestamo)
);

-- Datos a insertar
INSERT INTO socios VALUES ('000000011A','Pedro','Real Utrera',1);
INSERT INTO socios VALUES ('000000022B','Antonio','Bulerias',2);
INSERT INTO socios VALUES ('000000033C','Ricardo','Manzanilla',0);
INSERT INTO socios VALUES ('000000044D','Manuel','Formentera',0);
INSERT INTO socios VALUES ('000000055E','Rosario','Guadaira',0);
INSERT INTO socios VALUES ('000000066F','Dolores','Espartero',0);

INSERT INTO libros VALUES ('01','Don Quijote','Cervantes','Aventura',1605,'Santillana');
INSERT INTO libros VALUES ('02','Alatriste','Arturo','Aventura',1996,'Alfaguara');
INSERT INTO libros VALUES ('03','Un mundo sin fin','Ken Follett','Ficcion',2007,'Plaza Janes');
INSERT INTO libros VALUES ('04','Cid','Anonimo','Cantar',1200,'Catedra');
INSERT INTO libros VALUES ('05','50 sombras','James','Novela',2011,'Grijalbo');

INSERT INTO prestamos VALUES ('000000011A','02','2014/01/17');
INSERT INTO prestamos VALUES ('000000022B','03','2014/01/19');
INSERT INTO prestamos VALUES ('000000033C','02','2014/01/28');
INSERT INTO prestamos VALUES ('000000044D','01','2014/04/11');
INSERT INTO prestamos VALUES ('000000011A','03','2014/04/22');
INSERT INTO prestamos VALUES ('000000055E','01','2014/06/05');
INSERT INTO prestamos VALUES ('000000022B','04','2014/06/17');
INSERT INTO prestamos VALUES ('000000066F','04','2014/08/25');


--Procedimiento para listar los 4 libro mas prestados
