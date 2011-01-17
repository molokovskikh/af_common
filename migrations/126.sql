create table Usersettings.CostOptimizationConcurrents
(
	RuleId int unsigned not null,
	SupplierId int unsigned not null,
	primary key (RuleId, SupplierId),
	constraint FK_CostOptimizationConcurrents_RuleId foreign key (RuleId) references Usersettings.CostOptimizationRules(Id) on delete cascade,
	constraint FK_CostOptimizationConcurrents_SupplierId foreign key (SupplierId) references Usersettings.ClientsData(FirmCode) on delete cascade
);
