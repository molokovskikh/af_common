#import System
import System.Reflection
import System.Collections.Generic
import System.Linq.Enumerable

import NHibernate.Tool.hbm2ddl
import NHibernate.AdoNet.Util
import NHibernate.Dialect
import NHibernate.Mapping
import NHibernate.Cfg

import Castle.Core
import Castle.ActiveRecord
import Castle.ActiveRecord.Framework
import Castle.ActiveRecord.Framework.Config

import log4net.Config

import file from Db.boo

def GetActiveRecordConfiguration(assemblyPaths as (string)):
	config = InPlaceConfigurationSource()
	config.PluralizeTableNames = true
	dict = Dictionary[of string, string]()
	dict.Add(Environment.Dialect, "NHibernate.Dialect.MySQLDialect")
	dict.Add(Environment.ConnectionDriver, "NHibernate.Driver.MySqlDataDriver")
	dict.Add(Environment.ConnectionProvider, "NHibernate.Connection.DriverConnectionProvider")
	dict.Add(Environment.ConnectionString, Db.Current.ConnectionString)
	dict.Add(Environment.ProxyFactoryFactoryClass, "NHibernate.ByteCode.Castle.ProxyFactoryFactory, NHibernate.ByteCode.Castle")
	dict.Add(Environment.Hbm2ddlKeyWords, "none")
	config.Add(ActiveRecordBase, dict)

	assemblies = assemblyPaths.Select({a| Assembly.LoadFrom(a)}).ToArray()

	DefaultInitializer(config, assemblies) unless BuiltinInitializer(config, assemblies.First())

	return ActiveRecordMediator.GetSessionFactoryHolder().GetAllConfigurations()[0]

def BuiltinInitializer(config as IConfigurationSource, assembly as Assembly):
	for type in assembly.GetTypes():
		continue unless type.Namespace and type.Namespace.EndsWith(".Initializers")
		continue unless type.GetMethod("Initialize")
		System.Activator.CreateInstance(type).Initialize(config)
		return true
	return false

def DefaultInitializer(config as IConfigurationSource, assemblies as (Assembly)):
	ActiveRecordStarter.Initialize(assemblies, config)
