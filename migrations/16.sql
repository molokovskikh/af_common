alter table farm.core0
  add column QuantityUpdate timestamp not null default '0000-00-00 00:00:00',
  modify column UpdateTime timestamp not null default '0000-00-00 00:00:00'
;