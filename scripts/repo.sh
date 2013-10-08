#!/bin/sh

script=`realpath $1`
for r in `ssh kvasov@git.analit.net ls /home/git/repositories/root | /bin/grep -v wiki | sed s/\.git//`
do
	rm $r -rf
	git clone git@git.analit.net:root/$r
	cd $r
	$script
	git push
	cd ..
done
