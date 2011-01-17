alter table catalogs.Producers
  add column `UpdateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

update
  catalogs.Producers
set
  UpdateTime = '2010-01-01';

