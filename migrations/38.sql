insert into catalogs.Producers(id, name)
select codefirmcr, firmcr
from farm.catalogfirmcr;