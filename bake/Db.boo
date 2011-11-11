import System
import MySql.Data.MySqlClient
import System.Data.Common
import System from System.Core

class Db:

	def constructor(connectionString as string):
		GetConnectionString = def:
			return connectionString

	def constructor(getConnectionString as Func[of string]):
		GetConnectionString = getConnectionString

	private static current as Db

	public static Current as Db:
		get:
			raise "Не настроена конфигурация базы данных, ты импортировал config.bake?" unless current
			return current
		set:
			current = value

	public GetConnectionString as Func[of string]
	
	public ConnectionString:
		get:
			if not GetConnectionString:
				raise "Не настроена конфигурация базы данных, ты импортировал config.bake?"
			return GetConnectionString()

	static def Execute(sql as string):
		return Current.ExecuteSql(sql)

	def ExecuteSql(sql as string):
		using connection = MySqlConnection(ConnectionString):
			connection.Open()
			transaction = connection.BeginTransaction()
			try:
				command = MySqlCommand(sql, connection)
				result = command.ExecuteNonQuery()
				transaction.Commit()
				return result
			except:
				transaction.Rollback()
				raise

	static def Read(sql as string):
		return Current.ReadSql(sql)

	def ReadSql(sql as string):
		using connection = MySqlConnection(ConnectionString):
			connection.Open()
			command = MySqlCommand(sql, connection)
			using reader = command.ExecuteReader():
				for record as DbDataRecord in reader:
					yield DuckRecord(record)

class DuckRecord(IQuackFu):
	
	_record as DbDataRecord = null

	def constructor(record as DbDataRecord):
		_record = record
		
	def QuackGet(name as string, parameters as (object)) as object:
		if parameters and parameters.Length:
			name = parameters[0].ToString()
		return _record[name]
