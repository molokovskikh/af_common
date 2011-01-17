import System
import System.Collections.Generic
import Boo.Lang.PatternMatching
import System.Linq.Enumerable
import Castle.ActiveRecord.Framework.Internal from Castle.ActiveRecord
import file from Tools.boo
import file from Db.boo

def GetLogTriggerTemplate(action as string, fields as string, database as string, table as string):
	operation = 0
	operation = 2 if action == "DELETE"
	operation = 1 if action == "UPDATE"
	operation = 0 if action == "INSERT"
	logTable = GetLogTableName(table)
	triggerName = ToPascal(Inflector.Singularize(table)) + "Log" + ToPascal(action)
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
	sql = "DROP TRIGGER IF EXISTS ${database}.${triggerName}; " + sql
	return sql

def GetLogTableName(table as string):
	return Inflector.Singularize(ToPascal(table)) + "Logs"

def GetTableFields(db as string, table as string, getLine as Func[of string, string, string]):
	fields = Boo.Lang.List()
	for column in Db.Read("show columns from ${db}.${table}"):
		field = column.Field.ToString()
		if field.ToLower() == "id":
			fields.Add("\t\t" + getLine(field, LogId(table)))
		else:
			fields.Add("\t\t" + getLine(field, field))
	return join(fields, ",\r\n")

def LogId(table as string):
	return LastWord(Inflector.Singularize(ToPascal(table))) + "Id"

def GetTableColumns(table as string, database as string) as IEnumerable[of (string)]:
	for column in Db.Read("show columns from ${database}.${table}"):
		yield (column.Field.ToString(), column.Type.ToString())
				
def GetUpdateLogTableCommand(db as string, table as string):
	logTable = GetLogTableName(table)
	notExistColumns = List[of (string)]()
	logTableColumns = (name for name, type in GetTableColumns(logTable, "logs")).ToList()
	for name, type in GetTableColumns(table, db):
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

def GetCreateLogTableCommand(db as string, table as string):
	fields = ""
	for name, type in GetTableColumns(table, db):
		if name.ToLower() == "id":
			name = LogId(table)
			fields += "  `${name}` ${type} not null,\r\n"
			continue
		fields += "  `${name}` ${type},\r\n"
		
	logTable = GetLogTableName(table)
	commandText = """
CREATE TABLE  `logs`.`${logTable}` (
  `Id` int unsigned NOT NULL AUTO_INCREMENT,
  `LogTime` datetime NOT NULL,
  `OperatorName` varchar(50) NOT NULL,
  `OperatorHost` varchar(50) NOT NULL,
  `Operation` tinyint(3) unsigned NOT NULL,
${fields}
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;
"""
	#if Configuration.Maybe.Force:
	#	commandText  = "DROP TABLE IF EXISTS `logs`.`${logTable}`; " + commandText 
	return commandText

def GetLogTriggerCommand(action as string, db as string, table as string):
	match action:
		case "INSERT":
			fields = GetTableFields(db, table, {field, logTo| "${logTo} = NEW.${field}"})
		case "DELETE":
			fields = GetTableFields(db, table, {field, logTo| "${logTo} = OLD.${field}"})
		case "UPDATE":
			getLine as Func[of string, string, string] = def(field as string, logTo as string):
				return "${logTo} = OLD.${field}" if field.ToLower() == "id"
				return "${logTo} = NULLIF(NEW.${field}, OLD.${field})"
			fields = GetTableFields(db, table, getLine)
	
	return GetLogTriggerTemplate(action, fields, db, table)