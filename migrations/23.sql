drop procedure if exists reports.GetFirmCr;

create definer = 'RootDBMS'@'127.0.0.1'
procedure reports.GetFirmCr(in inFilter varchar(255), in inID bigint)
begin
  declare filterStr varchar(257);
  if ((inFilter is not null) and (length(inFilter) > 0)) then
    set filterStr = concat('%', inFilter, '%');
    select
      p.Id as ID,
      p.Name as DisplayValue
    from
      catalogs.Producers p
    where
      p.Name like filterStr
    order by DisplayValue;
  else
    select
      p.Id as ID,
      p.Name as DisplayValue
    from
      catalogs.Producers p
    order by DisplayValue;
  end if;
end