DROP PROCEDURE IF EXISTS ordersendrules.GetOrderSendConfig;

CREATE DEFINER='RootDBMS'@'127.0.0.1' PROCEDURE ordersendrules.GetOrderSendConfig(IN idparam INTEGER UNSIGNED)
BEGIN
  DECLARE delivery varchar(1000);
SET delivery =(
    select ifnull(GROUP_CONCAT(ct.ContactText SEPARATOR ','), 'tech@analit.net')
      from orders.OrdersHead ord
            join usersettings.PricesData prd on prd.PriceCode = ord.PriceCode
            join usersettings.ClientsData supp on supp.FirmCode = prd.FirmCode
            join contacts.Contact_Groups cgr on cgr.ContactGroupOwnerId = supp.ContactGroupOwnerId
            join contacts.RegionalDeliveryGroups rdgr on rdgr.ContactGroupId = cgr.Id and rdgr.RegionId = ord.RegionCode
            join contacts.Contacts ct on ct.ContactOwnerId = cgr.Id
            left join usersettings.ClientsData oldCust on oldCust.FirmCode = ord.ClientCode
            left join future.Clients newCust on newCust.Id = ord.ClientCode
      where ord.RowId = idparam
        and (oldCust.BillingCode <> 921 or oldCust.firmCode is null)
        and (newCust.PayerId <> 921 or newCust.Id is null)
 );

IF (SELECT count(*) > 0
  FROM OrderSendRules.order_send_rules osr
    JOIN usersettings.pricesdata pd on pd.firmcode = osr.firmcode
      JOIN orders.ordershead oh on oh.pricecode = pd.pricecode and osr.RegionCode = oh.RegionCode
   WHERE oh.rowid = idparam) THEN


if (select AddressId from Orders.OrdersHead where rowid = idparam) is null then

   SELECT osr.id,
          delivery Destination,
          ohs.ClassName as SenderClassName,
          ohf.ClassName as FormaterClassName,
          ErrorNotificationDelay,
          SendDebugMessage
   FROM OrderSendRules.order_send_rules osr
      JOIN OrderSendRules.order_handlers ohs on ohs.Id = osr.SenderId
      JOIN OrderSendRules.order_handlers ohf on ohf.Id = osr.FormaterId
      JOIN usersettings.pricesdata pd on pd.firmcode = osr.firmcode
        JOIN orders.ordershead oh on oh.pricecode = pd.pricecode and osr.RegionCode = oh.RegionCode
          JOIN usersettings.regionaldata rd on rd.regioncode = oh.regioncode and rd.firmcode = pd.firmcode
            JOIN usersettings.clientsdata cd on cd.firmcode = pd.firmcode
              JOIN usersettings.clientsdata customer on customer.firmcode = oh.clientcode
   WHERE oh.rowid = idparam;

else

   SELECT osr.id,
          delivery Destination,
          ohs.ClassName as SenderClassName,
          ohf.ClassName as FormaterClassName,
          ErrorNotificationDelay,
          SendDebugMessage
   FROM OrderSendRules.order_send_rules osr
      JOIN OrderSendRules.order_handlers ohs on ohs.Id = osr.SenderId
      JOIN OrderSendRules.order_handlers ohf on ohf.Id = osr.FormaterId
      JOIN usersettings.pricesdata pd on pd.firmcode = osr.firmcode
        JOIN orders.ordershead oh on oh.pricecode = pd.pricecode and osr.RegionCode = oh.RegionCode
          JOIN usersettings.regionaldata rd on rd.regioncode = oh.regioncode and rd.firmcode = pd.firmcode
            JOIN usersettings.clientsdata cd on cd.firmcode = pd.firmcode
              JOIN Future.Clients customer on customer.Id = oh.clientcode
   WHERE oh.rowid = idparam;

end if;

ELSE

  if (select AddressId from Orders.OrdersHead where rowid = idparam) is null then

   SELECT osr.id,
          delivery Destination,
          ohs.ClassName as SenderClassName,
          ohf.ClassName as FormaterClassName,
          ErrorNotificationDelay,
          SendDebugMessage
    FROM OrderSendRules.order_send_rules osr
      JOIN OrderSendRules.order_handlers ohs on ohs.Id = osr.SenderId
      JOIN OrderSendRules.order_handlers ohf on ohf.Id = osr.FormaterId
      JOIN usersettings.pricesdata pd on pd.firmcode = osr.firmcode
        JOIN orders.ordershead oh on oh.pricecode = pd.pricecode
          JOIN usersettings.regionaldata rd on rd.regioncode = oh.regioncode and rd.firmcode = pd.firmcode
            JOIN usersettings.clientsdata cd on cd.firmcode = pd.firmcode
              JOIN usersettings.clientsdata customer on customer.firmcode = oh.clientcode
   WHERE osr.RegionCode is null
         AND oh.rowid =  idparam;

  else

   SELECT osr.id,
          delivery Destination,
          ohs.ClassName as SenderClassName,
          ohf.ClassName as FormaterClassName,
          ErrorNotificationDelay,
          SendDebugMessage
    FROM OrderSendRules.order_send_rules osr
      JOIN OrderSendRules.order_handlers ohs on ohs.Id = osr.SenderId
      JOIN OrderSendRules.order_handlers ohf on ohf.Id = osr.FormaterId
      JOIN usersettings.pricesdata pd on pd.firmcode = osr.firmcode
        JOIN orders.ordershead oh on oh.pricecode = pd.pricecode
          JOIN usersettings.regionaldata rd on rd.regioncode = oh.regioncode and rd.firmcode = pd.firmcode
            JOIN usersettings.clientsdata cd on cd.firmcode = pd.firmcode
              JOIN Future.Clients customer on customer.Id = oh.clientcode
   WHERE osr.RegionCode is null
         AND oh.rowid =  idparam;

  end if;

END IF;
END;