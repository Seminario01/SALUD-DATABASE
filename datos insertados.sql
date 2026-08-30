USE salud_db;

INSERT INTO usuarios_roles (cognito_sub, email, rol, nombre_completo, cui, activo) VALUES
('sub-prueba-001', 'admin@prueba.com', 'admin', 'Admin de Prueba', '1234567890101', 1),
('sub-prueba-002', 'medico@prueba.com', 'medico', 'Dr. Prueba', '2234567890101', 1);

INSERT INTO pacientes (cui, nombre_completo, fecha_nacimiento, genero, telefono, tipo_seguro) VALUES
('3234567890101', 'Paciente de Prueba', '2000-01-15', 'M', '55551234', 'IGSS'),
('4234567890101', 'Segundo Paciente', '1995-05-20', 'F', '55555678', 'Privado');

USE salud_db;

INSERT INTO pacientes (cui, nombre_completo, fecha_nacimiento, genero, telefono, tipo_seguro) VALUES
('4234567890101', 'Segundo Paciente', '1995-05-20', 'F', '55555678', 'Privado');

INSERT INTO citas_medicas (paciente_id, medico_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES
(2, 2, '2026-08-25 10:00:00', 'confirmada', 'Consulta general', 150.00, 0);

INSERT INTO citas_medicas (paciente_id, medico_id, fecha_hora, estado, motivo, costo, pago_confirmado) VALUES
(1, 2, '2026-08-25 09:00:00', 'confirmada', 'Consulta general', 150.00, 0),
(2, 2, '2026-08-25 10:00:00', 'confirmada', 'Consulta general', 150.00, 0);


INSERT INTO recursos_hospitalarios (tipo, descripcion, disponible, total) VALUES
('cama', 'Camas área general', 12, 20);

INSERT INTO vacunacion (paciente_id, es_estudiante, esquema_completo, vacunas_pendientes) VALUES
(1, 1, 0, 'Refuerzo COVID, Influenza');

INSERT INTO presupuesto_hospitalario (periodo, monto_asignado, monto_ejecutado_servicio_social, descripcion) VALUES
('2026-Q3', 500000.00, 187500.00, 'Presupuesto trimestral hospital');