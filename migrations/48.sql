create table logs.CostOptimizationLogs(
  Id int not null auto_increment,
  LoggedOn timestamp not null default current_timestamp,
  CatalogId int not null,
  ProducerId int not null,
  SelfCost decimal(11, 2),
  ConcurentCost decimal(11, 2),
  AllCost decimal(11, 2),
  ResultCost decimal(11, 2),
  primary key(id)
);