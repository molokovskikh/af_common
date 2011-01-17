alter table logs.RetClientsSetLogs
  add column ShowNewDefecture tinyint(1) unsigned default null,
  add column MigrateToPrgDataService tinyint(1) unsigned default null;