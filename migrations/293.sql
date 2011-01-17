alter table ordersendrules.smart_order_rules
  add column `UseOrderableOffers` tinyint(1) unsigned not null default 0 comment 'Использовать предложения клиента, а не OffersClientCode';