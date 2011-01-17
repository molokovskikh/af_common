alter table usersettings.RetClientsSet
  add column `NetworkSupplierId` int(10) unsigned default null,
  add CONSTRAINT `FK_RetClientsSet_NetworkSupplierId` FOREIGN KEY (`NetworkSupplierId`) REFERENCES `clientsdata` (`FirmCode`) ON DELETE SET NULL;