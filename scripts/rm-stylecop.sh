#!/bin/bash

rm -rf packages/StyleCop.MSBuild*
rm -rf packages/StyleCopAddOn*
bake packages:save

git ls-files | /bin/grep csproj | xargs sed -i "s/<Import Project=\"\$(StylecopPath)\\\\build\\\\StyleCop\.MSBuild\.Targets\" \/>/<Import Project=\"\$(StylecopPath)\\\\build\\\\StyleCop.MSBuild.Targets\" Condition=\"Exists('\$(StylecopPath)\\\\build\\\\StyleCop.MSBuild.Targets')\"  \/>/"
git ls-files | /bin/grep csproj | xargs unix2dos
