alter table usersettings.RetClientsSet
  add column `SendWaybillsFromClient` tinyint(1) unsigned not null default 0 comment 'Разрешено ли с клиента отправлять накладные для разбора?';
