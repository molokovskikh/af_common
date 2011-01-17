update `documents`.`DocumentHeaders`
set
  OrderId = null
where
  OrderId = 0;

alter table `documents`.`DocumentHeaders`
  add CONSTRAINT `FK_DocumentHeaders_AddressId` FOREIGN KEY (`AddressId`) REFERENCES `future`.`addresses` (`Id`) ON DELETE SET NULL,
  add CONSTRAINT `FK_DocumentHeaders_ClientCode` FOREIGN KEY (`ClientCode`) REFERENCES `usersettings`.`retclientsset` (`ClientCode`) ON DELETE SET NULL ON UPDATE CASCADE,
  add CONSTRAINT `FK_DocumentHeaders_OrderId` FOREIGN KEY (`OrderId`) REFERENCES `orders`.`OrdersHead` (`RowId`) ON DELETE SET NULL;
