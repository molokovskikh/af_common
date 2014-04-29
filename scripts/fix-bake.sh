#!/bin/sh

for f in `find -iname '*.bake'`
do
	perl -i -pe "s/\@DeployPipeline/\"deploy:pipiline\"/" $f
done
find -iname *.bak | xargs rm
