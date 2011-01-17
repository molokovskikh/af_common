alter table `catalogs`.`Descriptions`
  drop column `RawDescription`,
  modify column `Description` mediumtext comment 'В AnalitF обозначается как Дополнительно';
