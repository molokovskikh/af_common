DROP TEMPORARY TABLE IF EXISTS DeletingId;

CREATE TEMPORARY TABLE DeletingId ENGINE Memory
SELECT
  cg.ID
FROM
  ClientsData cd
  JOIN contacts.contact_groups cg ON cg.ContactGroupOwnerId = cd.ContactGroupOwnerId
WHERE
  cd.FirmType = 1
  AND cg.Type = 7;

DELETE FROM contacts.contacts 
WHERE ContactOwnerId IN
(select ID from DeletingId);

DELETE FROM contacts.RegionalDeliveryGroups
WHERE ContactGroupId in
(SELECT ID FROM DeletingId);

DELETE FROM contacts.contact_groups
WHERE Id in
(SELECT ID FROM DeletingId);

DELETE FROM contacts.contact_owners
WHERE Id in
(SELECT ID FROM DeletingId);