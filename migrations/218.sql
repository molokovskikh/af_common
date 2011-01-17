alter table usersettings.RetClientsSet
  add column `ParseWaybills` tinyint(1) unsigned not null default 0,
  add column `SendRetailMarkup` tinyint(1) unsigned not null default 0;