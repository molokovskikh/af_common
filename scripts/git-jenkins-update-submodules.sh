#!/bin/sh

if [ -f .gitmodules ]; then
	cat .gitmodules | /bin/grep -oP '(?<=path = ).+' | xargs git add
	git status | grep "Changes to be committed"
	if [ $? -eq 0 ]; then
		git commit -m "Обновлены сабмодули"
		git push
	else
		echo "no changes"
	fi
fi
