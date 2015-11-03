#!/bin/bash

git ls-files | /bin/grep csproj | xargs sed -i "s/<TargetFrameworkVersion>v4.0<\/TargetFrameworkVersion>/<TargetFrameworkVersion>v4.5<\/TargetFrameworkVersion>/"
git ls-files | /bin/grep csproj | xargs unix2dos
