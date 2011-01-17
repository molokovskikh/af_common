alter table `orders`.`OrderedOffers`
  add column `ProducerCost` decimal(12,6) unsigned default null,
  add column `NDS` smallint unsigned default null;