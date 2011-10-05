cd /d c:/

md Mysql_backup

mysqldump -u Zolotarev -h sql2.analit.net -p --skip-lock-tables --skip-triggers --no-data logs > c:/Mysql_backup/chema.sql

