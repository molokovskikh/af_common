create table Usersettings.CostOptimizationClients
(
	RuleId int unsigned not null,
	ClientId int unsigned not null,
	primary key(RuleId, ClientId),
	constraint FK_CostOptimizationClients_RuleId foreign key (RuleId) references Usersettings.CostOptimizationRules(Id) on delete cascade
);
