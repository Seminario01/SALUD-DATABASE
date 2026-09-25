-- ============================================================
-- Migracion: de Cognito (tabla usuarios_roles) al Login Unico (Keycloak)
-- ============================================================
-- Usar SOLO si ya tienen la base salud_db creada con el schema anterior.
-- Si crean la base desde cero, basta con schema.sql + "datos insertados.sql".
--
-- Que hace:
--   1. Quita las llaves foraneas que apuntan a usuarios_roles.
--   2. Cambia los ids de usuario (INT) por el `sub` del Login Unico (VARCHAR 36).
--   3. Elimina la tabla usuarios_roles.
-- Los valores viejos de medico_id / usuario_id se pierden: apuntaban a usuarios
-- de prueba de Cognito que ya no existen.
--
-- Ejecutar:  mysql -u root -p < migracion_keycloak.sql
-- ============================================================

USE salud_db;

DELIMITER //

DROP PROCEDURE IF EXISTS quitar_fk_usuarios_roles //
CREATE PROCEDURE quitar_fk_usuarios_roles()
BEGIN
    DECLARE fin INT DEFAULT 0;
    DECLARE v_tabla VARCHAR(64);
    DECLARE v_fk VARCHAR(64);
    DECLARE cur CURSOR FOR
        SELECT TABLE_NAME, CONSTRAINT_NAME
        FROM information_schema.KEY_COLUMN_USAGE
        WHERE TABLE_SCHEMA = DATABASE()
          AND REFERENCED_TABLE_NAME = 'usuarios_roles';
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = 1;

    OPEN cur;
    ciclo: LOOP
        FETCH cur INTO v_tabla, v_fk;
        IF fin = 1 THEN LEAVE ciclo; END IF;
        SET @sql = CONCAT('ALTER TABLE `', v_tabla, '` DROP FOREIGN KEY `', v_fk, '`');
        PREPARE stmt FROM @sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
    END LOOP;
    CLOSE cur;
END //

DELIMITER ;

CALL quitar_fk_usuarios_roles();
DROP PROCEDURE quitar_fk_usuarios_roles;

-- pacientes: usuario_id -> usuario_sub
ALTER TABLE pacientes
    ADD COLUMN usuario_sub VARCHAR(36) NULL UNIQUE AFTER id,
    DROP COLUMN usuario_id;

-- citas_medicas: medico_id -> medico_sub
ALTER TABLE citas_medicas
    ADD COLUMN medico_sub VARCHAR(36) NULL AFTER paciente_id,
    DROP COLUMN medico_id;

-- expedientes_clinicos: medico_id -> medico_sub
ALTER TABLE expedientes_clinicos
    ADD COLUMN medico_sub VARCHAR(36) NULL AFTER cita_id,
    DROP COLUMN medico_id;

-- auditoria: id_usuario -> usuario_sub
ALTER TABLE auditoria
    ADD COLUMN usuario_sub VARCHAR(36) NULL AFTER id_auditoria,
    DROP COLUMN id_usuario;

DROP TABLE usuarios_roles;
