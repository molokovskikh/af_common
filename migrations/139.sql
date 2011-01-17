alter table usersettings.UserPermissions add SecurityMask BIGINT;

UPDATE usersettings.UserPermissions SET SecurityMask=1 WHERE Shortcut='ESOO'; 
UPDATE usersettings.UserPermissions SET SecurityMask=2 WHERE Shortcut='ECOO'; 
UPDATE usersettings.UserPermissions SET SecurityMask=4 WHERE Shortcut='FPCN'; 
UPDATE usersettings.UserPermissions SET SecurityMask=8 WHERE Shortcut='FPCF'; 
UPDATE usersettings.UserPermissions SET SecurityMask=16 WHERE Shortcut='FPCNF'; 
UPDATE usersettings.UserPermissions SET SecurityMask=32 WHERE Shortcut='FPL'; 
UPDATE usersettings.UserPermissions SET SecurityMask=64 WHERE Shortcut='PLSL'; 
UPDATE usersettings.UserPermissions SET SecurityMask=128 WHERE Shortcut='PLSOS'; 
UPDATE usersettings.UserPermissions SET SecurityMask=256 WHERE Shortcut='COC';
UPDATE usersettings.UserPermissions SET SecurityMask=512 WHERE Shortcut='COS'; 
UPDATE usersettings.UserPermissions SET SecurityMask=1024 WHERE Shortcut='COA';

UPDATE usersettings.UserPermissions SET SecurityMask=2048 WHERE Shortcut='SOA'; 
UPDATE usersettings.UserPermissions SET SecurityMask=4096 WHERE Shortcut='EPP'; 
UPDATE usersettings.UserPermissions SET SecurityMask=8192 WHERE Shortcut='BP'; 
UPDATE usersettings.UserPermissions SET SecurityMask=16384 WHERE Shortcut='FPCPL'; 
UPDATE usersettings.UserPermissions SET SecurityMask=32768 WHERE Shortcut='PCPL'; 
UPDATE usersettings.UserPermissions SET SecurityMask=65536 WHERE Shortcut='PPLS'; 
UPDATE usersettings.UserPermissions SET SecurityMask=131072 WHERE Shortcut='PBP'; 
UPDATE usersettings.UserPermissions SET SecurityMask=262144 WHERE Shortcut='PCCO'; 
UPDATE usersettings.UserPermissions SET SecurityMask=524288 WHERE Shortcut='PSCO'; 
UPDATE usersettings.UserPermissions SET SecurityMask=1048576 WHERE Shortcut='PCO'; 
UPDATE usersettings.UserPermissions SET SecurityMask=2097152 WHERE Shortcut='PSO';