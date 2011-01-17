alter table `documents`.`DocumentHeaders`
  add column `AddressId` int(10) unsigned DEFAULT NULL after `ClientCode`;
