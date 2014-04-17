#!/bin/sh

for f in `find -iname '*.csproj' -or -iname '*.vbproj'`
do
	perl -i -pe "s/tools\\\\StyleCop\.Targets/build\\\\StyleCop\.MSBuild\.Targets/" $f
done
find -iname *.bak | xargs rm
