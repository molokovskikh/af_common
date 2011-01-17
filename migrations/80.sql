alter table usersettings.RetClientsSet 
  add column Spy tinyint(1) unsigned not null default 0,
  modify column AllowDelayOfPayment tinyint(1) unsigned not null default 0;

alter table logs.RetClientsSetLogs
  add column AllowDelayOfPayment tinyint(1) unsigned default null,
  add column Spy tinyint(1) unsigned default null;