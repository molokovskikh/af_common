alter table usersettings.RetClientsSet
  add column `BuyingMatrixPriceId` int unsigned default null comment 'ссылка на ассортиментный прайс-лист, из которого будет формироваться матрица закупок, если не установлен, то механизм не активирован',
  add column `BuyingMatrixType` int unsigned not null default 0 comment 'тип матрицы закупок: 0 - белый список, 1 - черный список',
  add column `WarningOnBuyingMatrix` tinyint(1) unsigned not null default 0 comment 'выдавать предупреждение на препараты вне матрицы закупок',
  add constraint FK_RetClientsSet_BuyingMatrixPriceId foreign key (BuyingMatrixPriceId) references usersettings.PricesData(PriceCode) on delete set null;
