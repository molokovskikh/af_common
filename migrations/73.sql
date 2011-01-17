alter table Future.Users
add column InheritPricesFrom int unsigned,
add constraint FK_Users_InheritPricesFrom foreign key (InheritPricesFrom) references Future.Users(Id);
