-- ==========================================================================
-- PONER AL DÍA LAS FECHAS DE LOS DATOS DE DEMOSTRACIÓN
-- ==========================================================================
-- Los datos demo tienen fechas relativas al día en que se cargaron ("hace 3 días", "hoy",
-- "en 30 días"). Con los días se vuelven viejos: el mapa de vigilancia se vacía, las alertas de
-- brote se apagan y las citas "de hoy" quedan en el pasado. Este script mueve hacia adelante las
-- fechas de cada bloque demo los días que pasaron desde que se cargó, como si se hubiera cargado hoy.
--
-- - Cada bloque se cargó en un día distinto: se mide con un dato "ancla" de ese bloque cuya fecha
--   original se conoce (por ejemplo, la cita de control de María José estaba a +30 días).
-- - Solo toca datos de los pacientes demo (y practicantes demo). La bitácora de accesos, la de
--   integraciones y los cobros enviados a Tributario NO se mueven.
-- - Correrlo otra vez el mismo día no cambia nada (cada bloque ya queda en 0 días).
-- Uso:  mysql -u root -p < demo_refrescar_fechas.sql   (luego demo_turnos_hoy.sql para la sala de espera)
-- ==========================================================================
SET NAMES utf8mb4;
USE salud_db;

DROP PROCEDURE IF EXISTS refrescar_fechas_demo;
DELIMITER //
CREATE PROCEDURE refrescar_fechas_demo()
BEGIN
  DECLARE n INT;

  -- Pacientes demo del bloque base (los 20 de datos_demo.sql)
  DROP TEMPORARY TABLE IF EXISTS demo_base;
  CREATE TEMPORARY TABLE demo_base (id INT PRIMARY KEY);
  INSERT INTO demo_base SELECT id FROM pacientes WHERE cui IN (
    '2501123450102', '2501234560109', '2502345670104', '2503456780107', '2504567890106', '2505678900101',
    '2506789010108', '2507890120103', '2508901230105', '2509012340102', '2510123450103', '2511234560109',
    '2512345670106', '2513456780101', '2514567890104', '2515678900107', '2516789010105', '2517890120108',
    '2518901230103', '2519012340101');

  -- 1. Citas y expedientes del bloque base. Ancla: el control de presión de María José (+30 días)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MAX(c.fecha_hora))) + 30 FROM citas_medicas c JOIN pacientes p ON p.id = c.paciente_id
           WHERE p.cui = '2501123450102' AND c.motivo = 'Control de presión arterial');
  IF n > 0 THEN
    UPDATE citas_medicas SET fecha_hora = fecha_hora + INTERVAL n DAY, fecha_creacion = fecha_creacion + INTERVAL n DAY
      WHERE paciente_id IN (SELECT id FROM demo_base);
    UPDATE expedientes_clinicos SET fecha_atencion = fecha_atencion + INTERVAL n DAY WHERE paciente_id IN (SELECT id FROM demo_base);
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Citas y expedientes base: +', n, ' días'));
  END IF;

  -- 2. Practicantes. Ancla: Daniela Paredes empezó hace 75 días
  SET n = (SELECT DATEDIFF(CURDATE(), fecha_inicio) - 75 FROM practicantes WHERE dpi = '2520123450106');
  IF n > 0 THEN
    UPDATE horas_practica h JOIN practicantes p ON p.id_practicante = h.id_practicante
      SET h.fecha = h.fecha + INTERVAL n DAY WHERE p.dpi IN ('2520123450106', '2521234560103', '2522345670100');
    UPDATE practicantes SET fecha_inicio = fecha_inicio + INTERVAL n DAY, fecha_fin = fecha_fin + INTERVAL n DAY
      WHERE dpi IN ('2520123450106', '2521234560103', '2522345670100');
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Practicantes: +', n, ' días'));
  END IF;

  -- 3. Recetas del bloque base y sus despachos. Ancla: la primera receta de María José (-28 días)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(r.fecha))) - 28 FROM recetas r JOIN pacientes p ON p.id = r.id_paciente WHERE p.cui = '2501123450102');
  IF n > 0 THEN
    UPDATE movimientos_inventario m JOIN recetas r ON r.id_receta = m.receta_id
      SET m.fecha = m.fecha + INTERVAL n DAY WHERE r.id_paciente IN (SELECT id FROM demo_base);
    UPDATE recetas SET fecha = fecha + INTERVAL n DAY, fecha_despacho = fecha_despacho + INTERVAL n DAY
      WHERE id_paciente IN (SELECT id FROM demo_base);
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Recetas base: +', n, ' días'));
  END IF;

  -- 4. Hospitalización. Ancla: el ingreso de Pedro Pablo por diabetes descompensada (-3 días)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(h.fecha_ingreso))) - 3 FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente
           WHERE p.cui = '2507890120103' AND h.diagnostico LIKE 'Diabetes mellitus tipo 2 descompensada%');
  IF n > 0 THEN
    UPDATE notas_hospitalizacion nh JOIN hospitalizaciones h ON h.id_hospitalizacion = nh.hospitalizacion_id
      SET nh.fecha = nh.fecha + INTERVAL n DAY WHERE h.id_paciente IN (SELECT id FROM demo_base);
    UPDATE hospitalizaciones SET fecha_ingreso = fecha_ingreso + INTERVAL n DAY, fecha_asignacion = fecha_asignacion + INTERVAL n DAY,
      fecha_egreso = fecha_egreso + INTERVAL n DAY WHERE id_paciente IN (SELECT id FROM demo_base);
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Hospitalización: +', n, ' días'));
  END IF;

  -- 5. Caja (cuentas y sus movimientos; los cobros a Tributario no). Ancla: el laboratorio cargado a Pedro Pablo (-3 días)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(mc.fecha))) - 3 FROM movimientos_cuenta mc JOIN cuentas_paciente c ON c.id_cuenta = mc.id_cuenta
           JOIN pacientes p ON p.id = c.id_paciente JOIN servicios s ON s.id_servicio = mc.servicio_id
           WHERE p.cui = '2507890120103' AND s.codigo = 'LAB-002');
  IF n > 0 THEN
    UPDATE movimientos_cuenta mc JOIN cuentas_paciente c ON c.id_cuenta = mc.id_cuenta
      SET mc.fecha = mc.fecha + INTERVAL n DAY WHERE c.id_paciente IN (SELECT id FROM demo_base);
    UPDATE cuentas_paciente SET fecha_apertura = fecha_apertura + INTERVAL n DAY, fecha_cierre = fecha_cierre + INTERVAL n DAY,
      tramo_inicio = tramo_inicio + INTERVAL n DAY WHERE id_paciente IN (SELECT id FROM demo_base);
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Caja: +', n, ' días'));
  END IF;

  -- 6. Laboratorio. Ancla: la orden de María José con ayuno (-28 días)
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'ordenes_laboratorio') > 0 THEN
    SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(o.fecha))) - 28 FROM ordenes_laboratorio o JOIN pacientes p ON p.id = o.paciente_id WHERE p.cui = '2501123450102');
    IF n > 0 THEN
      UPDATE ordenes_laboratorio SET fecha = fecha + INTERVAL n DAY, fecha_muestra = fecha_muestra + INTERVAL n DAY,
        fecha_resultado = fecha_resultado + INTERVAL n DAY WHERE paciente_id IN (SELECT id FROM demo_base);
      INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Laboratorio: +', n, ' días'));
    END IF;
  END IF;

  -- 7. Constancias. Ancla: la constancia de consulta de Mario Roberto (-7 días)
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'constancias_medicas') > 0 THEN
    SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(c.fecha))) - 7 FROM constancias_medicas c JOIN pacientes p ON p.id = c.paciente_id
             WHERE p.cui = '2513456780101' AND c.tipo = 'CONSULTA');
    IF n > 0 THEN
      UPDATE constancias_medicas SET fecha = fecha + INTERVAL n DAY, fecha_atencion = fecha_atencion + INTERVAL n DAY,
        desde = desde + INTERVAL n DAY, hasta = hasta + INTERVAL n DAY WHERE paciente_id IN (SELECT id FROM demo_base);
      INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Constancias: +', n, ' días'));
    END IF;
  END IF;

  -- 8. Lista de espera. Ancla: Lucía Fernanda se anotó hace 6 días
  IF (SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = 'lista_espera_citas') > 0 THEN
    SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(l.fecha_registro))) - 6 FROM lista_espera_citas l JOIN pacientes p ON p.id = l.paciente_id
             WHERE p.cui = '2514567890104');
    IF n > 0 THEN
      UPDATE lista_espera_citas SET fecha_registro = fecha_registro + INTERVAL n DAY, fecha_aviso = fecha_aviso + INTERVAL n DAY
        WHERE paciente_id IN (SELECT id FROM demo_base);
      INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Lista de espera: +', n, ' días'));
    END IF;
  END IF;

  -- 9. Vigilancia (dengue en Villa Nueva, diarreas en Chinautla). Ancla: el dengue de Brenda (-1 día)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(e.fecha_atencion))) - 1 FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id
           WHERE p.cui = '3001000010115' AND e.codigo_cie10 = 'A90');
  IF n > 0 THEN
    UPDATE expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id SET e.fecha_atencion = e.fecha_atencion + INTERVAL n DAY
      WHERE p.cui LIKE '3001000%' AND LENGTH(p.cui) = 13 AND p.cui NOT IN ('3001000200108', '3001000210115');
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Vigilancia (Villa Nueva, Chinautla, Mixco): +', n, ' días'));
  END IF;

  -- 10. Crecimiento de Yesenia y Josué (su edad también). Ancla: la primera medición de Yesenia (hace 24 meses)
  SET n = (SELECT DATEDIFF(CURDATE(), DATE_ADD(MIN(m.fecha), INTERVAL 24 MONTH)) FROM mediciones_crecimiento m JOIN pacientes p ON p.id = m.paciente_id
           WHERE p.cui = '3001000200108');
  IF n > 0 THEN
    UPDATE mediciones_crecimiento m JOIN pacientes p ON p.id = m.paciente_id SET m.fecha = m.fecha + INTERVAL n DAY
      WHERE p.cui IN ('3001000200108', '3001000210115');
    UPDATE pacientes SET fecha_nacimiento = fecha_nacimiento + INTERVAL n DAY WHERE cui IN ('3001000200108', '3001000210115');
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Crecimiento de Yesenia y Josué: +', n, ' días'));
  END IF;

  -- 11. Población de todo el país (demo_poblacion.sql). Ancla: se registró 200 días antes de cargarse
  SET n = (SELECT DATEDIFF(CURDATE(), DATE(MIN(fecha_registro)) + INTERVAL 200 DAY) FROM pacientes WHERE cui LIKE '39%' AND LENGTH(cui) = 13);
  IF n > 0 THEN
    DROP TEMPORARY TABLE IF EXISTS demo_pob;
    CREATE TEMPORARY TABLE demo_pob (id INT PRIMARY KEY);
    INSERT INTO demo_pob SELECT id FROM pacientes WHERE cui LIKE '39%' AND LENGTH(cui) = 13;
    UPDATE expedientes_clinicos SET fecha_atencion = fecha_atencion + INTERVAL n DAY WHERE paciente_id IN (SELECT id FROM demo_pob);
    UPDATE movimientos_inventario m JOIN recetas r ON r.id_receta = m.receta_id
      SET m.fecha = m.fecha + INTERVAL n DAY WHERE r.id_paciente IN (SELECT id FROM demo_pob);
    UPDATE recetas SET fecha = fecha + INTERVAL n DAY, fecha_despacho = fecha_despacho + INTERVAL n DAY WHERE id_paciente IN (SELECT id FROM demo_pob);
    UPDATE mediciones_crecimiento SET fecha = fecha + INTERVAL n DAY WHERE paciente_id IN (SELECT id FROM demo_pob);
    UPDATE pacientes SET fecha_nacimiento = fecha_nacimiento + INTERVAL n DAY, fecha_registro = fecha_registro + INTERVAL n DAY
      WHERE id IN (SELECT id FROM demo_pob);
    INSERT INTO demo_resultado (resultado) VALUES (CONCAT('Población de todo el país: +', n, ' días'));
  END IF;
END //
DELIMITER ;

DROP TEMPORARY TABLE IF EXISTS demo_resultado;
CREATE TEMPORARY TABLE demo_resultado (n INT AUTO_INCREMENT PRIMARY KEY, resultado VARCHAR(200));
CALL refrescar_fechas_demo();
SELECT resultado FROM demo_resultado ORDER BY n;
SELECT 'Las fechas demo ya estaban al día' AS resultado FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM demo_resultado);
DROP TEMPORARY TABLE demo_resultado;
DROP PROCEDURE refrescar_fechas_demo;
