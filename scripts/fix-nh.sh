#!/bin/sh

for f in `git ls-files | grep \.cs | xargs grep -l RemoveAsAliasesFromSql`
do
	perl -i -pe "s/StringHelper\.RemoveAsAliasesFromSql/SqlStringHelper\.RemoveAsAliasesFromSql/" $f
done
find -iname '*.bak' | xargs -r rm
