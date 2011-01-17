DROP PROCEDURE IF EXISTS reports.GetCostOptimizationClientCode;
CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE reports.GetCostOptimizationClientCode(in inFilter varchar(255), in inID bigint)
begin
  declare filterStr varchar(257);
  if (inID is not null) then
    select
      cd.FirmCode as ID,
      cd.ShortName,
      convert(concat(cd.FirmCode, '-', cd.ShortName) using cp1251) as DisplayValue
    from
      usersettings.clientsdata cd
      join usersettings.CostOptimizationClients co on co.ClientId = cd.FirmCode
    where
          cd.FirmCode = inID
      and cd.firmtype = 1
      and cd.FirmStatus = 1
    UNION ALL
      select
      cl.ID,
      cl.Name ShortName,
      convert(concat(cl.Id, '-', cl.Name) using cp1251) as DisplayValue
    from
      future.Clients cl
      join usersettings.CostOptimizationClients co on co.ClientId = cl.ID
    where
          cl.Id = inID
      and cl.Status = 1
    order by ShortName;
  else
    if ((inFilter is not null) and (length(inFilter) > 0)) then
      set filterStr = concat('%', inFilter, '%');
      select
        cd.FirmCode as ID,
        cd.ShortName,
        convert(concat(cd.FirmCode, '-', cd.ShortName) using cp1251) as DisplayValue
      from
        usersettings.clientsdata cd
        join usersettings.CostOptimizationClients co on co.ClientId = cd.FirmCode
      where
           cd.ShortName like filterStr
        and cd.firmtype = 1
        and cd.FirmStatus = 1
      UNION ALL
        select
        cl.ID,
        cl.Name ShortName,
        convert(concat(cl.Id, '-', cl.Name) using cp1251) as DisplayValue
      from
        future.Clients cl
        join usersettings.CostOptimizationClients co on co.ClientId = cl.ID
      where
            cl.Name like filterStr
        and cl.Status = 1
      order by ShortName;
    else
      select
        cd.FirmCode as ID,
        cd.ShortName,
        convert(concat(cd.FirmCode, '-', cd.ShortName) using cp1251) as DisplayValue
      from
        usersettings.clientsdata cd
        join usersettings.CostOptimizationClients co on co.ClientId = cd.FirmCode
      where
            cd.firmtype = 1
        and cd.FirmStatus = 1
      UNION ALL
        select
        cl.ID,
        cl.Name ShortName,
        convert(concat(cl.Id, '-', cl.Name) using cp1251) as DisplayValue
      from
        future.Clients cl
        join usersettings.CostOptimizationClients co on co.ClientId = cl.ID
      where
            cl.Status = 1
      order by ShortName;
    end if;
  end if;
end