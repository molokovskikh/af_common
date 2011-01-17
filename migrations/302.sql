alter table usersettings.AnalitFReplicationInfo
  modify column `ForceReplication` tinyint(1) unsigned DEFAULT '1';