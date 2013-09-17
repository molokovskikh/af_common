#!/bin/bash

name=$1
root=/cygdrive/c/Users/kvasov/projects/Production/templates
packages=(nunit nhibernate mysql.data microsoft.aspnet.webapi log4net stylecop.msbuild)
warmup.0.6.5.0/bin/warmup.exe base $name
cd $name
cd packages
for package in ${packages[*]}
do
nuget install $package
done
cd ..
git init
bake packages
