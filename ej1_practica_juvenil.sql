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
INSERT INTO libros VALUES ('03','Un mundo sin fin','Ken Follett','Ficcion',2007,'PlazaJanes');
INSERT INTO libros VALUES ('04','Cid','Anonimo','Cantar',1200,'Catedra');
INSERT INTO libros VALUES ('05','50 sombras','James','Novela',2011,'Grijalbo');

INSERT INTO prestamos VALUES ('000000011A','02',TO_DATE('2014/01/17','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000022B','03',TO_DATE('2014/01/19','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000033C','02',TO_DATE('2014/01/28','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000044D','01',TO_DATE('2014/04/11','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000011A','03',TO_DATE('2014/04/22','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000055E','01',TO_DATE('2014/06/05','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000022B','04',TO_DATE('2014/06/17','YYYY/MM/DD'),24);
INSERT INTO prestamos VALUES ('000000066F','04',TO_DATE('2014/08/25','YYYY/MM/DD'),24);


--Procedimiento para listar los 4 libro mas prestados
CREATE OR REPLACE PROCEDURE listadocuatromasprestados
IS
	CURSOR c_masprestados
	IS
		SELECT reflibro, COUNT(*) AS NumPrestamos
		FROM prestamos
		GROUP BY reflibro
		ORDER BY NumPrestamos;
	v_prestado c_masprestados%ROWTYPE;
BEGIN
	ComprobarExcepcionesej1;
	OPEN c_masprestados;
	FETCH c_masprestados INTO v_prestado;
	WHILE c_masprestados%ROWCOUNT<=4 LOOP
		MostrarLibro(v_prestado.reflibro, v_prestado.NumPrestamos);
		MostrarSocios(v_prestado.reflibro);
	FETCH c_masprestados INTO v_prestado;
	END LOOP;
	CLOSE c_masprestados;
END listadocuatromasprestados;

-- Procedimiento para comprobar excepciones
CREATE OR REPLACE PROCEDURE ComprobarExcepcionesej1
IS
BEGIN
	ComprobarExistencias;
END ComprobarExcepcionesej1;

-- Procedimiento que comprueba que haya datos en las tablas
CREATE OR REPLACE PROCEDURE ComprobarExistencias
IS
	cont_libros NUMBER:=0;
	cont_socios NUMBER:=0;
	cont_prestamos NUMBER:=0;
BEGIN
	SELECT COUNT(*) INTO cont_libros
	FROM libros;
	IF cont_libros=0 THEN
		raise_application_error(-20001,'Tabla libros vacía');
	END IF;
	
	SELECT COUNT(*) INTO cont_socios
	FROM socios;
	IF cont_socios=0 THEN
		raise_application_error(-20002,'Tabla socios vacía');
	END IF;
	
	SELECT COUNT(*) INTO cont_prestamos
	FROM prestamos;
	IF cont_prestamos=0 THEN
		raise_application_error(-20003,'Tabla prestamos vacía');
	-- Comprueba si hay menos de 4 libros prestados
	ELSIF cont_prestamos<4 THEN
		raise_application_error(-20003,'Hay menos de cuatro libros prestados');
	END IF;
END ComprobarExistencias;

-- Muestra informacion sobre los libros
CREATE OR REPLACE PROCEDURE MostrarLibro(p_idlibro, p_numsocios)
IS
v_nombre libros.nombre%TYPE;
v_genero libros.genero%TYPE;
BEGIN
	SELECT nombre, genero INTO v_nombre, v_genero
	FROM libros
	WHERE reflibro=p_idlibro;
	
	dbms_output.put_line(v_nombre||' '||p_numsocios||' '||v_genero);
END MostrarLibro;

-- Muestra los socios del libro pasado como parametro
CREATE OR REPLACE PROCEDURE MostrarSocios(p_idlibro)
IS
	CURSOR c_sociosporlibro
	IS
		SELECT dni, fechaprestamo
		FROM prestamos
		WHERE reflibro=p_idlibro;
	v_infosocio c_sociosporlibro%ROWTYPE;
BEGIN
	OPEN c_sociosporlibro;
	FETCH c_sociosporlibro INTO v_infosocio;
	WHILE c_sociosporlibro%FOUND LOOP
		dbms_output.put_line(v_infosocio.dni||v_infosocio.fechaprestamo)
	FETCH c_sociosporlibro INTO v_infosocio;
	END LOOP;
	CLOSE c_sociosporlibro;
END MostrarSocios;