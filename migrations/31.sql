delete
from
  farm.forb
using
  farm.forb
  left join usersettings.priceitems on priceitems.id = forb.PriceItemId
where
  priceitems.id is null;

alter table farm.forb
  add constraint FK_Forb_PriceItemId foreign key (PriceItemId) references usersettings.priceitems(Id) on delete cascade on update restrict;
