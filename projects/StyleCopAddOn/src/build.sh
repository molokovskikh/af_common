#!/bin/sh

rm *.nupkg
msbuild.exe *.sln /property:Configuration=Release
cp StyleCopAddOn/bin/release/StyleCopAddOn.dll ../NuGetPackage/lib/4.0/
nuget pack ../NuGetPackage/Package.nuspec
nuget push *.nupkg -Source local
rm *.nupkg
