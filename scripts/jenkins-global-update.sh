#!/bin/sh

curl "http://devsrv.adc.analit.net:8080/view/root/api/json?tree=jobs\[name\]" | /bin/grep -oP ":\"([\w\.-])+\"" | /bin/grep -oP "[\w\.-]+" | tr '[A-Z]' '[a-z]' | tr . - | xargs -I{} curl "http://devsrv.adc.analit.net:8080/job/update-job/buildWithParameters?NAME="{}
