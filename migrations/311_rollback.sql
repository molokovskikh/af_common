ALTER TABLE `future`.`Intersection` DROP COLUMN `LegalEntityId`,
 DROP PRIMARY KEY,
 ADD PRIMARY KEY  USING BTREE(`ClientId`, `RegionId`, `PriceId`);