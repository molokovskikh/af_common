#!/bin/sh

for f in `git ls-files | grep \.cs | xargs grep -l '\[SetUpFixture\]'`
do
	perl -i -pe 's/\[SetUp\]/\[OneTimeSetUp\]/' $f
	perl -i -pe 's/\[TearDown\]/\[OneTimeTearDown\]/' $f
done
for f in `git ls-files | grep \.cs | xargs grep -l 'NUnit.Framework'`
do
	perl -i -pe 's/Is\.StringContaining/Does\.Contain/' $f
	perl -i -pe 's/Is\.StringMatching/Does\.Match/' $f
done
find -iname '*.bak' | xargs -r rm
