alter table Logs.CostOptimizationLogs
drop column Junk;

alter table Usersettings.CostCorrectorSettings
drop primary key,
add column Id int unsigned not null auto_increment primary key First;
