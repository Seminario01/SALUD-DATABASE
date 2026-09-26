-- ==========================================================================
-- DATOS DE DEMOSTRACIÓN del Módulo de Salud (ficticios)
-- ==========================================================================
-- Nombres, CUI y teléfonos son INVENTADOS. Las fechas son relativas al día en
-- que se carga el script: siempre hay citas de hoy, próximas y pasadas.
--
-- CUI pensados para los simuladores (SALUD-BACKEND/simuladores):
--   terminan en 9 -> Seguridad: antecedentes riesgo ALTO (requiere custodia)
--   terminan en 7 -> Seguridad: antecedentes riesgo BAJO
--   terminan en par -> Educación: es estudiante
--
-- Es seguro correrlo más de una vez: si los datos ya existen, no hace nada.
-- Uso:  mysql -u root -p < datos_demo.sql
-- Los turnos de la sala de espera van aparte: demo_turnos_hoy.sql
-- ==========================================================================
SET NAMES utf8mb4;
USE salud_db;

DROP PROCEDURE IF EXISTS cargar_datos_demo;
DELIMITER //
CREATE PROCEDURE cargar_datos_demo()
BEGIN
  IF (SELECT COUNT(*) FROM pacientes WHERE cui = '2501123450102') = 0 THEN

    -- Pacientes
    INSERT INTO pacientes (cui, nombre_completo, fecha_nacimiento, genero, telefono, tipo_seguro, cuidador) VALUES
      ('2501123450102', 'María José López Hernández', '1988-03-14', 'F', '55123401', 'IGSS', NULL),
      ('2501234560109', 'José Antonio Pérez García', '1975-11-02', 'M', '44871102', 'Ninguno', NULL),
      ('2502345670104', 'Ana Lucía Morales Cifuentes', '2009-06-21', 'F', '57220913', 'Ninguno', 'Rosa Cifuentes (madre)'),
      ('2503456780107', 'Carlos Enrique Ramírez Solís', '1992-01-30', 'M', '33019276', 'Privado', NULL),
      ('2504567890106', 'Sofía Alejandra Gómez Ruiz', '2011-09-05', 'F', '58764421', 'IGSS', 'Mario Gómez (padre)'),
      ('2505678900101', 'Luis Fernando Castillo Ortiz', '1968-04-17', 'M', '42198866', 'IGSS', NULL),
      ('2506789010108', 'Gabriela Fernanda Díaz Mejía', '2007-12-12', 'F', '51932077', 'Ninguno', 'Ana Mejía (madre)'),
      ('2507890120103', 'Pedro Pablo Juárez Chávez', '1955-08-25', 'M', '40017734', 'IGSS', 'Lucía Chávez (hija)'),
      ('2508901230105', 'Andrea Paola Reyes Monzón', '1999-02-08', 'F', '59638810', 'Privado', NULL),
      ('2509012340102', 'Diego Alejandro Méndez Paz', '2010-05-19', 'M', '56127745', 'Ninguno', 'Carmen Paz (madre)'),
      ('2510123450103', 'Rosa Elena Velásquez Toj', '1981-10-03', 'F', '48822913', 'IGSS', NULL),
      ('2511234560109', 'Juan Carlos Ixcoy Batz', '1990-07-27', 'M', '31774502', 'Ninguno', NULL),
      ('2512345670106', 'Karla Beatriz Estrada Lemus', '2008-03-30', 'F', '57449001', 'IGSS', 'Beatriz Lemus (madre)'),
      ('2513456780101', 'Mario Roberto Aguilar Cano', '1963-12-01', 'M', '40339987', 'Privado', NULL),
      ('2514567890104', 'Lucía Fernanda Tzul Ajú', '2012-11-11', 'F', '53301265', 'Ninguno', 'Julia Ajú (madre)'),
      ('2515678900107', 'Fernando José Barrios Ochoa', '1986-06-06', 'M', '34908812', 'IGSS', NULL),
      ('2516789010105', 'Claudia María Sandoval Rivas', '1979-09-14', 'F', '55770334', 'IGSS', NULL),
      ('2517890120108', 'Kevin Estuardo Coyoy Pérez', '2006-04-02', 'M', '46612230', 'Ninguno', 'Irma Pérez (madre)'),
      ('2518901230103', 'Marta Julia Orellana Cruz', '1948-01-23', 'F', '40125566', 'IGSS', 'Pedro Orellana (hijo)'),
      ('2519012340101', 'Oscar Iván Hernández Toc', '1995-10-10', 'M', '30982211', 'Privado', NULL);

    -- Citas (pasadas, de hoy y próximas)
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -28 DAY), '09:00:00'), 'atendida', 'Control de presión arterial', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -21 DAY), '10:30:00'), 'atendida', 'Dolor lumbar', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -14 DAY), '08:00:00'), 'atendida', 'Control de diabetes', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2502345670104'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '14:00:00'), 'atendida', 'Fiebre y dolor de garganta', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2510123450103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -9 DAY), '11:00:00'), 'cancelada', 'Consulta general', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2513456780101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -7 DAY), '09:30:00'), 'atendida', 'Chequeo anual', 250, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2516789010105'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -5 DAY), '15:00:00'), 'atendida', 'Migraña recurrente', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2518901230103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '08:30:00'), 'atendida', 'Control geriátrico', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2508901230105'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '16:00:00'), 'cancelada', 'Consulta dermatológica', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2501234560109'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '10:00:00'), 'atendida', 'Herida en antebrazo', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '08:00:00'), 'confirmada', 'Resultados de laboratorio', 150, 1);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2503456780107'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '09:00:00'), 'confirmada', 'Dolor abdominal', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2504567890106'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '10:30:00'), 'pendiente', 'Control de niño sano', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2509012340102'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '11:30:00'), 'pendiente', 'Vacunación escolar', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2514567890104'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '14:00:00'), 'confirmada', 'Tos persistente', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2519012340101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '15:30:00'), 'pendiente', 'Consulta general', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 1 DAY), '09:00:00'), 'confirmada', 'Seguimiento de lumbalgia', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2506789010108'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 2 DAY), '10:00:00'), 'pendiente', 'Evaluación nutricional', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2511234560109'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 3 DAY), '08:30:00'), 'pendiente', 'Consulta general', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2512345670106'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 4 DAY), '13:00:00'), 'confirmada', 'Control de asma', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2515678900107'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 6 DAY), '09:30:00'), 'pendiente', 'Dolor de rodilla', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2517890120108'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 8 DAY), '11:00:00'), 'pendiente', 'Certificado médico escolar', NULL, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 12 DAY), '08:00:00'), 'confirmada', 'Control de diabetes', 150, 0);
    INSERT INTO citas_medicas (paciente_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 30 DAY), '09:00:00'), 'pendiente', 'Control de presión arterial', NULL, 0);

    -- Atenciones en el expediente clínico
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), 'Hipertensión arterial estadio 1', 'Losartán 50 mg cada 24 h; dieta baja en sodio', 'Control en 4 semanas', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -28 DAY), '09:20:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), 'Lumbalgia mecánica', 'Ibuprofeno 400 mg cada 8 h por 5 días; fisioterapia', NULL, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -21 DAY), '10:50:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), 'Diabetes mellitus tipo 2 en control', 'Metformina 850 mg cada 12 h', 'HbA1c 7.1 %', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -14 DAY), '08:25:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2502345670104'), 'Faringoamigdalitis bacteriana', 'Amoxicilina 500 mg cada 8 h por 10 días', 'Reposo escolar 3 días', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '14:15:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2513456780101'), 'Chequeo anual sin hallazgos', 'Ninguno', 'Estilo de vida saludable', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -7 DAY), '09:45:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2516789010105'), 'Migraña sin aura', 'Naproxeno 550 mg en crisis; diario de cefaleas', NULL, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -5 DAY), '15:20:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2518901230103'), 'Osteoartritis de rodilla', 'Paracetamol 500 mg cada 8 h; ejercicio de bajo impacto', 'Uso de bastón', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '08:50:00'));
    INSERT INTO expedientes_clinicos (paciente_id, diagnostico, tratamiento, notas, fecha_atencion) VALUES ((SELECT id FROM pacientes WHERE cui = '2501234560109'), 'Herida cortante en antebrazo izquierdo', 'Sutura con 4 puntos; curación diaria', 'Retiro de puntos en 7 días', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '10:20:00'));

    -- Vacunación
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2502345670104'), 1, 0, 'VPH segunda dosis');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2504567890106'), 1, 1, NULL);
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2506789010108'), 1, 0, 'Td refuerzo');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2509012340102'), 1, 0, 'SPR refuerzo, Hepatitis A');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2512345670106'), 1, 1, NULL);
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2514567890104'), 1, 0, 'VPH primera dosis');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2517890120108'), 1, 1, NULL);
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), 0, 1, NULL);
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), 0, 0, 'Influenza estacional');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2518901230103'), 0, 0, 'Neumococo, Influenza estacional');
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2510123450103'), 0, 1, NULL);
    INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES ((SELECT id FROM pacientes WHERE cui = '2513456780101'), 0, 0, 'Td refuerzo');

    -- Recursos hospitalarios
    INSERT INTO recursos_hospitalarios (tipo, descripcion, disponible, total) VALUES
      ('cama', 'Camas de pediatría', 6, 12),
      ('cama', 'Camas de cuidados intensivos', 1, 6),
      ('ambulancia', 'Ambulancias de traslado', 2, 4),
      ('cupo_consulta', 'Cupos de consulta externa (hoy)', 18, 40);

    -- Presupuesto
    INSERT INTO presupuesto_hospitalario (periodo, monto_asignado, monto_ejecutado_servicio_social, descripcion) VALUES
      ('2026-Q4', 520000.00, 96400.00, 'Presupuesto trimestral hospital (demo)');

    -- Establecimientos (WS-SALUD-02, consumido por Seguridad)
    INSERT INTO establecimientos (nombre, tipo, direccion, departamento, municipio, telefono, estado_servicio, tipo_atencion_disponible) VALUES
      ('Hospital Nacional Pedro de Bethancourt', 'HOSPITAL', 'Aldea San Felipe de Jesús', 'Sacatepéquez', 'Antigua Guatemala', '78319600', 'ACTIVO', 'EMERGENCIA,CONSULTA_GENERAL,ESPECIALIDAD'),
      ('Centro de Salud Antigua Guatemala', 'CENTRO_SALUD', '6a. Calle Poniente', 'Sacatepéquez', 'Antigua Guatemala', '78320214', 'ACTIVO', 'CONSULTA_GENERAL,VACUNACION'),
      ('Puesto de Salud San Pedro Las Huertas', 'PUESTO_SALUD', 'Calle principal', 'Sacatepéquez', 'Antigua Guatemala', '78316655', 'ACTIVO', 'CONSULTA_GENERAL'),
      ('Hospital Roosevelt', 'HOSPITAL', 'Calzada Roosevelt, zona 11', 'Guatemala', 'Guatemala', '23217400', 'ACTIVO', 'EMERGENCIA,ESPECIALIDAD');

    SELECT 'Datos de demostración cargados' AS resultado;
  ELSE
    SELECT 'Los datos de demostración ya estaban cargados; no se cambió nada' AS resultado;
  END IF;
END //
DELIMITER ;

CALL cargar_datos_demo();
DROP PROCEDURE cargar_datos_demo;
