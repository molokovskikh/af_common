# Триггер, в котором изменялись настройки Intersection для прайс-листа 2647
# Есть код, который надо прокомметрировать: опреденные настройки для определенных BillingCode
drop trigger if exists usersettings.IntersectionBeforeInsert;
CREATE 
	DEFINER = `RootDBMS`@`127.0.0.1`
TRIGGER usersettings.IntersectionBeforeInsert
	BEFORE INSERT
	ON usersettings.Intersection
	FOR EACH ROW
BEGIN

#Новые поставщики для НатурПродукт отключаются с обеих сторон
  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2401,2821,2527,100,106)) then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

#Новые поставщики для ГУП и ФармГрад отключаются со стороны клиента
  if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2520,2497)) then
    set new.disabledbyclient=1;
  end if;


#Новые поставщики для НатурПродукт Ритэйл отключаются с обеих сторон в СпБ
 if exists (select FirmCode from clientsdata where firmcode=new.clientcode and billingcode in (2381)) and new.RegionCode=8192 then
    set new.disabledbyclient=1;
    set new.invisibleonclient=1;
  end if;

#Отключение прайслиста Запрет НП всем, кроме Натура
 if exists (SELECT FirmCode FROM ClientsData
where BillingCode not in (2502,1546,2345,100,2501,2411,2622,2805,2381,2401,2471,2823,2472,2821,2527)
and  FirmCode = new.clientcode) and new.PriceCode=2355 then
    set new.invisibleonclient=1;
end if;


#Создание несуществующих записей в SupplierIntersection
if not exists (select Id from PricesData pd join SupplierIntersection sint ON
      sint.ClientId = new.ClientCode AND sint.SupplierId = pd.FirmCode
  where pd.PriceCode = new.PriceCode) and exists(select FirmCode from PricesData where PriceCode = new.PriceCode) then
    insert into SupplierIntersection (ClientId, SupplierId)
      values (new.ClientCode, (select FirmCode from PricesData where PriceCode = new.PriceCode));
  end if;

end;