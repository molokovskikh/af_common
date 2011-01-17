alter table orders.OrdersList
  add column `SupplierPriceMarkup` decimal(5,3) default null,
  add column `RetailMarkup` decimal(12,6) default null;