alter table logs.SpyInfo
  add column DNSChangedState tinyint(1) default null,
  add column RASEntry varchar(30) default null,
  add column DefaultGateway varchar(15) default null,
  add column IsDynamicDnsEnabled tinyint(1) default null,
  add column ConnectionSettingId varchar(255) default null,
  add column PrimaryDNS varchar(15) default null,
  add column AlternateDNS varchar(15) default null;