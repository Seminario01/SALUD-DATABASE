-- Base de datos del Módulo de Salud
CREATE DATABASE IF NOT EXISTS salud_db;
USE salud_db;

CREATE TABLE usuarios_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cognito_sub VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    rol ENUM('admin', 'medico', 'paciente', 'recepcion') NOT NULL,
    nombre_completo VARCHAR(200),
    cui VARCHAR(20),
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NULL,
    cui VARCHAR(20),
    nombre_completo VARCHAR(200) NOT NULL,
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    telefono VARCHAR(20),
    tipo_seguro VARCHAR(50),
    cuidador VARCHAR(200),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES usuarios_roles(id)
);

CREATE TABLE citas_medicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_id INT,
    fecha_hora DATETIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'atendida', 'cancelada') DEFAULT 'pendiente',
    motivo VARCHAR(300),
    costo DECIMAL(10,2),
    pago_confirmado BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (medico_id) REFERENCES usuarios_roles(id)
);

CREATE TABLE expedientes_clinicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    cita_id INT NULL,
    medico_id INT,
    diagnostico TEXT,
    tratamiento TEXT,
    notas TEXT,
    fecha_atencion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (cita_id) REFERENCES citas_medicas(id),
    FOREIGN KEY (medico_id) REFERENCES usuarios_roles(id)
);

CREATE TABLE recursos_hospitalarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    tipo ENUM('cama', 'ambulancia', 'cupo_consulta') NOT NULL,
    descripcion VARCHAR(200),
    disponible INT DEFAULT 0,
    total INT DEFAULT 0,
    ultima_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE turnos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    tipo_atencion ENUM('consulta_general', 'emergencia', 'especialidad') NOT NULL,
    numero_turno INT NOT NULL,
    estado ENUM('en_espera', 'llamado', 'en_atencion', 'atendido', 'ausente') DEFAULT 'en_espera',
    prioridad ENUM('normal', 'urgente') DEFAULT 'normal',
    fecha_hora_ingreso DATETIME DEFAULT CURRENT_TIMESTAMP,
    fecha_hora_llamado DATETIME NULL,
    fecha_hora_atencion DATETIME NULL,
    modulo_asignado VARCHAR(50) NULL,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

CREATE TABLE presupuesto_hospitalario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    periodo VARCHAR(20) NOT NULL,
    monto_asignado DECIMAL(12,2) NOT NULL,
    monto_ejecutado_servicio_social DECIMAL(12,2) DEFAULT 0,
    descripcion VARCHAR(300),
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE vacunacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    es_estudiante BOOLEAN DEFAULT FALSE,
    esquema_completo BOOLEAN DEFAULT FALSE,
    vacunas_pendientes TEXT,
    fecha_actualizacion DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);