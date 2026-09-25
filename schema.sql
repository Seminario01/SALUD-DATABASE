CREATE DATABASE IF NOT EXISTS salud_db;
USE salud_db;

-- ============================================================
-- Modulo: Gestion de usuarios y pacientes
-- ============================================================

-- No hay tabla de usuarios: los usuarios viven en el Login Unico (Keycloak).
-- Cada registro que necesita un usuario guarda su `sub` (UUID de 36 caracteres),
-- que es unico e inmutable. Nunca se usa el email como llave.

CREATE TABLE pacientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_sub VARCHAR(36) NULL UNIQUE,  -- sub del ciudadano en el Login Unico
    cui VARCHAR(20),
    nombre_completo VARCHAR(200) NOT NULL,
    fecha_nacimiento DATE,
    genero VARCHAR(20),
    telefono VARCHAR(20),
    tipo_seguro VARCHAR(50),
    cuidador VARCHAR(200),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- Modulo: Citas y expedientes clinicos
-- ============================================================

CREATE TABLE citas_medicas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    medico_sub VARCHAR(36),  -- sub del medico en el Login Unico
    fecha_hora DATETIME NOT NULL,
    estado ENUM('pendiente', 'confirmada', 'atendida', 'cancelada') DEFAULT 'pendiente',
    motivo VARCHAR(300),
    costo DECIMAL(10,2),
    pago_confirmado BOOLEAN DEFAULT FALSE,
    fecha_creacion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id)
);

CREATE TABLE expedientes_clinicos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT NOT NULL,
    cita_id INT NULL,
    medico_sub VARCHAR(36),  -- sub del medico en el Login Unico
    diagnostico TEXT,
    tratamiento TEXT,
    notas TEXT,
    fecha_atencion DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (paciente_id) REFERENCES pacientes(id),
    FOREIGN KEY (cita_id) REFERENCES citas_medicas(id)
);

-- ============================================================
-- Modulo: Recursos hospitalarios y turnos
-- ============================================================

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

-- ============================================================
-- Modulo: Presupuesto y vacunacion
-- ============================================================

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

-- ============================================================
-- Modulo: Catalogos generales
-- ============================================================

CREATE TABLE areas_hospital (
    id_area INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE especialidades (
    id_especialidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT
);

CREATE TABLE medicamentos (
    id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    existencia INT NOT NULL DEFAULT 0,
    stock_minimo INT DEFAULT 10,
    precio DECIMAL(10,2)
);

CREATE TABLE medicos (
    id_medico INT AUTO_INCREMENT PRIMARY KEY,
    colegiado VARCHAR(50) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

CREATE TABLE practicantes (
    id_practicante INT AUTO_INCREMENT PRIMARY KEY,
    dpi VARCHAR(20) NOT NULL UNIQUE,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    universidad VARCHAR(100),
    carrera VARCHAR(100),
    fecha_inicio DATE,
    fecha_fin DATE,
    supervisor VARCHAR(100),
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

CREATE TABLE servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    costo DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'ACTIVO'
);

CREATE TABLE vacunas (
    id_vacuna INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    dosis_requeridas INT NOT NULL
);

-- ============================================================
-- Modulo: Auditoria, cuentas, historial y hospitalizaciones
-- ============================================================

CREATE TABLE auditoria (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
    usuario_sub VARCHAR(36),  -- sub del usuario en el Login Unico
    modulo VARCHAR(100),
    accion VARCHAR(50),
    tabla_afectada VARCHAR(100),
    registro_id INT,
    descripcion TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cuentas_paciente (
    id_cuenta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    saldo DECIMAL(10,2) DEFAULT 0.00,
    estado VARCHAR(20) DEFAULT 'ACTIVA',
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id)
);

CREATE TABLE historial_medico (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    diagnostico TEXT,
    tratamiento TEXT,
    observaciones TEXT,
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

CREATE TABLE hospitalizaciones (
    id_hospitalizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
    fecha_egreso DATETIME NULL,
    sala VARCHAR(50),
    cama VARCHAR(20),
    diagnostico TEXT,
    estado VARCHAR(20) DEFAULT 'ACTIVO',
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id)
);

CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (id_medico) REFERENCES medicos(id_medico)
);

-- ============================================================
-- Modulo: Detalle de recetas, practicas y movimientos
-- ============================================================

CREATE TABLE detalle_receta (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_receta INT NOT NULL,
    id_medicamento INT NOT NULL,
    cantidad INT NOT NULL,
    FOREIGN KEY (id_receta) REFERENCES recetas(id_receta),
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)
);

CREATE TABLE horas_practica (
    id_hora INT AUTO_INCREMENT PRIMARY KEY,
    id_practicante INT NOT NULL,
    fecha DATE NOT NULL,
    horas INT NOT NULL,
    actividad TEXT,
    FOREIGN KEY (id_practicante) REFERENCES practicantes(id_practicante)
);

CREATE TABLE movimientos_cuenta (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_cuenta INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    descripcion TEXT,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_cuenta) REFERENCES cuentas_paciente(id_cuenta)
);

CREATE TABLE movimientos_inventario (
    id_movimiento INT AUTO_INCREMENT PRIMARY KEY,
    id_medicamento INT NOT NULL,
    tipo_movimiento VARCHAR(20) NOT NULL,
    cantidad INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    observacion TEXT,
    FOREIGN KEY (id_medicamento) REFERENCES medicamentos(id_medicamento)
);

-- ============================================================
-- Modulo: Integracion externa - establecimientos de salud (WS-SALUD-02)
-- ============================================================

CREATE TABLE establecimientos (
    id_establecimiento INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    tipo VARCHAR(50),
    direccion VARCHAR(250),
    departamento VARCHAR(100),
    municipio VARCHAR(100),
    telefono VARCHAR(20),
    estado_servicio VARCHAR(50) DEFAULT 'ACTIVO',
    tipo_atencion_disponible VARCHAR(150)
);


/*DROP DATABASE IF EXISTS salud_db;*/