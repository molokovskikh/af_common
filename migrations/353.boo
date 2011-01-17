import System
import file from Db.boo

getConnectionString = Db.GetConnectionString
Db.GetConnectionString = {"server=localhost;user=root"}
records = List[of (object)]()
sql = "select id, accountingId from future.Users where AccountingId is not null"
for record in Db.Read(sql):
	records.Add((record.Id,
		record.AccountingId))
Db.GetConnectionString = getConnectionString
for id, accountingId in records:
	sql = "update future.users set accountingid = $accountingId where id = $id"
	Db.Execute(sql)