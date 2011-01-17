import System
import MySql.Data.MySqlClient
import System.Data.Common
import System from System.Core

class Db:

	public static GetConnectionString as Func[of string]
	
	public static ConnectionString:
		get:
			if not GetConnectionString:
				raise "Не настроена конфигурация базы данных, ты импортировал config.bake?"
			return GetConnectionString()
	
	static def Execute(commandText as string):
		using connection = MySqlConnection(ConnectionString):
			connection.Open()
			command = MySqlCommand(commandText, connection)
			return command.ExecuteNonQuery()
	
	static def Read(commandText as string):
		using connection = MySqlConnection(ConnectionString):
			connection.Open()
			command = MySqlCommand(commandText, connection)
			using reader = command.ExecuteReader():
				for record as DbDataRecord in reader:
					yield DuckRecord(record)

class DuckRecord(IQuackFu):
	
	_record as DbDataRecord = null

	def constructor(record as DbDataRecord):
		_record = record
		
	def QuackGet(name as string, parameters as (object)) as object:
		return _record[name]
