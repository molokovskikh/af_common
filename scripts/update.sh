#!/bin/sh

if [ -f .gitmodules ];
then
	echo `dirname $0`
	`dirname $0`/convert.rb
	git submodule sync
	git add .gitmodules
	if [ $? -eq 0 ]; then
		git commit -m "Перенес саб-модули"
	fi
	echo 'updated'
else
	echo 'no submodules'
fi
