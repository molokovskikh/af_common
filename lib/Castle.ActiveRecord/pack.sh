#!/bin/sh

if [ ! -d active-record ]; then
git clone git@git.analit.net:r.kvasov/active-record.git
fi
cd ./active-record/
find -iname packages.config | xargs -I{} nuget install -OutputDirectory packages {}
./build.cmd
cd ..
cp ./active-record/build/NET40/NET40-Release/bin/Castle.ActiveRecord.* lib/net40/
rm lib/net40/*.Tests.*
nuget pack -Verbose Package.nuspec -Exclude '**\active-record\**' -Exclude pack.sh
mv *.nupkg ../../nuget
