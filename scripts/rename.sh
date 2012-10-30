#!/usr/bin/bash
grep -il --include=*.cs --include=*.vb '"Future"' . -r | xargs perl -i -pe 's/"Future"/"Customers"/gi'
find -name *.bak | xargs rm
grep -il --include=*.cs --include=*.vb 'Future\.' . -r | xargs perl -i -pe 's/Future\./Customers\./gi'
find -name *.bak | xargs rm
