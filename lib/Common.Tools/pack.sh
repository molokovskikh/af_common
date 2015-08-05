#!/bin/sh

nuget pack -Verbose Package.nuspec -Exclude pack.sh
mv *.nupkg ../../nuget
