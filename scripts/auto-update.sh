#!/bin/sh

set -e
set -x

git checkout master
git pull
git submodule sync
git submodule update --init
git submodule foreach "git checkout master && git pull"
git clean -fdx
git submodule foreach git clean -fdx

#правим ссылки в файлах проектов, что бы удалить номер версии
fix-ref.sh
update-stylecop.sh
git ls-files | grep '\.csproj' | xargs git add -f || :
git submodule foreach "git ls-files | grep csproj | xargs git add -f || :" || :

#получаем известные библиотеки из nuget, lib -> nuget
bake packages:install
update-packages.sh
git add -A -- lib || :
git add -f -- packages/packages.config || :

#обновляем пакеты
bake packages:update
bake packages:save
bake packages:install
#пробуем собрать, но это может не получиться из-за специальной магии
bake notInteractive=true|| :
rm output -rf || :
msbuild.exe src/*.sln
bake BuildTests notInteractive=true || :
bake generate:binding:redirection
#при сохранении конфига он может добавить пустых строк
git ls-files | grep '\.config' | xargs clean.sh
git add -f -- packages/packages.config || :
git ls-files | grep '\.config' | xargs git add -f || :

git submodule | awk '{print $2}' | xargs git add || :
git submodule foreach 'git commit -m "Автообновление" || :' || :
git commit -m "Автообновление" || :
