alter table `catalogs`.`Mnn` 
  add column `RussianMnn` varchar(255) default null,
  add index (RussianMnn);
