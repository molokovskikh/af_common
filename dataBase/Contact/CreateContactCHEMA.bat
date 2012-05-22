cd /d c:/

md Mysql_backup

mysqldump -u Zolotarev -h sql2.analit.net -p --skip-lock-tables --skip-triggers --no-data contacts > c:/Mysql_backup/chema_contacts.sql

