alter table usersettings.RetClientsSet 
  drop column Spy;

alter table logs.RetClientsSetLogs
  drop column AllowDelayOfPayment,
  drop column Spy;
