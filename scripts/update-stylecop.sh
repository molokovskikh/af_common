#!/bin/sh

find -iname *.csproj | xargs replace.sh '(\.\.\\){2,}packages\\StyleCopAddOn\.1\.0\.4' '\$\(StylecopAddonPath\)'
find -iname *.csproj | xargs replace.sh '(\.\.\\){2,}packages\\StyleCop\.MSBuild\.4\.7\.35\.0' '\$\(StylecopPath\)'
