alter table Orders.Leaders
change column CostCode PriceCode int unsigned default null,
change column LeaderCostCode LeaderPriceCode int unsigned default null;
