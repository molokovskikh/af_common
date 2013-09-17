name=`cygpath -wa $1`
name=${name//\\/\\\\}
echo $name
wmic datafile where name=\'$name\' get version
