alter table Usersettings.Defaults
  add column Id int unsigned NOT NULL AUTO_INCREMENT,
  add column FormaterId int unsigned not null,
  add column SenderId int unsigned not null,
  add primary key (Id)
;
 
update Usersettings.Defaults
set FormaterId = 172,
	SenderId = 1
;