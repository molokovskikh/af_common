update
  farm.Core0
  left join catalogs.Producers on Producers.Id = Core0.CodeFirmCr
set
  Core0.CodeFirmCr = null
where
(Core0.CodeFirmCr is not null)
and (Producers.Id is null);

#Warning 1478 InnoDB: assuming ROW_FORMAT=COMPACT. 
#Это сообщение получается после создания ключа.
alter table farm.Core0
  add constraint FK_Core_ProducerId FOREIGN KEY (CodeFirmCr) REFERENCES catalogs.Producers(Id) on delete set null on update restrict;