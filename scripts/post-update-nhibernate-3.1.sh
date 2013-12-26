#!/bin/sh

for f in `git ls-files | /bin/grep \.cs | xargs grep -l NHibernate.ByteCode.Castle.ProxyFactoryFactory`
do
	sed -i ' /NHibernate.ByteCode.Castle.ProxyFactoryFactory/ d' $f
	unix2dos $f
	git add $f
done

for f in `git ls-files | /bin/grep \.config | xargs grep -l NHibernate.ByteCode.Castle.ProxyFactoryFactory`
do
	sed -i ' /<add\s*key="proxyfactory.factory_class"\s*value="NHibernate.ByteCode.Castle.ProxyFactoryFactory, NHibernate.ByteCode.Castle"\s*\/>/ d' $f
	sed -i ' /<property\s*name="proxyfactory.factory_class">NHibernate.ByteCode.Castle.ProxyFactoryFactory,\s*NHibernate.Bytecode.Castle<\/property>/ d' $f
	sed -i ' /<add\s*key="show_sql"\s*value="true"\s*\/>/ d' $f
	unix2dos $f
	git add $f
done
