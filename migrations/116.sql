ALTER TABLE usersettings.RetClientsSet ADD ShowNewDefecture TINYINT(1) UNSIGNED NOT NULL DEFAULT 1;
UPDATE usersettings.RetClientsSet SET ShowNewDefecture = 0;