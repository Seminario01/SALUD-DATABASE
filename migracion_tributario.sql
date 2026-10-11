-- ============================================================
-- Migracion: integracion Salud <-> Tributario
-- ============================================================
-- Usar SOLO si ya tienen la base salud_db creada con el schema anterior.
-- Si crean la base desde cero, basta con schema.sql.
--
-- Agrega a citas_medicas las columnas para registrar la obligacion de pago
-- ante Tributario y la confirmacion de pago que Tributario envia a Salud.
--
-- Ejecutar:  mysql -u root -p < migracion_tributario.sql
-- ============================================================

USE salud_db;

ALTER TABLE citas_medicas
  ADD COLUMN numero_referencia VARCHAR(40) NULL UNIQUE,
  ADD COLUMN referencia_tributario VARCHAR(80) NULL,
  ADD COLUMN numero_autorizacion VARCHAR(80) NULL,
  ADD COLUMN fecha_pago DATETIME NULL,
  ADD COLUMN monto_pagado DECIMAL(10,2) NULL,
  ADD COLUMN evento_pago_id VARCHAR(100) NULL;
