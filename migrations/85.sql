alter table usersettings.RetClientsSet 
  add column SpyAccount tinyint(1) unsigned not null default 0;

alter table logs.RetClientsSetLogs
  add column SpyAccount tinyint(1) unsigned default null;