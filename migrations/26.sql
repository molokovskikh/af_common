#удаляем задания, которые не привязаны ни к чему
delete
from
  farm.UnrecExp
using
  farm.UnrecExp,
(
select
newUnrecExp.PriceItemId
from
  (select distinct PriceItemId from farm.UnrecExp) newUnrecExp
  left join usersettings.PricesCosts pc on (pc.PriceItemId = newUnrecExp.PriceItemId)
where
  ((pc.CostCode is null))
) delUnrecExp
where
  UnrecExp.PriceItemId = delUnrecExp.PriceItemId;

alter table Farm.UnrecExp
  drop column Name2, 
  drop column Name3,
  drop column BaseCost,
  add column `ProductSynonymId` int unsigned DEFAULT NULL,
  add column `ProducerSynonymId` int unsigned DEFAULT NULL,
  add constraint FK_UnrecExp_ProductSynonymId FOREIGN KEY (ProductSynonymId) REFERENCES Farm.Synonym(SynonymCode) ON DELETE SET NULL ON UPDATE RESTRICT,
  add constraint FK_UnrecExp_ProducerSynonymId FOREIGN KEY (ProducerSynonymId) REFERENCES Farm.SynonymFirmCr(SynonymFirmCrCode) ON DELETE SET NULL ON UPDATE RESTRICT;