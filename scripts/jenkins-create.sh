curl -X POST http://devsrv.adc.analit.net:8080/createItem?name=$1 --data-binary "@config.xml" -H "Content-Type: text/xml"
ssh git.analit.net rm /var/git/$1.git/hooks/post-update
ssh git.analit.net ln -s /var/git/post-update-jenkins /var/git/$1.git/hooks/post-update
