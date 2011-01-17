delete
from
  farm.forbidden
using
  farm.forbidden
  left join usersettings.pricesdata on pricesdata.PriceCode = forbidden.PriceCode
where
  pricesdata.PriceCode is null;

alter table farm.forbidden
  add constraint FK_Forbidden_PriceCode foreign key (PriceCode) references usersettings.pricesdata(PriceCode) on delete cascade on update restrict;
