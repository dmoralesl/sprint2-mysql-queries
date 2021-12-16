USE universidad;

-- 1    Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'alumno' ORDER BY apellido1, apellido2, nombre; 
-- 2    Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;
-- 3    Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona WHERE tipo = 'alumno' AND SUBSTR(fecha_nacimiento, 1, 4) = '1999';
-- 4    Retorna el llistat de professors que no han donat d'alta el seu número de telèfon en la base de dades i a més la seva nif acaba en K.
SELECT nombre, apellido1, apellido2 FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND RIGHT(UPPER(nif), 1) = 'K';
-- 5    Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;
-- 6    Retorna un llistat dels professors juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre FROM persona INNER JOIN profesor ON persona.id = profesor.id_profesor INNER JOIN departamento ON profesor.id_departamento = departamento.id ORDER BY persona.apellido1, persona.apellido2, persona.nombre;
-- 7    Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne amb nif 26902806M.
SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin FROM persona INNER JOIN alumno_se_matricula_asignatura ON persona.id = alumno_se_matricula_asignatura.id_alumno INNER JOIN asignatura ON asignatura.id = alumno_se_matricula_asignatura.id_asignatura INNER JOIN curso_escolar ON curso_escolar.id = asignatura.curso WHERE nif = '26902806M';
-- 8    Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT * FROM departamento WHERE id IN (SELECT departamento.id FROM departamento INNER JOIN profesor ON departamento.id = profesor.id_departamento INNER JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor INNER JOIN grado ON asignatura.id_grado = grado.id WHERE grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)');
-- 9    Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT * FROM persona WHERE id IN (SELECT DISTINCT(persona.id) FROM persona LEFT JOIN alumno_se_matricula_asignatura ON persona.id = alumno_se_matricula_asignatura.id_alumno LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id WHERE curso_escolar.anyo_inicio = 2018 and curso_escolar.anyo_fin = 2019);
-- 10   Retorna un llistat amb els noms de tots els professors i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT departamento.nombre, persona.apellido2, persona.apellido1,persona.nombre FROM persona RIGHT JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN departamento ON profesor.id_departamento = departamento.id ORDER BY departamento.nombre, persona.apellido2, persona.apellido1,persona.nombre;
-- 11   Retorna un llistat amb els professors que no estan associats a un departament.
SELECT * FROM persona WHERE id IN (SELECT persona.id FROM persona RIGHT JOIN profesor ON persona.id = profesor.id_profesor WHERE profesor.id_departamento IS NULL);
-- 12   Retorna un llistat amb els departaments que no tenen professors associats.
SELECT * FROM departamento WHERE id IN (SELECT departamento.id FROM departamento LEFT JOIN profesor ON profesor.id_departamento = departamento.id WHERE profesor.id_profesor IS NULL);
-- 13   Retorna un llistat amb els professors que no imparteixen cap assignatura.
SELECT * FROM persona WHERE id IN (SELECT persona.id FROM persona RIGHT JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN asignatura ON persona.id = asignatura.id_profesor WHERE asignatura.id_profesor IS NULL);
-- 14   Retorna un llistat amb les assignatures que no tenen un professor assignat.
SELECT * FROM asignatura WHERE id IN (SELECT asignatura.id FROM asignatura LEFT JOIN profesor ON asignatura.id_profesor != profesor.id_profesor WHERE asignatura.id_profesor IS NULL);
-- 15   Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT(departamento.nombre) as departamento FROM asignatura RIGHT JOIN alumno_se_matricula_asignatura ON asignatura.id = id_asignatura RIGHT JOIN profesor ON profesor.id_profesor = asignatura.id_profesor RIGHT JOIN departamento ON departamento.id = profesor.id_departamento WHERE asignatura.id IS NULL;
-- 16   Retorna el nombre total d'alumnes que hi ha.
SELECT COUNT(*) FROM persona where tipo = 'alumno';
-- 17   Calcula quants alumnes van néixer en 1999.
SELECT COUNT(*) FROM persona WHERE tipo = 'alumno' AND SUBSTR(fecha_nacimiento, 1, 4) = '1999';
-- 18   Calcula quants professors hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors associats i haurà d'estar ordenat de major a menor pel nombre de professors.
SELECT COUNT(*) as profesores, departamento.nombre as departamento FROM asignatura INNER JOIN profesor ON asignatura.id_profesor = profesor.id_profesor INNER JOIN departamento ON profesor.id_departamento = departamento.id WHERE asignatura.id_profesor IS NOT NULL GROUP BY departamento.id ORDER BY profesores DESC;
-- 19   Retorna un llistat amb tots els departaments i el nombre de professors que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT departamento.nombre, COUNT(profesor.id_departamento) FROM departamento LEFT JOIN profesor ON departamento.id = profesor.id_departamento GROUP BY departamento.id;
-- 20   Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingui en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT grado.nombre, COUNT(asignatura.id) FROM grado LEFT JOIN asignatura ON grado.id = asignatura.id_grado GROUP BY grado.nombre;
-- 21   Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT * FROM (SELECT grado.nombre, COUNT(asignatura.id) as asignaturas FROM grado LEFT JOIN asignatura ON grado.id = asignatura.id_grado GROUP BY grado.nombre) as resultado WHERE asignaturas > 40;
-- 22   Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT grado.nombre, asignatura.tipo, SUM(asignatura.creditos) FROM grado INNER JOIN asignatura ON grado.id = asignatura.id_grado GROUP BY grado.nombre, asignatura.tipo;
-- 23   Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT curso_escolar.anyo_inicio, COUNT(alumno_se_matricula_asignatura.id_alumno) FROM alumno_se_matricula_asignatura LEFT JOIN curso_escolar ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id GROUP BY curso_escolar.anyo_inicio;
-- 24   Retorna un llistat amb el nombre d'assignatures que imparteix cada professor. El llistat ha de tenir en compte aquells professors que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT persona.id, persona.nombre, persona.apellido1, persona.apellido2, COUNT(asignatura.id) FROM persona INNER JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor GROUP BY persona.id, persona.nombre, persona.apellido1, persona.apellido2;
-- 25   Retorna totes les dades de l'alumne més jove.
SELECT * FROM persona WHERE tipo = 'alumno' ORDER BY fecha_nacimiento DESC LIMIT 1;
-- 26   Retorna un llistat amb els professors que tenen un departament associat i que no imparteixen cap assignatura.
SELECT * FROM persona WHERE id IN (SELECT persona.id FROM persona INNER JOIN profesor ON persona.id = profesor.id_profesor WHERE profesor.id_departamento IS NOT NULL AND NOT EXISTS (SELECT id_profesor FROM asignatura WHERE id_profesor = profesor.id_profesor));
