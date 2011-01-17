create table Usersettings.CostOptimizationRules
(
	Id int unsigned not null auto_increment,
	SupplierId int unsigned not null,
	primary key (Id),
	constraint FK_CostOptimizationRules_SupplierId foreign key (SupplierId) references Usersettings.ClientsData(FirmCode) on delete cascade
);
