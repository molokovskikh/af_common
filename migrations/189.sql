create table Documents.Rejects(
  Id int unsigned auto_increment primary key,
  OrderLineId int unsigned not null,
  OrderedQuantity int unsigned not null,
  OrderedCost decimal(9, 2) unsigned not null
);
