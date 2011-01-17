alter table catalogs.CatalogNames
  add column `DescriptionId` INTEGER UNSIGNED default null,
  add constraint `FK_CatalogNames_DescriptionId` FOREIGN KEY `FK_CatalogNames_DescriptionId` (`DescriptionId`)
   REFERENCES catalogs.Descriptions (`Id`)
   ON DELETE set null
   ON UPDATE RESTRICT;