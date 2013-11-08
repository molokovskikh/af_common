#!/bin/sh

name=$(echo $1 | tr [A-Z] [a-z])
for f in `git ls-files | /bin/grep \.brail | xargs grep -li "$1-$2"`
do
	sed -r -i "s/$1-$2(.min)?\.js/$name-$3.min.js/gI" $f
	unix2dos $f
	git add $f
done
