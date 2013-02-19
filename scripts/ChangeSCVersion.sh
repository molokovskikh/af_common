#! /bin/bash
HOMEDIR=`pwd`
for m in $(find -type d -name ".git"); do
cd "$HOMEDIR"
cd "$m/.."

for l in $(find -name *.csproj);
do
sed -i -e ' s/StyleCopAddOn.'$1'/StyleCopAddOn.'$2'/i;' $l;
unix2dos $l;
if [ -f $l/../../../packages/packages.config ]
then
  sed -i -e 's/id="StyleCopAddOn" version="'$1'"/id="StyleCopAddOn" version="'$2'"/i;' $l/../../../packages/packages.config
  unix2dos $l/../../../packages/packages.config;
fi
done

#git add *.csproj
#git add -f packages/packages.config
#git commit -m "Обновлена проверка кода через stylecop"
done