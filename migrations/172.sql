alter table Catalogs.Catalog
add column MandatoryList tinyint(1) unsigned not null default 0 after VitallyIMportant;
