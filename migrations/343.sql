alter table Orders.OrdersList
drop foreign key FK_OrdersList_5,
drop foreign key O_OL_SynonymFirmCrCode,
add index (SynonymCode),
add index (SynonymFirmCrCode);
