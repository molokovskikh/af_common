#import System
import NHibernate.Tool.hbm2ddl
import NHibernate.AdoNet.Util
import NHibernate.Dialect
import NHibernate.Mapping
import NHibernate.Cfg

import Castle.Core
import System.Collections.Generic
import System.Reflection
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
	dict.Add(Environment.ConnectionString, Db.ConnectionString)
	dict.Add(Environment.ProxyFactoryFactoryClass, "NHibernate.ByteCode.Castle.ProxyFactoryFactory, NHibernate.ByteCode.Castle")
	dict.Add(Environment.Hbm2ddlKeyWords, "none")
	config.Add(ActiveRecordBase, dict)
	
	holder as ISessionFactoryHolder;
	ActiveRecordStarter.SessionFactoryHolderCreated += {h| holder = h}
	
	assemblies = List of Assembly()
	for path in assemblyPaths:
		assemblies.Add(Assembly.LoadFrom(path))
	ActiveRecordStarter.Initialize(assemblies.ToArray(), config)
	return holder.GetAllConfigurations()[0]