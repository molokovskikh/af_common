alter table Catalogs.Catalog
add column Name varchar(255) not null after hidden,
add index Index_Name(Name);