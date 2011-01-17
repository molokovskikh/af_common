DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleInsert;
DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleUpdate;
DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleDelete;

alter table logs.SmartOrderRuleLogs
  drop column ShowAvgCosts,
  drop column ShowJunkOffers;

alter table ordersendrules.smart_order_rules
  drop column ShowAvgCosts,
  drop column ShowJunkOffers;


alter table usersettings.RetClientsSet
  add column `EnableImpersonalPrice` tinyint(1) unsigned not null default 0 comment 'Доступен механизм Обезличенный прайс-лист';

alter table logs.RetClientsSetLogs
  add column `BuyingMatrixPriceId` int unsigned default null,
  add column `BuyingMatrixType` int unsigned default null,
  add column `WarningOnBuyingMatrix` tinyint(1) unsigned default null,
  add column `EnableImpersonalPrice` tinyint(1) unsigned default null; 