alter table `catalogs`.`Mnn`
  add column UpdateTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;