#!/bin/sh

for f in `find -iname *.csproj`
do
perl -i -pe "s/<Reference\sInclude=\"([\w\.]+)(,[\w\d\s, =\.]*)\"?/<Reference Include=\"\1\"/" $f
find -iname *.bak | xargs rm
done
