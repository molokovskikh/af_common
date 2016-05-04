#!/bin/sh

for f in `git ls-files | grep \.cs | xargs grep -l '\[SetUpFixture\]'`
do
	perl -i -pe 's/\[SetUp\]/\[OneTimeSetUp\]/' $f
	perl -i -pe 's/\[TearDown\]/\[OneTimeTearDown\]/' $f
done
find -iname '*.bak' | xargs -r rm
