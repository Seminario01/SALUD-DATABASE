-- UTF-8 completo para tildes y ñ (área, vacunación, Peña...)
SET NAMES utf8mb4;
CREATE DATABASE IF NOT EXISTS salud_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
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
    -- Cobro en Tributario (obligación de pago)
    numero_referencia VARCHAR(20) NULL UNIQUE,  -- SAL-AAAA-NNNNNN, lo genera Salud
    estado_cobro VARCHAR(20) NULL,              -- PENDIENTE, PAGADO, ANULADO
    fecha_vencimiento DATE NULL,
    numero_autorizacion VARCHAR(60) NULL,
    fecha_pago DATETIME NULL,
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
    presentacion VARCHAR(100),          -- "Tableta 500 mg", "Jarabe 120 ml"
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

-- Censo de camas: una fila por cama. El total y las disponibles de cada área
-- en recursos_hospitalarios se calculan desde aquí.
CREATE TABLE camas (
    id_cama INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,         -- GEN-01, PED-03, UCI-02
    area VARCHAR(80) NOT NULL,                  -- Medicina general, Pediatría, Cuidados intensivos
    recurso_id INT NULL,
    estado VARCHAR(20) NOT NULL DEFAULT 'DISPONIBLE',   -- DISPONIBLE, OCUPADA, LIMPIEZA, MANTENIMIENTO
    observacion VARCHAR(200) NULL,
    actualizado DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (recurso_id) REFERENCES recursos_hospitalarios(id)
);

-- PENDIENTE (orden del médico) -> ACTIVO (Enfermería asignó cama) -> EGRESADO; o ANULADO
CREATE TABLE hospitalizaciones (
    id_hospitalizacion INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,            -- fecha de la orden de ingreso
    fecha_egreso DATETIME NULL,
    sala VARCHAR(50),                           -- área
    cama VARCHAR(20),                           -- código de la cama
    cama_id INT NULL,
    diagnostico TEXT,
    indicaciones TEXT NULL,
    estado VARCHAR(20) DEFAULT 'PENDIENTE',
    expediente_id INT NULL,                     -- atención del expediente que originó el ingreso
    medico_sub VARCHAR(36) NULL,
    medico_nombre VARCHAR(150) NULL,
    fecha_asignacion DATETIME NULL,             -- cuando se asignó la cama
    asignado_por VARCHAR(100) NULL,
    tipo_egreso VARCHAR(30) NULL,               -- ALTA, ALTA_VOLUNTARIA, TRASLADO, DEFUNCION
    resumen_egreso TEXT NULL,
    egresado_por VARCHAR(150) NULL,
    motivo_anulacion VARCHAR(255) NULL,
    FOREIGN KEY (id_paciente) REFERENCES pacientes(id),
    FOREIGN KEY (cama_id) REFERENCES camas(id_cama)
);

-- Notas de evolución (médico) y de enfermería, con signos vitales
CREATE TABLE notas_hospitalizacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hospitalizacion_id INT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    autor_sub VARCHAR(36) NULL,
    autor_nombre VARCHAR(150) NULL,
    puesto VARCHAR(30) NULL,
    nota TEXT NOT NULL,
    presion VARCHAR(10) NULL,
    temperatura DECIMAL(4,1) NULL,
    frecuencia_cardiaca INT NULL,
    saturacion INT NULL,
    FOREIGN KEY (hospitalizacion_id) REFERENCES hospitalizaciones(id_hospitalizacion)
);

CREATE TABLE recetas (
    id_receta INT AUTO_INCREMENT PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_medico INT NULL,                 -- opcional: el médico se identifica por su sub
    medico_sub VARCHAR(36) NULL,        -- sub del médico en el Login Único
    medico_nombre VARCHAR(150) NULL,    -- nombre del médico que firma la receta
    expediente_id INT NULL,             -- atención del expediente que originó la receta
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    indicaciones TEXT,
    estado VARCHAR(20) NOT NULL DEFAULT 'PENDIENTE',   -- PENDIENTE, DESPACHADA, ANULADA
    despachado_por VARCHAR(36) NULL,    -- sub de Farmacia
    fecha_despacho DATETIME NULL,
    motivo_anulacion VARCHAR(255) NULL,
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
    dosis VARCHAR(200),                 -- "1 tableta cada 8 horas por 5 días"
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
    receta_id INT NULL,                 -- SALIDA por despacho de una receta
    usuario VARCHAR(100) NULL,
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
-- Bitácora de llamadas entre Salud y los otros módulos (saliente = Salud
-- consulta a otro módulo; entrante = otro módulo consume un servicio de Salud).
-- Los CUI se guardan enmascarados. El backend también la crea si no existe.
CREATE TABLE IF NOT EXISTS bitacora_integraciones (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    direccion ENUM('saliente','entrante') NOT NULL,
    modulo VARCHAR(30) NOT NULL,
    operacion VARCHAR(120) NOT NULL,
    metodo VARCHAR(10) NOT NULL,
    ruta VARCHAR(255) NOT NULL,
    estado_http INT,
    resultado VARCHAR(30) NOT NULL,
    duracion_ms INT,
    simulado BOOLEAN NOT NULL DEFAULT FALSE,
    usuario VARCHAR(100),
    detalle VARCHAR(255),
    INDEX idx_bitacora_fecha (fecha)
);
