import System
import System.Collections.Generic
import System.Linq.Enumerable from System.Core
import file from Db.boo

class Data:
	public Id as uint
	public ClientId as uint
	public RegionId as uint
	public PriceId as uint
	public AddressId as uint
	public SupplierDeliveryId as string
	public ControlMinReq as bool
	public MinReq as uint?

	def Read(row as duck):
		return Data(
			Id : Convert.ToUInt32(row.Id),
			RegionId : Convert.ToUInt32(row.RegionId),
			PriceId : Convert.ToUInt32(row.PriceId),
			ClientId : Convert.ToUInt32(row.ClientId),
			AddressId : Convert.ToUInt32(row.AddressId),
			SupplierDeliveryId : row.SupplierDeliveryId.ToString(),
			ControlMinReq : Convert.ToBoolean(row.ControlMinReq),
			MinReq : ReadDbNull(row))

	def ReadDbNull(row as duck):
		return Convert.ToUInt32(row.MinReq) if not row.MinReq isa DBNull

def ToSql(value as object):
	if value == null:
		return "null"
	if value isa string:
		return "'" + value.ToString() + "'"
	if value isa bool:
		if cast(bool, value):
			return "1"
		else:
			return "0"
	return value.ToString()

sql = """
select ai.*, i.RegionId, i.PriceId, i.ClientId
from future.intersection i
join future.clients c on c.id = i.clientid
join future.addresses a on a.clientid = c.id
join future.addressintersection ai on ai.IntersectionId = i.id and a.Id = ai.AddressId
where c.Id in (958, 961, 1107, 1395, 1555, 3417, 3418, 4610, 6534)
and (ai.supplierDeliveryId is not null or ai.controlMinReq <> 0 or ai.MinReq is not null)
"""
sql1 = """
select ai.*, i.RegionId, i.PriceId, i.ClientId
from future.intersection i
join future.clients c on c.id = i.clientid
join future.addresses a on a.clientid = c.id
join future.addressintersection ai on ai.IntersectionId = i.id and a.Id = ai.AddressId
where c.Id in (958, 961, 1107, 1395, 1555, 3417, 3418, 4610, 6534)
"""
getc = Db.GetConnectionString
Db.GetConnectionString = {"server=127.0.0.1; user=root"}
etalon = List[of Data]()
for row in Db.Read(sql):
	d = Data().Read(row)
	etalon.Add(d)

print etalon.Count

Db.GetConnectionString = getc
current = List[of Data]()
for row in Db.Read(sql1):
	current.Add(Data().Read(row))

print current.Count

for c in current:
	et = etalon.FirstOrDefault({e as Data| c.ClientId == e.ClientId and c.RegionId == e.RegionId and c.PriceId == e.PriceId and e.AddressId == c.AddressId})
	if not et:
		continue
	if et.SupplierDeliveryId != c.SupplierDeliveryId \
		or et.MinReq != c.MinReq \
		or c.ControlMinReq != et.ControlMinReq:
		print "clientId = ${et.ClientId}, regionId = ${et.RegionId}, priceId = ${et.PriceId}, minReq = ${et.MinReq}, ${c.MinReq}, controlMinReq = ${et.ControlMinReq}, ${c.ControlMinReq}, SupplierClientId = ${et.SupplierDeliveryId}, ${c.SupplierDeliveryId}"
		print ToSql(et.MinReq)
		updateSql = "update future.AddressIntersection set SupplierDeliveryId = ${ToSql(et.SupplierDeliveryId)}, MinReq = ${ToSql(et.MinReq)}, ControlMinReq = ${ToSql(et.ControlMinReq)} where id = ${c.Id}"
		print updateSql
		Db.Execute(updateSql)