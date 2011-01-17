delete
from
  farm.blockedprice
using
  farm.blockedprice
  left join usersettings.priceitems on priceitems.id = blockedprice.PriceItemId
where
  priceitems.id is null;

alter table farm.blockedprice
  add constraint FK_BlockedPrice_PriceItemId foreign key (PriceItemId) references usersettings.priceitems(Id) on delete cascade on update restrict;
