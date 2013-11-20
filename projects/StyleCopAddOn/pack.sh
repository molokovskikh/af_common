#!/bin/sh

rm *.nupkg
msbuild.exe src/*.sln /property:Configuration=Release
cp src/StyleCopAddOn/bin/release/StyleCopAddOn.dll NuGetPackage/lib/4.0/
nuget pack NuGetPackage/Package.nuspec
nuget push *.nupkg -Source local
rm *.nupkg
