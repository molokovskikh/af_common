DROP PROCEDURE IF EXISTS reports.GetCostOptimizationFirmCode;

CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE reports.GetCostOptimizationFirmCode(in inFilter varchar(255), in inID bigint)
begin
  declare filterStr varchar(257);
  if (inID is not null) then
    select
      cd.FirmCode as ID,
      convert(concat(cd.FirmCode, '-', cd.ShortName, ' - ', rg.Region) using cp1251) as DisplayValue
    from
      usersettings.clientsdata cd,
      farm.regions rg,
      usersettings.CostOptimizationRules cor
    where
          cd.FirmCode = inID
      and cd.firmtype = 0
      and rg.RegionCode = cd.RegionCode
      and cor.SupplierId = cd.FirmCode
    order by cd.ShortName;
  else
    if ((inFilter is not null) and (length(inFilter) > 0)) then
      set filterStr = concat('%', inFilter, '%');
      select
        cd.FirmCode as ID,
        convert(concat(cd.FirmCode, '-', cd.ShortName, ' - ', rg.Region) using cp1251) as DisplayValue
      from
        usersettings.clientsdata cd,
        farm.regions rg,
      usersettings.CostOptimizationRules cor
      where
            cd.ShortName like filterStr
        and cd.firmtype = 0
        and rg.RegionCode = cd.RegionCode
        and cor.SupplierId = cd.FirmCode
      order by cd.ShortName;
    else
      select
        cd.FirmCode as ID,
        convert(concat(cd.FirmCode, '-', cd.ShortName, ' - ', rg.Region) using cp1251) as DisplayValue
      from
        usersettings.clientsdata cd,
        farm.regions rg,
        usersettings.CostOptimizationRules cor
      where
            cd.firmtype = 0
        and rg.RegionCode = cd.RegionCode
        and cor.SupplierId = cd.FirmCode
      order by cd.ShortName;
    end if;
  end if;
end