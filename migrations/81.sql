create table contacts.RegionalDeliveryGroups
(
  ContactGroupId INT UNSIGNED NOT NULL REFERENCES contacts.contact_groups(Id),
  RegionId BIGINT UNSIGNED NOT NULL REFERENCES farm.Regions(RegionCode),
  CONSTRAINT PK_RegionalDeliveryGroup PRIMARY KEY(ContactGroupId, RegionId)
);