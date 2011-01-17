alter table logs.SpyInfo
  drop column DNSChangedState,
  drop column RASEntry,
  drop column DefaultGateway,
  drop column IsDynamicDnsEnabled,
  drop column ConnectionSettingId,
  drop column PrimaryDNS,
  drop column AlternateDNS;