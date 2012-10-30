for f in $*
do
perl -i -pe 's/\s+$/\r\n/g' $f
rm $f.bak
done
