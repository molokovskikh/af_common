alter table orders.orderslist
drop foreign key O_OL_CodeFirmCr,
add constraint FR_OrderList_ProducerId foreign key (CodeFirmCr) references Catalogs.Producers(Id) ON DELETE SET NULL ON UPDATE CASCADE;