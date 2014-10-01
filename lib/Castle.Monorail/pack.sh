#!/bin/sh

mkdir -p lib/net40
if [ ! -d MonoRail ]; then
git clone git@github.com:radiy/MonoRail.git
fi
cd ./MonoRail/MR2/
./build.cmd
find -iname '*.exe' | xargs chmod +x
find -iname '*.dll' | xargs chmod +x
cd ..
cd ..
cp MonoRail/MR2/build/NET40/NET40-Release/bin/Boo.* lib/net40/
cp MonoRail/MR2/build/NET40/NET40-Release/bin/anrControls.Markdown.NET.* lib/net40/
cp MonoRail/MR2/build/NET40/NET40-Release/bin/Castle.MonoRail.* lib/net40/
rm lib/net40/*.Tests.*
nuget pack -Verbose Package.nuspec -Exclude '**\MonoRail\**' -Exclude pack.sh
mv *.nupkg ../../nuget
