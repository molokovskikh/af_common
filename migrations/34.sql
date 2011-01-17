delete
from
  farm.UnrecExp
using
  farm.UnrecExp
  left join usersettings.priceitems on priceitems.id = UnrecExp.PriceItemId
where
  priceitems.id is null;

alter table farm.UnrecExp
  add constraint FK_UnrecExp_PriceItemId foreign key (PriceItemId) references usersettings.priceitems(Id) on delete cascade on update restrict;