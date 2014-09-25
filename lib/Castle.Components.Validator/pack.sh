#!/bin/sh

name=validator
url=git@git.analit.net:r.kvasov/validator.git
mask=Castle.Components.Validator

if [ ! -d $name ]; then
git clone $url $name
fi
cd ./$name/
find -iname packages.config | xargs -I{} nuget install -OutputDirectory packages {}
chmod +x build.cmd
./build.cmd
find -iname '*.exe' | xargs chmod +x
find -iname '*.dll' | xargs chmod +x
cd ..
rm -r lib/net40/*
cp ./$name/build/NET40/NET40-Release/bin/$mask.* lib/net40/
cp -r ./$name/build/NET40/NET40-Release/bin/ru lib/net40/
find lib -iname '*.Tests.*' | xargs rm
nuget pack -Verbose Package.nuspec -Exclude '**\'$name'\**' -Exclude pack.sh
mv *.nupkg ../../nuget
