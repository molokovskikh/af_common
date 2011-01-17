alter table usersettings.UserPermissions modify Name varchar(255);

update usersettings.UserPermissions
   set Name = 'Поиск препаратов в каталоге-Сводный прайс-лист'
 where Shortcut = 'FPCPL';