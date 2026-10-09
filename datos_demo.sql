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
    SELECT 'Los datos de demostración ya estaban cargados' AS resultado;
  END IF;

  -- Practicantes y sus horas (WS-SALUD-06 / WS-SALUD-07). Bloque aparte para
  -- poder agregarlos a una base donde los pacientes demo ya estaban cargados.
  IF (SELECT COUNT(*) FROM practicantes WHERE dpi = '2520123450106') = 0 THEN
    INSERT INTO practicantes (dpi, nombres, apellidos, universidad, carrera, fecha_inicio, fecha_fin, supervisor, estado) VALUES
      ('2520123450106', 'Daniela Sofía', 'Paredes Lima', 'Universidad de San Carlos de Guatemala', 'Médico y Cirujano', DATE_ADD(CURDATE(), INTERVAL -75 DAY), DATE_ADD(CURDATE(), INTERVAL 105 DAY), 'Dra. Ana María Recinos', 'ACTIVO'),
      ('2521234560103', 'Rodrigo Andrés', 'Monterroso Gil', 'Universidad Mariano Gálvez de Guatemala', 'Médico y Cirujano', DATE_ADD(CURDATE(), INTERVAL -120 DAY), DATE_ADD(CURDATE(), INTERVAL 60 DAY), 'Dr. Julio César Ordóñez', 'ACTIVO'),
      ('2522345670100', 'Valeria Isabel', 'Cifuentes Arana', 'Universidad Rafael Landívar', 'Licenciatura en Enfermería', DATE_ADD(CURDATE(), INTERVAL -30 DAY), DATE_ADD(CURDATE(), INTERVAL 150 DAY), 'Lcda. Marta Lucía Pineda', 'ACTIVO');
    INSERT INTO horas_practica (id_practicante, fecha, horas, actividad) VALUES
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 70 DAY), 8, 'Inducción y normas del servicio'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 56 DAY), 8, 'Consulta externa supervisada'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 42 DAY), 8, 'Emergencia de adultos'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 28 DAY), 8, 'Jornada de vacunación escolar'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 14 DAY), 8, 'Consulta externa supervisada'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2520123450106'), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 6, 'Encamamiento de medicina interna'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 110 DAY), 12, 'Turno de emergencia'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 90 DAY), 12, 'Turno de emergencia'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 70 DAY), 12, 'Cirugía general'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 50 DAY), 12, 'Pediatría'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 30 DAY), 12, 'Ginecología y obstetricia'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 10 DAY), 12, 'Turno de emergencia'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2521234560103'), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 12, 'Medicina interna'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2522345670100'), DATE_SUB(CURDATE(), INTERVAL 25 DAY), 6, 'Curaciones y signos vitales'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2522345670100'), DATE_SUB(CURDATE(), INTERVAL 18 DAY), 6, 'Vacunación'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2522345670100'), DATE_SUB(CURDATE(), INTERVAL 11 DAY), 6, 'Atención en encamamiento'),
      ((SELECT id_practicante FROM practicantes WHERE dpi = '2522345670100'), DATE_SUB(CURDATE(), INTERVAL 4 DAY), 6, 'Educación en salud a pacientes');
    SELECT 'Practicantes de demostración cargados' AS resultado;
  END IF;

  -- Farmacia: catálogo, inventario y recetas ligadas a las atenciones del expediente
  IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-001') = 0
     AND (SELECT COUNT(*) FROM pacientes WHERE cui = '2501123450102') > 0 THEN
    INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES
      ('MED-001', 'Acetaminofén', 'Tableta 500 mg', 850, 200, 0.25),
      ('MED-002', 'Ibuprofeno', 'Tableta 400 mg', 420, 150, 0.40),
      ('MED-003', 'Amoxicilina', 'Cápsula 500 mg', 300, 120, 1.10),
      ('MED-004', 'Amoxicilina', 'Suspensión 250 mg/5 ml, frasco 120 ml', 18, 25, 22.00),
      ('MED-005', 'Losartán', 'Tableta 50 mg', 540, 180, 0.85),
      ('MED-006', 'Metformina', 'Tableta 850 mg', 610, 200, 0.60),
      ('MED-007', 'Naproxeno', 'Tableta 550 mg', 6, 40, 1.25),
      ('MED-008', 'Dicloxacilina', 'Cápsula 500 mg', 140, 60, 1.90),
      ('MED-009', 'Omeprazol', 'Cápsula 20 mg', 380, 120, 0.55),
      ('MED-010', 'Loratadina', 'Tableta 10 mg', 260, 80, 0.70),
      ('MED-011', 'Salbutamol', 'Inhalador 100 mcg/dosis', 12, 15, 35.00),
      ('MED-012', 'Sales de rehidratación oral', 'Sobre 27.9 g', 95, 100, 3.50),
      ('MED-013', 'Enalapril', 'Tableta 10 mg', 300, 100, 0.45),
      ('MED-014', 'Sulfato ferroso', 'Tableta 300 mg', 450, 150, 0.30),
      ('MED-015', 'Ácido fólico', 'Tableta 5 mg', 500, 150, 0.20);
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario)
      SELECT id_medicamento, 'ENTRADA', existencia + CASE codigo WHEN 'MED-005' THEN 30 WHEN 'MED-002' THEN 15 WHEN 'MED-006' THEN 60 WHEN 'MED-003' THEN 30 WHEN 'MED-001' THEN 10 ELSE 0 END,
             DATE_SUB(NOW(), INTERVAL 35 DAY), 'Inventario inicial', 'farmacia1' FROM medicamentos WHERE codigo LIKE 'MED-0%';
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2501123450102'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2501123450102' AND e.diagnostico = 'Hipertensión arterial estadio 1' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -28 DAY), '10:30:00'), 'Tomar por la mañana. Control de presión en 4 semanas.', 'DESPACHADA', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -28 DAY), '11:15:00'));
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-005'), 30, '1 tableta cada 24 horas');
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-005'), 'SALIDA', -30, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -28 DAY), '11:15:00'), CONCAT('Despacho de la receta ', @receta), @receta, 'farmacia1');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2505678900101' AND e.diagnostico = 'Lumbalgia mecánica' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -21 DAY), '10:30:00'), 'Tomar con alimentos.', 'DESPACHADA', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -21 DAY), '11:15:00'));
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-002'), 15, '1 tableta cada 8 horas por 5 días');
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-002'), 'SALIDA', -15, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -21 DAY), '11:15:00'), CONCAT('Despacho de la receta ', @receta), @receta, 'farmacia1');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2507890120103' AND e.diagnostico = 'Diabetes mellitus tipo 2 en control' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -14 DAY), '10:30:00'), 'No suspender el tratamiento.', 'DESPACHADA', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -14 DAY), '11:15:00'));
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-006'), 60, '1 tableta cada 12 horas con las comidas');
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-006'), 'SALIDA', -60, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -14 DAY), '11:15:00'), CONCAT('Despacho de la receta ', @receta), @receta, 'farmacia1');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2502345670104'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2502345670104' AND e.diagnostico = 'Faringoamigdalitis bacteriana' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '10:30:00'), 'Completar los 10 días aunque desaparezcan los síntomas.', 'DESPACHADA', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:15:00'));
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-003'), 30, '1 cápsula cada 8 horas por 10 días');
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-003'), 'SALIDA', -30, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:15:00'), CONCAT('Despacho de la receta ', @receta), @receta, 'farmacia1');
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-001'), 10, '1 tableta cada 8 horas si hay fiebre');
    INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, receta_id, usuario) VALUES ((SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-001'), 'SALIDA', -10, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:15:00'), CONCAT('Despacho de la receta ', @receta), @receta, 'farmacia1');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2516789010105'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2516789010105' AND e.diagnostico = 'Migraña sin aura' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -5 DAY), '10:30:00'), 'Tomar al inicio de la crisis. Llevar diario de cefaleas.', 'PENDIENTE', NULL);
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-007'), 10, '1 tableta en crisis, máximo 2 al día');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2518901230103'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2518901230103' AND e.diagnostico = 'Osteoartritis de rodilla' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '10:30:00'), 'No exceder 3 tabletas al día.', 'PENDIENTE', NULL);
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-001'), 30, '1 tableta cada 8 horas por 10 días');
    INSERT INTO recetas (id_paciente, medico_nombre, expediente_id, fecha, indicaciones, estado, fecha_despacho) VALUES ((SELECT id FROM pacientes WHERE cui = '2501234560109'), 'Ana Lopez', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2501234560109' AND e.diagnostico = 'Herida cortante en antebrazo izquierdo' ORDER BY e.id LIMIT 1), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '10:30:00'), 'Curación diaria. Retiro de puntos en 7 días.', 'PENDIENTE', NULL);
    SET @receta = LAST_INSERT_ID();
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-008'), 28, '1 cápsula cada 6 horas por 7 días');
    INSERT INTO detalle_receta (id_receta, id_medicamento, cantidad, dosis) VALUES (@receta, (SELECT id_medicamento FROM medicamentos WHERE codigo = 'MED-001'), 10, '1 tableta cada 8 horas si hay dolor');
    SELECT 'Farmacia de demostración cargada' AS resultado;
  END IF;

  -- Hospitalización: censo de camas, pacientes ingresados, una orden pendiente y egresos
  IF (SELECT COUNT(*) FROM camas) = 0
     AND (SELECT COUNT(*) FROM pacientes WHERE cui = '2501123450102') > 0 THEN
    INSERT INTO recursos_hospitalarios (tipo, descripcion, disponible, total) SELECT 'cama', 'Camas área general', 0, 0 FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas área general');
    SET @recurso = (SELECT MIN(id) FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas área general');
    INSERT INTO camas (codigo, area, recurso_id, estado) VALUES
      ('GEN-01', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-02', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-03', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-04', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-05', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-06', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-07', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-08', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-09', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-10', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-11', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-12', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-13', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-14', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-15', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-16', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-17', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-18', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-19', 'Medicina general', @recurso, 'DISPONIBLE'),
      ('GEN-20', 'Medicina general', @recurso, 'DISPONIBLE');
    INSERT INTO recursos_hospitalarios (tipo, descripcion, disponible, total) SELECT 'cama', 'Camas de pediatría', 0, 0 FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas de pediatría');
    SET @recurso = (SELECT MIN(id) FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas de pediatría');
    INSERT INTO camas (codigo, area, recurso_id, estado) VALUES
      ('PED-01', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-02', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-03', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-04', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-05', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-06', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-07', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-08', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-09', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-10', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-11', 'Pediatría', @recurso, 'DISPONIBLE'),
      ('PED-12', 'Pediatría', @recurso, 'DISPONIBLE');
    INSERT INTO recursos_hospitalarios (tipo, descripcion, disponible, total) SELECT 'cama', 'Camas de cuidados intensivos', 0, 0 FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas de cuidados intensivos');
    SET @recurso = (SELECT MIN(id) FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion = 'Camas de cuidados intensivos');
    INSERT INTO camas (codigo, area, recurso_id, estado) VALUES
      ('UCI-01', 'Cuidados intensivos', @recurso, 'DISPONIBLE'),
      ('UCI-02', 'Cuidados intensivos', @recurso, 'DISPONIBLE'),
      ('UCI-03', 'Cuidados intensivos', @recurso, 'DISPONIBLE'),
      ('UCI-04', 'Cuidados intensivos', @recurso, 'DISPONIBLE'),
      ('UCI-05', 'Cuidados intensivos', @recurso, 'DISPONIBLE'),
      ('UCI-06', 'Cuidados intensivos', @recurso, 'DISPONIBLE');
    UPDATE camas SET estado = 'LIMPIEZA' WHERE codigo = 'GEN-15';
    UPDATE camas SET estado = 'MANTENIMIENTO', observacion = 'Monitor de signos vitales en reparación' WHERE codigo = 'UCI-04';
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2507890120103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '07:40:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '08:30:00'), NULL, 'Medicina general', 'GEN-03', (SELECT id_cama FROM camas WHERE codigo = 'GEN-03'), 'Diabetes mellitus tipo 2 descompensada (hiperglucemia)', 'Insulina según glucometría cada 6 h; dieta para diabético; control de signos cada 4 h.', 'ACTIVO', (SELECT e.id FROM expedientes_clinicos e JOIN pacientes p ON p.id = e.paciente_id WHERE p.cui = '2507890120103' AND e.diagnostico = 'Diabetes mellitus tipo 2 en control' ORDER BY e.id LIMIT 1), 'Ana Lopez', 'Marta Ramírez', NULL, NULL, NULL);
    UPDATE camas SET estado = 'OCUPADA' WHERE codigo = 'GEN-03';
    SET @hosp = LAST_INSERT_ID();
    INSERT INTO notas_hospitalizacion (hospitalizacion_id, fecha, autor_nombre, puesto, nota, presion, temperatura, frecuencia_cardiaca, saturacion) VALUES
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '09:00:00'), 'Ana Lopez', 'Médico', 'Glucemia de 412 mg/dl al ingreso. Inicia esquema de insulina.', '140/90', 37.0, 96, 96),
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '08:00:00'), 'Marta Ramírez', 'Enfermería', 'Glucometrías de 280, 245 y 210 mg/dl. Tolera la dieta.', '130/85', 36.8, 88, 97),
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '08:10:00'), 'Ana Lopez', 'Médico', 'Glucemia en ayunas de 168 mg/dl. Evolución favorable; se planifica egreso en 48 h.', '125/80', 36.6, 80, 98);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2518901230103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '09:15:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '09:50:00'), NULL, 'Medicina general', 'GEN-07', (SELECT id_cama FROM camas WHERE codigo = 'GEN-07'), 'Neumonía adquirida en la comunidad', 'Ceftriaxona 1 g IV cada 24 h; oxígeno si SpO2 < 92 %; nebulizaciones cada 6 h.', 'ACTIVO', NULL, 'Ana Lopez', 'Marta Ramírez', NULL, NULL, NULL);
    UPDATE camas SET estado = 'OCUPADA' WHERE codigo = 'GEN-07';
    SET @hosp = LAST_INSERT_ID();
    INSERT INTO notas_hospitalizacion (hospitalizacion_id, fecha, autor_nombre, puesto, nota, presion, temperatura, frecuencia_cardiaca, saturacion) VALUES
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '10:00:00'), 'Ana Lopez', 'Médico', 'Crepitantes en base pulmonar derecha; SpO2 de 89 % al aire, se inicia oxígeno por cánula nasal.', '110/70', 38.6, 104, 91),
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '07:30:00'), 'Marta Ramírez', 'Enfermería', 'Afebril durante la noche. Oxígeno a 2 L/min.', '115/70', 37.4, 92, 94),
      (@hosp, DATE_SUB(NOW(), INTERVAL 3 HOUR), 'Ana Lopez', 'Médico', 'Mejor mecánica ventilatoria; se reduce el oxígeno a 1 L/min.', '120/75', 36.9, 86, 95);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2505678900101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '14:20:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '14:55:00'), NULL, 'Medicina general', 'GEN-12', (SELECT id_cama FROM camas WHERE codigo = 'GEN-12'), 'Pielonefritis aguda', 'Hidratación IV; ciprofloxacina 400 mg IV cada 12 h; urocultivo.', 'ACTIVO', NULL, 'Ana Lopez', 'Marta Ramírez', NULL, NULL, NULL);
    UPDATE camas SET estado = 'OCUPADA' WHERE codigo = 'GEN-12';
    SET @hosp = LAST_INSERT_ID();
    INSERT INTO notas_hospitalizacion (hospitalizacion_id, fecha, autor_nombre, puesto, nota, presion, temperatura, frecuencia_cardiaca, saturacion) VALUES
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '15:00:00'), 'Marta Ramírez', 'Enfermería', 'Ingresa con fiebre y dolor lumbar derecho. Se canaliza vía periférica.', '118/76', 38.9, 108, 97);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2514567890104'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '11:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '16:40:00'), NULL, 'Pediatría', 'PED-02', (SELECT id_cama FROM camas WHERE codigo = 'PED-02'), 'Apendicitis aguda, postoperatorio de apendicectomía', 'Analgesia; ayuno por 12 h y luego dieta líquida; curación de la herida cada 24 h.', 'ACTIVO', NULL, 'Ana Lopez', 'Marta Ramírez', NULL, NULL, NULL);
    UPDATE camas SET estado = 'OCUPADA' WHERE codigo = 'PED-02';
    SET @hosp = LAST_INSERT_ID();
    INSERT INTO notas_hospitalizacion (hospitalizacion_id, fecha, autor_nombre, puesto, nota, presion, temperatura, frecuencia_cardiaca, saturacion) VALUES
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '18:00:00'), 'Marta Ramírez', 'Enfermería', 'Postoperatorio inmediato sin complicaciones; dolor 4/10.', '105/65', 37.2, 96, 98);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2513456780101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '21:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '21:45:00'), NULL, 'Cuidados intensivos', 'UCI-01', (SELECT id_cama FROM camas WHERE codigo = 'UCI-01'), 'Síndrome coronario agudo en observación', 'Monitoreo cardiaco continuo; ácido acetilsalicílico; reposo absoluto.', 'ACTIVO', NULL, 'Ana Lopez', 'Marta Ramírez', NULL, NULL, NULL);
    UPDATE camas SET estado = 'OCUPADA' WHERE codigo = 'UCI-01';
    SET @hosp = LAST_INSERT_ID();
    INSERT INTO notas_hospitalizacion (hospitalizacion_id, fecha, autor_nombre, puesto, nota, presion, temperatura, frecuencia_cardiaca, saturacion) VALUES
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '22:00:00'), 'Ana Lopez', 'Médico', 'Dolor torácico opresivo con troponina elevada. Se coordina cateterismo con Hospital Roosevelt si se requiere.', '150/95', 36.7, 98, 95),
      (@hosp, TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '06:00:00'), 'Marta Ramírez', 'Enfermería', 'Sin dolor torácico; ritmo sinusal en el monitor.', '135/85', 36.6, 76, 97);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2503456780107'), DATE_SUB(NOW(), INTERVAL 50 MINUTE), NULL, NULL, 'Medicina general', NULL, NULL, 'Dolor abdominal agudo en estudio', 'Ayuno; hidratación IV; ultrasonido abdominal.', 'PENDIENTE', NULL, 'Ana Lopez', NULL, NULL, NULL, NULL);
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2504567890106'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -12 DAY), '10:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -12 DAY), '10:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:00:00'), 'Pediatría', 'PED-04', (SELECT id_cama FROM camas WHERE codigo = 'PED-04'), 'Gastroenteritis aguda con deshidratación moderada', 'Hidratación IV; sales de rehidratación oral.', 'EGRESADO', NULL, 'Ana Lopez', 'Marta Ramírez', 'ALTA', 'Tolera la vía oral y está hidratada. Sales de rehidratación en casa; control en 3 días.', 'Ana Lopez');
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2510123450103'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -20 DAY), '08:00:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -20 DAY), '08:45:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -16 DAY), '12:00:00'), 'Medicina general', 'GEN-05', (SELECT id_cama FROM camas WHERE codigo = 'GEN-05'), 'Colecistitis aguda', 'Ayuno; antibiótico IV; colecistectomía programada.', 'EGRESADO', NULL, 'Ana Lopez', 'Marta Ramírez', 'ALTA', 'Colecistectomía laparoscópica sin complicaciones. Retiro de puntos en 10 días.', 'Ana Lopez');
    INSERT INTO hospitalizaciones (id_paciente, fecha_ingreso, fecha_asignacion, fecha_egreso, sala, cama, cama_id, diagnostico, indicaciones, estado, expediente_id, medico_nombre, asignado_por, tipo_egreso, resumen_egreso, egresado_por) VALUES
      ((SELECT id FROM pacientes WHERE cui = '2519012340101'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -8 DAY), '19:10:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -8 DAY), '19:30:00'), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -7 DAY), '09:00:00'), 'Medicina general', 'GEN-09', (SELECT id_cama FROM camas WHERE codigo = 'GEN-09'), 'Fractura de tibia derecha', 'Inmovilización; analgesia IV.', 'EGRESADO', NULL, 'Ana Lopez', 'Marta Ramírez', 'TRASLADO', 'Trasladado a Hospital Roosevelt para manejo por traumatología.', 'Ana Lopez');
    UPDATE recursos_hospitalarios r SET
      total = (SELECT COUNT(*) FROM camas c WHERE c.recurso_id = r.id),
      disponible = (SELECT COUNT(*) FROM camas c WHERE c.recurso_id = r.id AND c.estado = 'DISPONIBLE')
      WHERE r.tipo = 'cama' AND r.id IN (SELECT DISTINCT recurso_id FROM camas);
    -- Categorías de camas repetidas (sin censo) se quitan para que los totales no se dupliquen
    DELETE FROM recursos_hospitalarios WHERE tipo = 'cama' AND descripcion IN ('Camas área general', 'Camas de pediatría', 'Camas de cuidados intensivos')
      AND id NOT IN (SELECT DISTINCT recurso_id FROM camas);
    SELECT 'Hospitalización de demostración cargada' AS resultado;
  END IF;

  -- Caja: catálogo de servicios, medicamentos de uso hospitalario y cuentas de los pacientes
  IF (SELECT COUNT(*) FROM cuentas_paciente) = 0 AND (SELECT COUNT(*) FROM camas) > 0
     AND (SELECT COUNT(*) FROM pacientes WHERE cui = '2501123450102') > 0 THEN
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'CAMA-GEN', 'Día cama — Medicina general', 'DIA_CAMA', 150.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'CAMA-GEN');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'CAMA-PED', 'Día cama — Pediatría', 'DIA_CAMA', 150.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'CAMA-PED');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'CAMA-UCI', 'Día cama — Cuidados intensivos', 'DIA_CAMA', 600.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'CAMA-UCI');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-001', 'Hematología completa', 'LABORATORIO', 45.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-001');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-002', 'Química sanguínea (glucosa, creatinina, BUN)', 'LABORATORIO', 60.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-002');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-003', 'Examen general de orina', 'LABORATORIO', 30.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-003');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-004', 'Urocultivo', 'LABORATORIO', 75.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-004');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-005', 'Troponina I', 'LABORATORIO', 120.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-005');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-006', 'Electrolitos séricos', 'LABORATORIO', 70.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-006');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'LAB-007', 'Glucometría capilar', 'LABORATORIO', 10.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'LAB-007');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'IMG-001', 'Rayos X de tórax', 'IMAGEN', 125.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'IMG-001');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'IMG-002', 'Ultrasonido abdominal', 'IMAGEN', 250.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'IMG-002');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'IMG-003', 'Electrocardiograma', 'IMAGEN', 90.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'IMG-003');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'IMG-004', 'Rayos X de extremidad', 'IMAGEN', 110.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'IMG-004');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-001', 'Curación de herida', 'PROCEDIMIENTO', 40.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-001');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-002', 'Nebulización', 'PROCEDIMIENTO', 25.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-002');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-003', 'Colocación de vía periférica', 'PROCEDIMIENTO', 35.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-003');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-004', 'Apendicectomía (uso de sala de operaciones)', 'PROCEDIMIENTO', 1800.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-004');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-005', 'Colecistectomía laparoscópica (uso de sala de operaciones)', 'PROCEDIMIENTO', 2200.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-005');
    INSERT INTO servicios (codigo, nombre, categoria, costo, estado) SELECT 'PRO-006', 'Inmovilización con férula', 'PROCEDIMIENTO', 150.00, 'ACTIVO' FROM DUAL
      WHERE NOT EXISTS (SELECT 1 FROM servicios WHERE codigo = 'PRO-006');
    IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-016') = 0 THEN
      INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ('MED-016', 'Ceftriaxona', 'Vial 1 g', 120, 40, 18.00);
      INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) VALUES (LAST_INSERT_ID(), 'ENTRADA', 120, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Compra para encamamiento', 'farmacia1');
    END IF;
    IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-017') = 0 THEN
      INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ('MED-017', 'Insulina NPH', 'Frasco 10 ml, 100 UI/ml', 25, 10, 95.00);
      INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) VALUES (LAST_INSERT_ID(), 'ENTRADA', 25, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Compra para encamamiento', 'farmacia1');
    END IF;
    IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-018') = 0 THEN
      INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ('MED-018', 'Solución salina 0.9 %', 'Bolsa 1000 ml', 300, 100, 12.00);
      INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) VALUES (LAST_INSERT_ID(), 'ENTRADA', 300, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Compra para encamamiento', 'farmacia1');
    END IF;
    IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-019') = 0 THEN
      INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ('MED-019', 'Ciprofloxacina', 'Bolsa IV 400 mg/200 ml', 60, 20, 45.00);
      INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) VALUES (LAST_INSERT_ID(), 'ENTRADA', 60, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Compra para encamamiento', 'farmacia1');
    END IF;
    IF (SELECT COUNT(*) FROM medicamentos WHERE codigo = 'MED-020') = 0 THEN
      INSERT INTO medicamentos (codigo, nombre, presentacion, existencia, stock_minimo, precio) VALUES ('MED-020', 'Ácido acetilsalicílico', 'Tableta 100 mg', 600, 200, 0.15);
      INSERT INTO movimientos_inventario (id_medicamento, tipo_movimiento, cantidad, fecha, observacion, usuario) VALUES (LAST_INSERT_ID(), 'ENTRADA', 600, DATE_SUB(NOW(), INTERVAL 20 DAY), 'Compra para encamamiento', 'farmacia1');
    END IF;
    SET @ref = (SELECT COALESCE(MAX(n), 0) FROM (
      SELECT CAST(SUBSTRING(numero_referencia, 10) AS UNSIGNED) AS n FROM citas_medicas WHERE numero_referencia LIKE CONCAT('SAL-', YEAR(CURDATE()), '-%')
      UNION ALL SELECT CAST(SUBSTRING(numero_referencia, 10) AS UNSIGNED) FROM cuentas_paciente WHERE numero_referencia LIKE CONCAT('SAL-', YEAR(CURDATE()), '-%')) r);
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2507890120103' AND h.estado = 'ACTIVO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2507890120103'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), (SELECT sala FROM hospitalizaciones WHERE id_hospitalizacion = @hosp));
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '09:10:00'), id_servicio FROM servicios WHERE codigo = 'LAB-002';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '09:10:00'), id_servicio FROM servicios WHERE codigo = 'LAB-006';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '08:40:00'), id_servicio FROM servicios WHERE codigo = 'PRO-003';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 8, costo, costo * 8, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '20:00:00'), id_servicio FROM servicios WHERE codigo = 'LAB-007';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 1, precio, precio * 1, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '10:00:00') FROM medicamentos WHERE codigo = 'MED-017';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 3, precio, precio * 3, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -3 DAY), '10:00:00') FROM medicamentos WHERE codigo = 'MED-018';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2518901230103' AND h.estado = 'ACTIVO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2518901230103'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), (SELECT sala FROM hospitalizaciones WHERE id_hospitalizacion = @hosp));
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '10:20:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '10:30:00'), id_servicio FROM servicios WHERE codigo = 'IMG-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 6, costo, costo * 6, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '18:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-002';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 2, precio, precio * 2, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '11:00:00') FROM medicamentos WHERE codigo = 'MED-016';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 2, precio, precio * 2, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '11:00:00') FROM medicamentos WHERE codigo = 'MED-018';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2505678900101' AND h.estado = 'ACTIVO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2505678900101'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), (SELECT sala FROM hospitalizaciones WHERE id_hospitalizacion = @hosp));
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '15:10:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '15:10:00'), id_servicio FROM servicios WHERE codigo = 'LAB-003';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '15:10:00'), id_servicio FROM servicios WHERE codigo = 'LAB-004';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '15:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-003';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 2, precio, precio * 2, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '16:00:00') FROM medicamentos WHERE codigo = 'MED-019';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 2, precio, precio * 2, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '16:00:00') FROM medicamentos WHERE codigo = 'MED-018';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2514567890104' AND h.estado = 'ACTIVO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2514567890104'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), (SELECT sala FROM hospitalizaciones WHERE id_hospitalizacion = @hosp));
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '11:30:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '11:40:00'), id_servicio FROM servicios WHERE codigo = 'IMG-002';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '14:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-004';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '07:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 1, precio, precio * 1, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -1 DAY), '17:00:00') FROM medicamentos WHERE codigo = 'MED-016';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2513456780101' AND h.estado = 'ACTIVO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2513456780101'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), (SELECT sala FROM hospitalizaciones WHERE id_hospitalizacion = @hosp));
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 2, costo, costo * 2, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '21:50:00'), id_servicio FROM servicios WHERE codigo = 'LAB-005';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 2, costo, costo * 2, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '21:50:00'), id_servicio FROM servicios WHERE codigo = 'IMG-003';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '21:55:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 2, precio, precio * 2, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -2 DAY), '22:10:00') FROM medicamentos WHERE codigo = 'MED-020';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2504567890106' AND h.estado = 'EGRESADO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2504567890106'), 0, 'POR_COBRAR', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:00:00'), 'Marta Ramírez', 'Roberto Méndez', NULL, NULL);
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -12 DAY), '10:40:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -12 DAY), '10:40:00'), id_servicio FROM servicios WHERE codigo = 'LAB-006';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 3, precio, precio * 3, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -12 DAY), '11:00:00') FROM medicamentos WHERE codigo = 'MED-018';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', 'DIA_CAMA', CONCAT(nombre, ' (2 días)'), 2, costo, costo * 2, 'Ana Lopez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -10 DAY), '11:00:00'), id_servicio FROM servicios WHERE codigo = 'CAMA-PED';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
      SET @ref = @ref + 1;
      UPDATE cuentas_paciente SET numero_referencia = CONCAT('SAL-', YEAR(CURDATE()), '-', LPAD(@ref, 6, '0')),
        estado_cobro = 'PENDIENTE', fecha_vencimiento = DATE_ADD(CURDATE(), INTERVAL 5 DAY) WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2510123450103' AND h.estado = 'EGRESADO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2510123450103'), 0, 'PAGADA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -16 DAY), '12:00:00'), 'Marta Ramírez', 'Roberto Méndez', NULL, NULL);
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -20 DAY), '09:00:00'), id_servicio FROM servicios WHERE codigo = 'LAB-001';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -20 DAY), '09:00:00'), id_servicio FROM servicios WHERE codigo = 'LAB-002';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -20 DAY), '09:30:00'), id_servicio FROM servicios WHERE codigo = 'IMG-002';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -18 DAY), '08:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-005';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha)
        SELECT @cuenta, 'CARGO', 'MEDICAMENTO', CONCAT(nombre, ' — ', presentacion), 4, precio, precio * 4, 'Silvia Ordóñez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -18 DAY), '12:00:00') FROM medicamentos WHERE codigo = 'MED-016';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', 'DIA_CAMA', CONCAT(nombre, ' (4 días)'), 4, costo, costo * 4, 'Ana Lopez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -16 DAY), '12:00:00'), id_servicio FROM servicios WHERE codigo = 'CAMA-GEN';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
      SET @ref = @ref + 1;
      UPDATE cuentas_paciente SET numero_referencia = CONCAT('SAL-', YEAR(CURDATE()), '-', LPAD(@ref, 6, '0')),
        estado_cobro = 'PAGADO', fecha_vencimiento = DATE_ADD(CURDATE(), INTERVAL 0 DAY) WHERE id_cuenta = @cuenta;
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, monto, usuario, fecha)
        SELECT @cuenta, 'PAGO', 'PAGO', CONCAT('Pago en Tributario, referencia ', numero_referencia, ', autorización AUT-58210447'), saldo, 'Tributario', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -15 DAY), '10:00:00') FROM cuentas_paciente WHERE id_cuenta = @cuenta;
      UPDATE cuentas_paciente SET saldo = 0, numero_autorizacion = 'AUT-58210447', fecha_pago = TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -15 DAY), '10:00:00') WHERE id_cuenta = @cuenta;
    END IF;
    SET @hosp = (SELECT h.id_hospitalizacion FROM hospitalizaciones h JOIN pacientes p ON p.id = h.id_paciente WHERE p.cui = '2519012340101' AND h.estado = 'EGRESADO' ORDER BY h.id_hospitalizacion LIMIT 1);
    IF @hosp IS NOT NULL THEN
      INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, hospitalizacion_id, fecha_apertura, fecha_cierre, abierta_por, cerrada_por, tramo_inicio, tramo_area)
        VALUES ((SELECT id FROM pacientes WHERE cui = '2519012340101'), 0, 'ABIERTA', 'HOSPITALIZACION', @hosp, (SELECT fecha_asignacion FROM hospitalizaciones WHERE id_hospitalizacion = @hosp), NULL, 'Marta Ramírez', NULL, NULL, NULL);
      SET @cuenta = LAST_INSERT_ID();
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -8 DAY), '19:40:00'), id_servicio FROM servicios WHERE codigo = 'IMG-004';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo * 1, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -8 DAY), '20:00:00'), id_servicio FROM servicios WHERE codigo = 'PRO-006';
      INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
        SELECT @cuenta, 'CARGO', 'DIA_CAMA', CONCAT(nombre, ' (1 día)'), 1, costo, costo * 1, 'Ana Lopez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL -7 DAY), '09:00:00'), id_servicio FROM servicios WHERE codigo = 'CAMA-GEN';
      UPDATE cuentas_paciente SET saldo = (SELECT COALESCE(SUM(CASE WHEN tipo_movimiento = 'CARGO' THEN monto ELSE -monto END), 0) FROM movimientos_cuenta WHERE id_cuenta = @cuenta AND anulado = 0) WHERE id_cuenta = @cuenta;
    END IF;
    INSERT INTO cuentas_paciente (id_paciente, saldo, estado, tipo, fecha_apertura, abierta_por) VALUES ((SELECT id FROM pacientes WHERE cui = '2515678900107'), 0, 'ABIERTA', 'AMBULATORIA', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '07:30:00'), 'Roberto Méndez');
    SET @cuenta = LAST_INSERT_ID();
    INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
      SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '07:35:00'), id_servicio FROM servicios WHERE codigo = 'IMG-002';
    INSERT INTO movimientos_cuenta (id_cuenta, tipo_movimiento, categoria, descripcion, cantidad, precio_unitario, monto, usuario, fecha, servicio_id)
      SELECT @cuenta, 'CARGO', categoria, nombre, 1, costo, costo, 'Roberto Méndez', TIMESTAMP(DATE_ADD(CURDATE(), INTERVAL 0 DAY), '07:35:00'), id_servicio FROM servicios WHERE codigo = 'LAB-002';
    UPDATE cuentas_paciente SET saldo = (SELECT SUM(monto) FROM movimientos_cuenta WHERE id_cuenta = @cuenta) WHERE id_cuenta = @cuenta;
    SELECT 'Caja de demostración cargada' AS resultado;
  END IF;
END //
DELIMITER ;

CALL cargar_datos_demo();
DROP PROCEDURE cargar_datos_demo;
