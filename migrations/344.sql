alter table ordersendrules.smart_order_rules
  add column `NotCheckMinOrder` tinyint(1) unsigned not null default 0 comment 'Не проверять минимальный заказ';