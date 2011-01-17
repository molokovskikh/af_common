alter table catalogs.CatalogNames
  drop FOREIGN KEY `FK_CatalogNames_DescriptionId`;

alter table catalogs.CatalogNames
  drop column `DescriptionId`;
