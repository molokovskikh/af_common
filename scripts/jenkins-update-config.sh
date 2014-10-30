name=`echo $1 | tr 'A-Z' 'a-z'`
cat config.xml | sed "s/\$JOB_NAME/$name/" > tmp_config
curl -X POST http://devsrv.adc.analit.net:8080/job/$1/config.xml --data-binary "@tmp_config" -H "Content-Type: text/xml"
rm tmp_config
