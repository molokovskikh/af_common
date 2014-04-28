#!/bin/sh

for f in `find -iname '*.cs'`
do
	perl -i -pe "s/CellType\.NUMERIC/CellType\.Numeric/" $f
	perl -i -pe "s/CellType\.BLANK/CellType\.Blank/" $f
	perl -i -pe "s/CellType\.BOOLEAN/CellType\.Boolean/" $f
	perl -i -pe "s/BorderStyle\.MEDIUM/BorderStyle\.Medium/" $f
	perl -i -pe "s/BorderStyle\.THIN/BorderStyle\.Thin/" $f
	perl -i -pe "s/HorizontalAlignment\.CENTER/HorizontalAlignment\.Center/" $f
	perl -i -pe "s/HorizontalAlignment\.RIGHT/HorizontalAlignment\.Right/" $f
	perl -i -pe "s/FontBoldWeight\.BOLD/FontBoldWeight\.Bold/" $f
	perl -i -pe "s/FillPatternType\.SOLID_FOREGROUND/FillPattern\.SolidForeground/" $f
done
find -iname *.bak | xargs rm
