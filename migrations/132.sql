DROP PROCEDURE IF EXISTS reports.GetClientCodeWithNewUsers;

CREATE DEFINER = 'RootDBMS'@'127.0.0.1'
PROCEDURE reports.GetClientCodeWithNewUsers(in inFilter varchar(255), in inID bigint)
begin
  declare filterStr varchar(257);
  if (inID is not null) then
    select
      cd.FirmCode as ID,
      cd.ShortName,
      convert(concat(cd.FirmCode, '-', cd.ShortName) using cp1251) as DisplayValue
    from
      usersettings.clientsdata cd
    where
          cd.FirmCode = inID
      and cd.firmtype = 1
      and cd.FirmStatus = 1
    union
      select
      cl.Id,
      cl.Name ShortName,
      convert(concat(cl.ID, '-', cl.Name) using cp1251) as DisplayValue
    from
      future.Clients cl
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
      where
           cd.ShortName like filterStr
        and cd.firmtype = 1
        and cd.FirmStatus = 1
      union
       select
        cl.Id,
        cl.Name ShortName,
        convert(concat(cl.Id, '-', cl.Name) using cp1251) as DisplayValue
      from
        future.Clients cl
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
      where
            cd.firmtype = 1
        and cd.FirmStatus = 1
      union
       select
        cl.Id,
        cl.Name ShortName,
        convert(concat(cl.Id, '-', cl.Name) using cp1251) as DisplayValue
      from
        future.Clients cl
      where
            cl.Status = 1
      order by ShortName;
    end if;
  end if;
end