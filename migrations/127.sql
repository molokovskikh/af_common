alter table Orders.OrdersHead
add constraint FK_OrdersHead_AddressId foreign key (AddressId) references Future.Addresses(Id) on delete set null,
add constraint FK_OrdersHead_UserId foreign key (UserId) references Future.Users(Id) on delete set null;
