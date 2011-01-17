create table logs.SpyInfo
(
  Id int unsigned not null AUTO_INCREMENT,
  UserId int unsigned not null,
  LogTime timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  Login varchar(255) default null,
  Password varchar(255) default null,
  OriginalPassword varchar(255) default null,
  SerialNumber varchar(8) default null,
  MaxWriteTime DateTime default null,
  MaxWriteFileName varchar(255) default null,
  OrderWriteTime DateTime default null,
  ClientTimeZoneBias int default null,
  PRIMARY KEY (Id),
  Key(UserId),
  Key(LogTime)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
