#!/usr/bin/bash

grep -il --include=*.cs --include=*.vb '"Future"' . -r | xargs perl -i -pe 's/"Future"/"Customers"/gi'
find -name '*.bak' | xargs -r rm
grep -il --include=*.cs --include=*.vb 'Future\.' . -r | xargs perl -i -pe 's/Future\./Customers\./gi'
find -name '*.bak' | xargs -r rm
