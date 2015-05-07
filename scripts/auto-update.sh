#!/bin/sh

set -e
set -x

assets="`dirname $0`"
assets=`realpath $assets/../bake/assets`

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
fix-stylecop.sh
bake -s packages
git ls-files | grep '\.csproj' | xargs git add -f || :
git submodule foreach "git ls-files | grep csproj | xargs git add -f || :" || :
for f in `find -iname '.gitignore' | xargs grep -L '\*\.gen\.\*'`; do echo -ne "\n*.gen.*" >> $f; done;
git ls-files | grep '\.gitignore' | xargs git add -f || :
fix-bake.sh
git ls-files | grep '.bake' | xargs git add -f || :
cp -f $assets/.editorconfig .editorconfig
git add -f .editorconfig || :
cp -f $assets/nuget.config nuget.config
git add -f nuget.config || :
git ls-files | grep 'nuget.config' | xargs git add -f || :
rm src/nuget.config || :

fix-npoi.sh
fix-nh.sh
git ls-files | grep \.cs$ | xargs git add -f || :
git submodule foreach "git ls-files | grep \.cs | xargs git add -f || :" || :

#получаем известные библиотеки из nuget, lib -> nuget
#нужно попробовать установить библиотеки используя конфигурацию из bake
#если это не получилось то всего скорее для запуска bake не хватает библиотек
#нужно устанавливать игнорируя локальную конфигурацию
bake packages:install || bake -s packages:install
update-packages.sh
git add -A -- lib || :
git add -f -- packages/packages.config || :

#обновляем пакеты
bake -s packages:update | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
bake -s packages:save | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
bake packages:install || bake -s packages:install | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
#правим ссылки в сборках
bake -s packages:fix | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
bake -s fix:js:ref | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
#fix:js:ref может поправить ссылки в файлах нужно их добавить к комиту
git ls-files | grep '\.master' | xargs git add -f || :
git ls-files | grep '\.aspx' | xargs git add -f || :

#пробуем собрать, но это может не получиться из-за специальной магии
bake notInteractive=true || :
rm output -rf || :
msbuild.exe src/*.sln | iconv -s -f cp866 -t cp1251 || : ; test ${PIPESTATUS[0]} -eq 0
bake -s BuildTests notInteractive=true || :
#при сохранении конфига он может добавить пустых строк
git ls-files | grep '\.config' | xargs clean.sh
git add -f -- packages/packages.config || :
git ls-files | grep '\.config' | xargs git add -f || :
git submodule foreach "git ls-files | grep packages.config | xargs git add -f || :" || :

git submodule foreach 'git commit -m "Автообновление" || :' || :
git submodule | awk '{print $2}' | xargs git add || :
git commit -m "Автообновление" || :
