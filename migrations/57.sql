create database future;

CREATE TABLE  future.Users (
  Id int unsigned NOT NULL AUTO_INCREMENT,
  ClientId int unsigned NOT NULL,
  Login varchar(20) not null,
  Name varchar(100) not null,
  SendRejects tinyint(1) unsigned not null default 1,
  SendWaybills tinyint(1) unsigned not null default 1,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE future.UserAddresses (
  UserId int unsigned not null,
  AddressId int unsigned not null,
  primary key (userId, addressId)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

create table future.UserPrices (
  UserId int unsigned not null,
  PriceId int unsigned not null,
  PRIMARY KEY (UserId, PriceId)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE future.Addresses (
  Id int unsigned NOT NULL AUTO_INCREMENT,
  LegacyId int unsigned,
  ClientId int unsigned NOT NULL,
  Address varchar(100) NOT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

create table future.Intersection
(
  Id int unsigned not null auto_increment,

  ClientId int unsigned not null,
  RegionId bigint unsigned not null,
  PriceId int unsigned not null,
  CostId int unsigned not null,

  AvailableForClient tinyint(1) unsigned not null default '0',
  PriceMarkup decimal(5, 3) not null default '0',
  SupplierClientId varchar(200),
  SupplierPaymentId varchar(20),

  ControlMinReq tinyint(1) unsigned not null default '0',
  MinReq int unsigned,
  primary key(ClientId, RegionId, PriceId),
  unique key(id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

create table future.AddressIntersection
(
  Id int unsigned not null auto_increment,
  AddressId int unsigned not null,
  IntersectionId int unsigned not null,
  SupplierDeliveryId varchar(20),

  primary key(Id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

CREATE TABLE  future.Clients (
  Id int unsigned not null auto_increment,
  Status tinyint(1) unsigned NOT NULL DEFAULT '1',
  Segment tinyint(1) unsigned NOT NULL DEFAULT '0',
  PayerId int unsigned not null,
  RegionCode bigint unsigned not null,
  MaskRegion bigint unsigned not null,
  ShowRegionMask bigint unsigned not null,
  Name varchar(50) not null,
  FullName varchar(40) not null,
  Registrant varchar(100) DEFAULT NULL,
  RegistrationDate timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ContactGroupOwnerId int unsigned DEFAULT NULL,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

alter table usersettings.AnalitFReplicationInfo
drop foreign key FK_AnalitFReplicationInfo_1;

alter table usersettings.AssignedPermissions
drop foreign key FK_AssignedPermissions_UserId;

alter table usersettings.UserUpdateInfo
drop foreign key FK_UserUpdateInfo_UserId;

alter table usersettings.RetClientsSet drop foreign key retclientsset_ibfk_1;
alter table usersettings.ret_save_grids drop foreign key FK_ret_save_grids_ClientCode;

alter table Usersettings.DelayOfPayments rename to SupplierIntersection;
alter table SupplierIntersection
change column Percent DelayOfPayment decimal(5, 3) not null default 0,
add column SupplierCategory int(1) unsigned not null default 0;
