﻿ALTER TABLE `future`.`Addresses` ADD COLUMN `Enabled` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0 - Выкл.
1 - Вкл.' AFTER `ClientId`;