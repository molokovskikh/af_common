#!/bin/sh

for f in `find -iname *.csproj`
do
perl -i -pe "s/<Reference\sInclude=\"([\w\d\.-]+)(,[\w\d\s, =\.]*)\"?/<Reference Include=\"\1\"/" $f
find -iname '*.bak' | xargs -r rm
done
