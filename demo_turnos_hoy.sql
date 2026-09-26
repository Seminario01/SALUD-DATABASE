-- ==========================================================================
-- TURNOS DE DEMOSTRACIÓN PARA HOY (ficticios)
-- ==========================================================================
-- Los turnos solo tienen sentido el día en que se crean. Correr este script
-- el día de la presentación para llenar la pantalla de sala de espera.
-- Requiere haber cargado antes datos_demo.sql (usa sus pacientes).
-- Si hoy ya hay turnos, no hace nada.
-- Uso:  mysql -u root -p < demo_turnos_hoy.sql
-- ==========================================================================
SET NAMES utf8mb4;
USE salud_db;

DROP PROCEDURE IF EXISTS cargar_turnos_demo;
DELIMITER //
CREATE PROCEDURE cargar_turnos_demo()
BEGIN
  IF (SELECT COUNT(*) FROM pacientes WHERE cui = '2501123450102') = 0 THEN
    SELECT 'Primero cargue datos_demo.sql' AS resultado;
  ELSEIF (SELECT COUNT(*) FROM turnos WHERE fecha_hora_ingreso >= CURDATE()) > 0 THEN
    SELECT 'Hoy ya hay turnos; no se cambió nada' AS resultado;
  ELSE
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2501234560109'), 'emergencia', 1, 'atendido', 'urgente', GREATEST(DATE_SUB(NOW(), INTERVAL 190 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 180 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 175 MINUTE), TIMESTAMP(CURDATE())), 'Emergencias');
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), 'consulta_general', 2, 'atendido', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 170 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 160 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 155 MINUTE), TIMESTAMP(CURDATE())), 'Consultorio 1');
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2508901230105'), 'especialidad', 3, 'en_atencion', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 120 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 110 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 105 MINUTE), TIMESTAMP(CURDATE())), 'Consultorio 3');
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2503456780107'), 'consulta_general', 4, 'llamado', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 95 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 85 MINUTE), TIMESTAMP(CURDATE())), NULL, 'Consultorio 2');
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2511234560109'), 'emergencia', 5, 'llamado', 'urgente', GREATEST(DATE_SUB(NOW(), INTERVAL 40 MINUTE), TIMESTAMP(CURDATE())), GREATEST(DATE_SUB(NOW(), INTERVAL 30 MINUTE), TIMESTAMP(CURDATE())), NULL, 'Emergencias');
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2516789010105'), 'consulta_general', 6, 'en_espera', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 35 MINUTE), TIMESTAMP(CURDATE())), NULL, NULL, NULL);
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2519012340101'), 'consulta_general', 7, 'en_espera', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 25 MINUTE), TIMESTAMP(CURDATE())), NULL, NULL, NULL);
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2515678900107'), 'especialidad', 8, 'en_espera', 'normal', GREATEST(DATE_SUB(NOW(), INTERVAL 15 MINUTE), TIMESTAMP(CURDATE())), NULL, NULL, NULL);
    INSERT INTO turnos (paciente_id, tipo_atencion, numero_turno, estado, prioridad, fecha_hora_ingreso, fecha_hora_llamado, fecha_hora_atencion, modulo_asignado) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), 'emergencia', 9, 'en_espera', 'urgente', GREATEST(DATE_SUB(NOW(), INTERVAL 5 MINUTE), TIMESTAMP(CURDATE())), NULL, NULL, NULL);
    SELECT 'Turnos de hoy cargados' AS resultado;
  END IF;
END //
DELIMITER ;

CALL cargar_turnos_demo();
DROP PROCEDURE cargar_turnos_demo;
