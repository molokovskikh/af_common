alter table future.Users
add column SubmitOrders tinyint(1) unsigned not null default 0;
alter table future.Clients
drop column ShowRegionMask;