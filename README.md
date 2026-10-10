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

## Scripts

| Archivo | Qué hace |
|---|---|
| `schema.sql` | Crea la base `salud_db` y todas las tablas (utf8mb4). |
| `datos insertados.sql` | Datos mínimos del equipo. |
| `datos_demo.sql` | Datos **ficticios** para la presentación: 20 pacientes, 24 citas (pasadas, de hoy y próximas), 8 atenciones, 12 registros de vacunación, recursos, presupuesto 2026-Q4 y establecimientos. Las fechas son relativas al día de carga. Se puede correr varias veces (si ya están, no hace nada). |
| `demo_turnos_hoy.sql` | Turnos ficticios del día (sala de espera). Correrlo el día de la presentación. |
| `migracion_keycloak.sql` | Solo para bases viejas: pasa de `usuarios_roles` al `sub` del Login Único. |

Los usuarios **no** están en la base: viven en el Login Único (Keycloak). Un paciente se vincula a un ciudadano guardando su `sub` en `pacientes.usuario_sub` (el ciudadano ve su código en "Mi resumen" y el personal lo pega en la ficha del paciente).

Carga local:

```bash
mysql -u root -p < schema.sql
mysql -u root -p < "datos insertados.sql"
mysql -u root -p < datos_demo.sql
mysql -u root -p < demo_turnos_hoy.sql
```

## Integraciones

- Educacion
- Seguridad
- Tributario
- Auditoria Social
