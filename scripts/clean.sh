for f in $*
do
	if file $f | grep -q CRLF; then
		perl -i -pe 's/\s+$/\r\n/g' $f
	else
		perl -i -pe 's/\s+$/\n/g' $f
	fi
rm $f.bak
done
