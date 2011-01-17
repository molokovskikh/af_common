ALTER TABLE usersettings.UserPermissions ADD Type SMALLINT UNSIGNED NOT NULL DEFAULT 0;
ALTER TABLE usersettings.UserPermissions ADD AssignDefaultValue TINYINT(1) UNSIGNED NOT NULL DEFAULT 0;