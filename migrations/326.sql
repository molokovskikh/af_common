alter table farm.BuyingMatrix
  drop column AssortmentId,
  add column CatalogId int unsigned not null,
  add column ProducerId int unsigned default null,
  add constraint FK_BuyingMatrix_CatalogId foreign key (CatalogId) references catalogs.Catalog(Id) on delete cascade,
  add constraint FK_BuyingMatrix_ProducerId foreign key (ProducerId) references catalogs.Producers(Id) on delete set null;