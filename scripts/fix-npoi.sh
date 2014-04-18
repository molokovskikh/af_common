#!/bin/sh

for f in `find -iname '*.cs'`
do
	perl -i -pe "s/CellType\.NUMERIC/CellType\.Numeric/" $f
done
find -iname *.bak | xargs rm
