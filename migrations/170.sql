alter table Catalogs.Mnn
add index (Mnn);

alter table Catalogs.ProtekCatalog
add column Synonym varchar(255),
add index (Synonym);