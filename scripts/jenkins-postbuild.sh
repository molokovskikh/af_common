#!/bin/sh

set -e
set -x

if [ -n "$AUTO_UPDATE" ]; then
	git submodule foreach 'git push || :'
	git push || :
fi
