alter table `orders`.`OrderedOffers`
  drop column `ProducerCost`,
  add column `Quantity` varchar(15) DEFAULT NULL;
