DROP PROCEDURE IF EXISTS contacts.FillEmails;

CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE contacts.FillEmails()
BEGIN

  DECLARE done INT DEFAULT 0;
  DECLARE suppId, cgroupId INT UNSIGNED;
  DECLARE regId BIGINT UNSIGNED;
  DECLARE regdCur CURSOR FOR select FirmCode, RegionCode from usersettings.RegionalData;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  OPEN regdCur;

  REPEAT
    FETCH regdCur INTO suppId, regId;
    IF NOT done THEN

      insert into contacts.contact_owners values();
      set cgroupId = (select LAST_INSERT_ID());

      insert into contacts.contact_groups (Id, Name, Type, Public, ContactGroupOwnerId)
        select cgroupId, concat('Доставка заказов ', region.Region), 7, 0, supplier.ContactGroupOwnerId
          from usersettings.ClientsData supplier
                 join farm.Regions region on region.RegionCode = regId
         where supplier.FirmCode = suppId;

        insert into contacts.Contacts (Type, ContactText, ContactOwnerId)
          select 0, rd.AdminMail, cgroupId
            from usersettings.ClientsData supplier
                 join usersettings.RegionalData rd on rd.FirmCode = supplier.FirmCode
           where supplier.FirmType = 0
             and supplier.FirmCode = suppId
             and Length(rd.AdminMail) > 3
             and rd.RegionCode = regId
          union all
          select 0, rd.tmpMail, cgroupId
            from usersettings.ClientsData supplier
                 join usersettings.RegionalData rd on rd.FirmCode = supplier.FirmCode
           where supplier.FirmType = 0
             and supplier.FirmCode = suppId
             and Length(rd.tmpMail) > 3
             and rd.RegionCode = regId;

        insert into contacts.RegionalDeliveryGroups (ContactGroupId, RegionId)
          values (cgroupId, regId);

    END IF;
  UNTIL done END REPEAT;
END;

call contacts.FillEmails();

DROP PROCEDURE contacts.FillEmails;