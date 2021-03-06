#!/bin/sh

for f in `find -iname '*.bake'`
do
	perl -i -pe "s/\@DeployPipeline/\"deploy:pipeline\"/" $f
done
find -iname '*.bak' | xargs -r rm
for f in *.bake
do
	sed -i '/import file from/d' $f
	sed -i 's/@SendDeployNotification/"deploy:notify"/' $f
	unix2dos $f
done
