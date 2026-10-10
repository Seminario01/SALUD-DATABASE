# Sistema Nacional de Salud

Proyecto desarrollado para el Seminario de Graduación.

## Modulos

- Administracion
- Pacientes
- Medicos
- Citas
- Expedientes Clinicos / Historial Medico
- Hospitalizacion
- Vacunacion
- Farmacia
- Practicantes
- Turnos
- Presupuesto y Auditoria
- Facturacion

## Base de Datos

Motor: MySQL

## Tablas

### Nucleo del modulo (usadas por la API)

- usuarios_roles
- pacientes
- citas_medicas
- expedientes_clinicos
- recursos_hospitalarios
- turnos
- presupuesto_hospitalario
- vacunacion

### Ampliacion: catalogos

- areas_hospital
- especialidades
- medicamentos
- medicos
- practicantes
- servicios
- vacunas

### Ampliacion: registros

- auditoria
- cuentas_paciente
- historial_medico
- hospitalizaciones
- recetas

### Ampliacion: detalle

- detalle_receta
- horas_practica
- movimientos_cuenta
- movimientos_inventario

## Integraciones

- Educacion
- Seguridad
- Tributario
- Auditoria Social
