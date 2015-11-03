import System
import System.Collections.Generic
import Boo.Lang.PatternMatching
import System.Linq.Enumerable
import InflectorStringExtension from "inflector_extension"

def GetLogTriggerTemplate(action as string, fields as string, database as string, table as string, sufix as string):
	operation = 0
	operation = 2 if action == "DELETE"
	operation = 1 if action == "UPDATE"
	operation = 0 if action == "INSERT"
	logTable = GetLogTableName(table, sufix)
	SingularizedTable = Singulize(ToPascal(table))
	triggerName = ToPascal(SingularizedTable) + "Log" + ToPascal(action)
	sql = """
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER ${database}.${triggerName} AFTER ${action} ON ${database}.${table}
FOR EACH ROW BEGIN
	INSERT
	INTO `logs`.${logTable}
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = ${operation},
${fields};
END;
"""
	sql = "DROP TRIGGER IF EXISTS ${database}.${triggerName};" + sql
	return sql

def GetLogTriggerTemplate2(action as string, fields as string, database as string, table as string, sufix as string):
	operation = "'I'"
	operation = "'D'" if action == "DELETE"
	operation = "'U'" if action == "UPDATE"
	operation = "'I'" if action == "INSERT"
	logTable = GetLogTableName(table, sufix)
	SingularizedTable = Singulize(ToPascal(table))
	triggerName = ToPascal(SingularizedTable) + "Log" + ToPascal(action)
	sql = """
CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER ${database}.${triggerName} AFTER ${action} ON ${database}.${table}
FOR EACH ROW BEGIN
	INSERT
	INTO `logs`.${logTable}
	SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)),
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)),
		Operation = ${operation},
${fields};
END;
"""
	sql = "DROP TRIGGER IF EXISTS ${database}.${triggerName};" + sql
	return sql

def GetLogTableName(table as string, sufix as string):
	table = Singulize(ToPascal(table))
	return table + sufix + "Logs"

def Singulize(value as string):
	try:
		singulized = InflectorStringExtension.InflectTo(value).Singularized
		singulized = value unless singulized
		return singulized
	except:
		return value

def GetTableFields(db as string, table as string, getLine as Func[of duck, string, string]):
	fields = Boo.Lang.List()
	for column in Db.Read("show columns from ${db}.${table}"):
		field = column.Field.ToString()
		if field.ToLower() == "id":
			fields.Add("\t\t" + getLine(column, LogId(table)))
		else:
			fields.Add("\t\t" + getLine(column, field))
	return join(fields, ",\r\n")

def LogId(table as string):
	return LastWord(Singulize(table)) + "Id"

def GetTableColumns(table as string, database as string) as IEnumerable[of (string)]:
	for column in Db.Read("show columns from ${database}.${table}"):
		yield (column.Field.ToString(), column.Type.ToString())

def GetUpdateLogTableCommand(db as string, table as string):
	return GetUpdateLogTableCommand(db, table, "")

def GetUpdateLogTableCommand(db as string, table as string, sufix as string):
	logTable = GetLogTableName(table, sufix)
	columns = GetTableColumns(table, db)
	unless Db.Read("show tables in logs").Select({r| r[0].ToString()}).Contains(logTable, StringComparer.OrdinalIgnoreCase):
		return GetCreateLogTableCommand(logTable, GetLogTableColumnsSql(table, columns))
	notExistColumns = List[of (string)]()
	logTableColumns = (name for name, type in GetTableColumns(logTable, "logs")).ToList()
	for name, type in columns:
		notExistColumns.Add((name, type)) if not logTableColumns.Contains(name)
	fields = ""
	i = 0
	if notExistColumns.Count == 0:
		raise "log table ${logTable} is up to date"
	for name, type in notExistColumns:
		fields += "add column ${name} ${type}"
		fields += ",\r\n" if i < notExistColumns.Count - 1
		i++

	return """
alter table Logs.${logTable}
${fields}
;
"""

def GetUpdateLogTableCommand2(db as string, table as string, sufix as string):
	logTable = GetLogTableName(table, sufix)
	columns = GetTableColumns(table, db)
	newColumns = List of (string)()
	for name, type in columns:
		if name.ToLower() == "id":
			newColumns.Add((LogId(table), type))
		else:
			newColumns.Add(("New" + name, type))
			newColumns.Add(("Old" + name, type))
	columns = newColumns
	unless Db.Read("show tables in logs").Select({r| r[0].ToString()}).Contains(logTable, StringComparer.OrdinalIgnoreCase):
		return GetCreateLogTableCommand(logTable, GetLogTableColumnsSql(table, columns))
	notExistColumns = List[of (string)]()
	logTableColumns = (name for name, type in GetTableColumns(logTable, "logs")).ToList()
	for name, type in columns:
		notExistColumns.Add((name, type)) if not logTableColumns.Contains(name)
	fields = ""
	i = 0
	if notExistColumns.Count == 0:
		raise "log table ${logTable} is up to date"
	for name, type in notExistColumns:
		fields += "add column ${name} ${type}"
		fields += ",\r\n" if i < notExistColumns.Count - 1
		i++

	return """
alter table Logs.${logTable}
${fields}
;
"""

def GetCreateLogTableCommand(logTable as string, fields as string):
	commandText = """
CREATE TABLE  `logs`.`${logTable}` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` char(1) NOT NULL,
${fields}
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
"""
	return commandText

def GetLogTableColumnsSql(table as string, columns as duck):
	fields = ""
	for name, type in columns:
		if name.ToLower() == "id":
			name = LogId(table)
			fields += "  `${name}` ${type} not null,\r\n"
			continue
		fields += "  `${name}` ${type},\r\n"
	return fields

def CheckForNull(column as duck):
	if column.Key.ToString() == "PRI" or column.Extra.ToString() == "auto_increment":
		return false
	return true

def GetLogTriggerCommand(action as string, db as string, table as string, sufix as string):
	match action:
		case "INSERT":
			fields = GetTableFields(db, table, {column, logTo| "${logTo} = NEW.${column.Field}"})
		case "DELETE":
			fields = GetTableFields(db, table, {column, logTo| "${logTo} = OLD.${column.Field}"})
		case "UPDATE":
			getLine as Func[of duck, string, string] = def(column as duck, logTo as string):
				return "${logTo} = OLD.${column.Field}" unless CheckForNull(column)
				return "${logTo} = NULLIF(NEW.${column.Field}, OLD.${column.Field})"
			fields = GetTableFields(db, table, getLine)

	return GetLogTriggerTemplate(action, fields, db, table, sufix)

def GetLogTriggerCommand2(action as string, db as string, table as string, sufix as string):
	fields = Boo.Lang.List()
	for column, type in GetTableColumns(table, db):
		if column.ToLower() == "id":
			logId = LogId(table)
			match action:
				case "INSERT":
					fields.Add("\t\t$logId = NEW.${column}")
				case "DELETE":
					fields.Add("\t\t$logId = OLD.${column}")
				case "UPDATE":
					fields.Add("\t\t$logId = OLD.${column}")
		else:
			match action:
				case "INSERT":
					fields.Add("\t\tNew${column} = NEW.${column}")
				case "DELETE":
					fields.Add("\t\tOld${column} = OLD.${column}")
				case "UPDATE":
					fields.Add("\t\tNew${column} = NEW.${column},\r\n"\
						+ "\t\tOld${column} = OLD.${column}")

	return GetLogTriggerTemplate2(action, join(fields, ",\r\n"), db, table, sufix)
