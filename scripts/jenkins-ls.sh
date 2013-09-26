curl "http://devsrv.adc.analit.net:8080/view/root/api/json?tree=jobs\[name\]" | /bin/grep -oP ":\"([\w\.])+\"" | /bin/grep -oP "[\w\.]+"
