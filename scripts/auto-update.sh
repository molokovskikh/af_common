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

fix-ref.sh
update-stylecop.sh
git ls-files | grep csproj | xargs git add || :
git submodule foreach "git ls-files | grep csproj | xargs git add || :" || :

bake packages:install
update-packages.sh
git add -A -- lib || :
git add -f -- packages/packages.config || :

git submodule | awk '{print $2}' | xargs git add || :
git submodule foreach 'git commit -m "Автообновление" || :' || :
git commit -m "Автообновление" || :
