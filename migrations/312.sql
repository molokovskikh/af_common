alter table logs.RetClientsSetLogs
  add column `OnlyParseWaybills` tinyint(1) unsigned default null,
  add column `UpdateToTestBuild` tinyint(1) unsigned default null,
  add column `EnableSmartOrder` tinyint(1) unsigned default null;
alter table usersettings.RetClientsSet
  add column `EnableSmartOrder` tinyint(1) unsigned not null default 0 comment 'Доступен ли АвтоЗаказ клиенту в AnalitF?';