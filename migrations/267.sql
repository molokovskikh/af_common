drop temporary table if exists future.TmpTableForUpdating;
create temporary table future.TmpTableForUpdating
(
Id int unsigned
) engine=MEMORY;
insert into future.TmpTableForUpdating
 select i.Id from future.Intersection as i
   join logs.IntersectionLogs il on il.IntersectionId = i.Id and il.operation=0 and il.AvailableForClient = 1 and il.ClientId > 10000
   join usersettings.pricesdata pd on (pd.PriceCode = il.PriceId and pd.PriceType = 2)
where i.AvailableForClient = 1;
update future.Intersection as ii, future.TmpTableForUpdating as Tmp set ii.AvailableForClient = 0 where ii.Id=Tmp.Id;
drop temporary table if exists future.TmpTableForUpdating;