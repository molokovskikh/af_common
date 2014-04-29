#!/bin/sh

for f in `find -iname '*.bake'`
do
	perl -i -pe "s/\@DeployPipeline/\"deploy:pipeline\"/" $f
done
find -iname *.bak | xargs rm
