cd /d c:/

md Mysql_backup

mysqldump -h dbms2.adc.analit.net -u Zolotarev -p --skip-lock-tables --skip-add-locks -t internet > c:/Mysql_BackUp/backup.sql