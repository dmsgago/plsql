/*Diseña un procedimiento al que pasemos como parámetro de entrada el nombre de 
uno de los módulos existentes en la BD y visualice el nombre de los alumnos que 
lo han cursado junto a su nota.
Al final del listado debe aparecer el nº de suspensos, aprobados, notables y 
sobresalientes.
Asimismo, deben aparecer al final los nombres y notas de los alumnos que tengan 
la nota más alta y la más baja.
Debes comprobar que las tablas tengan almacenada información y que exista 
el módulo cuyo nombre pasamos como parámetro al procedimiento. */

CREATE OR REPLACE PROCEDURE principal(p_modulo asignaturas.nombre%type)
IS
    CURSOR c_notas IS
    SELECT apenom, nota
    FROM alumnos a, notas n
    WHERE a.dni = n.dni
    AND n.cod = (SELECT cod
                   FROM asignaturas
                   WHERE nombre=p_modulo);
    v_notas c_notas%rowtype;
	cont_sus NUMBER:=0;
	cont_ap NUMBER:=0;
	cont_not NUMBER:=0;
	cont_sob NUMBER:=0;
	v_nom_max VARCHAR2(50):='';
	v_nota_max NUMBER:=0;
	v_nom_min VARCHAR2(50):='';
	v_nota_min NUMBER:=11;
BEGIN
    OPEN c_notas;
    FETCH c_notas INTO v_notas;
    WHILE c_notas%FOUND LOOP
        MostrarAlumnoYNota(v_notas.apenom, v_notas.nota);
        ContabilizarTipoNota(v_notas.nota, cont_sus, cont_ap, cont_not, cont_sob);
        ComprobarSiMax(v_notas.apenom, v_notas.nota, v_nom_max, v_nota_max);
        ComprobarSiMin(v_notas.apenom, v_notas.nota, v_nom_min, v_nota_min);
        FETCH c_notas INTO v_notas;
    END LOOP;
    CLOSE c_notas;
   MostrarResultados(cont_sus, cont_ap, cont_not, cont_sob, v_nom_max, v_nota_max, v_nom_min, v_nota_min);
END principal;
/

CREATE OR REPLACE PROCEDURE MostrarAlumnoYNota(p_nombre alumnos.apenom%type, p_nota notas.nota%type)
IS
BEGIN
	dbms_output.put_line(p_nombre || p_nota);
END  MostrarAlumnoYNota;
/

CREATE OR REPLACE PROCEDURE ContabilizarTipoNota (p_nota notas.nota%type, p_sus IN OUT NUMBER, p_ap IN OUT NUMBER, p_not IN OUT NUMBER, p_sob IN OUT NUMBER)
IS
	v_suspenso NUMBER:=0;
	v_aprobado NUMBER:=0;
	v_notable NUMBER:=0;
	v_sobresaliente NUMBER:=0;
BEGIN
	IF p_nota < 5 THEN
		v_suspenso:=v_suspenso+1;
	ELSIF p_nota < 7 THEN
		v_aprobado:=v_aprobado+1;
	ELSIF p_nota < 9 THEN
		v_notable:=v_notable+1;
	ELSE
		v_sobresaliente:=v_sobresaliente+1;
	END IF;
	p_sus:=v_suspenso;
	P_ap:=v_aprobado;
	p_not:=v_notable;
	p_sob:=v_sobresaliente;
END  ContabilizarTipoNota;
/

CREATE OR REPLACE PROCEDURE ComprobarSiMax (p_nombre alumnos.apenom%type, p_nota notas.nota%type, p_nombremax IN OUT alumnos.apenom%type, p_notamax IN OUT notas.nota%type)
IS
BEGIN
	IF p_nota > p_notamax THEN
		p_notamax:=p_nota;
		p_nombremax:=p_nombre;
	END IF;
END ComprobarSiMax;
/

CREATE OR REPLACE PROCEDURE ComprobarSiMin (p_nombre alumnos.apenom%type, p_nota notas.nota%type, p_nombremin IN OUT alumnos.apenom%type, p_notamin IN OUT notas.nota%type)
IS
BEGIN
	IF p_nota < p_notamin THEN
		p_notamin:=p_nota;
		p_nombremin:=p_nombre;
	END IF;
END ComprobarSiMin;
/

CREATE OR REPLACE PROCEDURE MostrarResultados(p_cont_sus NUMBER, p_cont_ap NUMBER, p_cont_not NUMBER, p_cont_sob NUMBER, p_nom_max VARCHAR2, p_nota_max NUMBER, p_nom_min VARCHAR2, p_nota_min NUMBER)
IS
BEGIN
	dbms_output.put_line(p_cont_sus || p_cont_ap || p_cont_not || p_cont_sob || p_nom_max || p_nota_max || p_nom_min || p_nota_min);
END MostrarResultados;
/