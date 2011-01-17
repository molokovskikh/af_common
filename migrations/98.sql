INSERT INTO usersettings.SupplierIntersection (ClientId, SupplierId)
SELECT DISTINCT intr.ClientCode, pd.FirmCode
FROM
  usersettings.Intersection intr
  JOIN usersettings.PricesData pd ON pd.PriceCode = intr.PriceCode
where not EXISTS(
  select 1
    from usersettings.SupplierIntersection sint 
   where sint.ClientId = intr.ClientCode
     and sint.SupplierId = pd.FirmCode)