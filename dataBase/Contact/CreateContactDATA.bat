cd /d c:/

md Mysql_backup

mysqldump -h sql2.analit.net -u Zolotarev -p --skip-lock-tables --skip-add-locks -t contacts > c:/Mysql_BackUp/backup_contacts.sql