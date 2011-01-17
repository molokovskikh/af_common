alter table logs.RetClientsSetLogs
  add column `ManualComparison` tinyint(1) unsigned default null,
  add column `ParseWaybills` tinyint(1) unsigned default null,
  add column `SendRetailMarkup` tinyint(1) unsigned default null,
  add column `ShowAdvertising` tinyint(1) unsigned default null,
  add column `IgnoreNewPrices` tinyint(1) unsigned default null,
  add column `SendWaybillsFromClient` tinyint(1) unsigned default null;

