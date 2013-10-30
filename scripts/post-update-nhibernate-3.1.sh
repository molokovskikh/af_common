#!/bin/sh

for f in `git ls-files | /bin/grep \.cs | xargs grep -l NHibernate.ByteCode.Castle.ProxyFactoryFactory`
do
	sed -i ' /NHibernate.ByteCode.Castle.ProxyFactoryFactory/ d' $f
	unix2dos $f
	git add $f
done
