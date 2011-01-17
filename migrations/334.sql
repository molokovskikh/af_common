update
  usersettings.clientsdata,
  usersettings.retclientsset
set
  retclientsset.EnableImpersonalPrice = 1
where
  clientsdata.BillingCode = 2520
and clientsdata.FirmType = 1
and clientsdata.FirmStatus = 1
and retclientsset.ClientCode = clientsdata.FirmCode
and retclientsset.SmartOrderRuleId is not null
and retclientsset.EnableImpersonalPrice = 0;