delete FROM catalogs.Assortment;
insert into catalogs.Assortment(ProductId, ProducerId)
select c.ProductId, c.CodeFirmCr
from farm.core0 c
where not exists(select * from catalogs.Assortment a where a.ProductId = c.ProductId and a.ProducerId = c.CodeFirmCr  ) and productid is not null and CodeFirmCr is not null
group by c.ProductId, c.CodeFirmCr;
insert into catalogs.Assortment(ProductId, ProducerId)
select ProductId, CodeFirmCr
from orders.orderslist
where productid is not null and CodeFirmCr is not null
group by ProductId, CodeFirmCr;