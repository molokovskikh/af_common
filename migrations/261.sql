create table future.ClientToAddressMigrations
(
  `UserId` int unsigned not null,
  `ClientCode` int unsigned not null,
  `AddressId` int unsigned not null,
  CONSTRAINT `FK_ClientToAddressMigrations_UserId` FOREIGN KEY (`UserId`) REFERENCES future.`users` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_ClientToAddressMigrations_AddressId` FOREIGN KEY (`AddressId`) REFERENCES future.`addresses` (`Id`) ON DELETE CASCADE ON UPDATE CASCADE
);