create table Logs.DocumentSendLogs
(
	Id int unsigned not null auto_increment,
	UserId int unsigned not null,
	DocumentId int unsigned not null,
	UpdateId int unsigned,
	Committed tinyint(1) unsigned not null default 0,
	primary key (Id),
	constraint FK_DocumentSendLogs_UserId foreign key (UserId) references Future.Users(Id) on delete cascade,
	constraint FK_DocumentSendLogs_DocumentId foreign key (DocumentId) references Logs.Document_Logs(RowId) on delete cascade,
	constraint FK_DocumentSendLogs_UpdateId foreign key (UpdateId) references Logs.AnalitFUpdates(UpdateId) on delete cascade
);

alter table logs.Document_logs
add column Ready tinyint(1) default 0;
