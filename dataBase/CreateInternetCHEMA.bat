cd /d c:/

md Mysql_backup

mysqldump -u Zolotarev -h dbms2.adc.analit.net -p --skip-lock-tables --no-data internet > c:/Mysql_backup/chema.sql