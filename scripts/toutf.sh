for f in $*
do
iconv -f cp1251 -t utf-8 $f > $f.utf8
mv $f{.utf8,}
done
