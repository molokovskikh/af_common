import System
import file from Db.boo

getConnectionString = Db.GetConnectionString
Db.GetConnectionString = {"server=localhost;user=root"}
records = List[of (object)]()
sql = "select * from usersettings.showregulation where ShowClientCode is not null"
for record in Db.Read(sql):
	records.Add((record.PrimaryClientCode,
		record.ShowClientCode,
		record.Addition,
		record.Id,
		record.IncludeType))
Db.GetConnectionString = getConnectionString
for record in records:
	sql = "insert into usersettings.ShowRegulation(PrimaryClientCode, ShowClientCode, Addition, Id, IncludeType)"
	sql += " values (${record[0]}, ${record[1]}, '${record[2]}', ${record[3]}, ${record[4]})"
	Db.Execute(sql)
	
