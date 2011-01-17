alter table usersettings.AnalitFReplicationInfo
  add column `ForceReplicationUpdate` timestamp not null default current_timestamp on update current_timestamp;

update
  usersettings.AnalitFReplicationInfo
set
  ForceReplicationUpdate = current_timestamp
where
  (ForceReplicationUpdate = '0000-00-00 00:00:00');
