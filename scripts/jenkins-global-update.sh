#!/bin/sh

curl "http://ci.analit.net/view/root/api/json?tree=jobs\[name\]" | /bin/grep -oP ":\"([\w\.-])+\"" | /bin/grep -oP "[\w\.-]+" | tr '[A-Z]' '[a-z]' | tr . - | xargs -I{} curl "http://ci.analit.net/job/update-job/buildWithParameters?NAME="{}
