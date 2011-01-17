delete
from
  farm.zero
using
  farm.zero
  left join usersettings.priceitems on priceitems.id = zero.PriceItemId
where
  priceitems.id is null;

alter table farm.zero
  add constraint FK_Zero_PriceItemId foreign key (PriceItemId) references usersettings.priceitems(Id) on delete cascade on update restrict;