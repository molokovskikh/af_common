create table usersettings.DelayOfPayments
(
  Id Int(10) primary key auto_increment,
  ClientId Int(10) not null,
  SupplierId Int(10) not null references usersettings.ClientsData(FirmCode) on delete cascade on update cascade,
  Percent Decimal(5, 2) not null default 0
);

alter table usersettings.RetClientsSet add AllowDelayOfPayment tinyint(1) not null default 0;
