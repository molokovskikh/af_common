#!/bin/sh

for f in `find src test -iname '*.js' -or -iname '*.coffee'`
do
	perl -i -pe "s/\)\.live\(/).on(/" $f
done
find -iname *.bak | xargs rm
grunt coffee
