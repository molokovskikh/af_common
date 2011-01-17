alter table Farm.UnrecExp
  add column `PriorProductId` int unsigned DEFAULT NULL,
  add column `PriorProducerId` int unsigned DEFAULT NULL;

update Farm.UnrecExp
set
  PriorProductId = TmpProductId,
  PriorProducerId = TmpCodeFirmCr;

alter table Farm.UnrecExp
  drop column TmpProductId,
  drop column TmpCodeFirmCr;