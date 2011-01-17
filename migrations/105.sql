DROP TRIGGER IF EXISTS usersettings.IntersectionBeforeInsert;

CREATE TRIGGER usersettings.IntersectionBeforeInsert
BEFORE INSERT
ON usersettings.Intersection
FOR EACH ROW
BEGIN

  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2401,2821,2527,100,106)) then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;
  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2497)) then
    set new.disabledbyclient=1;
  end if;
 if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2381)) and new.RegionCode=8192 then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;
 if exists (SELECT FirmCode FROM ClientsData
where BillingCode not in (2502,1546,2345,100,2501,2411,2622,2805,2381,2401,2471,2823,2472,2821,2527)
and  FirmCode = new.clientcode) and new.PriceCode=2355 then
    set new.invisibleonclient=1;
end if;
if not exists (select Id from PricesData pd join SupplierIntersection sint ON
      sint.ClientId = new.ClientCode AND sint.SupplierId = pd.FirmCode
  where pd.PriceCode = new.PriceCode) and exists(select FirmCode from PricesData where PriceCode = new.PriceCode) then
    insert into SupplierIntersection (ClientId, SupplierId)
      values (new.ClientCode, (select FirmCode from PricesData where PriceCode = new.PriceCode));
  end if;
  if NEW.PriceCode=2647 then
    if (SELECT SmartOrderRuleId is not null FROM RetClientsSet where ClientCode=new.clientcode)
    then
      Set New.invisibleonclient=0;
      set new.disabledbyclient=0;
      set new.CostCode=2647;
    else
      Set New.invisibleonclient=1;
    end if;
  else
    if exists (select billingcode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2979,2497) and (new.clientcode not in (3390, 3923, 3924,4914,4949,4950)))
    then
      Set New.invisibleonfirm=1;
      set new.invisibleonclient=1;
      set new.CostCode=null;
    end if;
  end if;
end;