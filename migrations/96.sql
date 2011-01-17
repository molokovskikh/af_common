DROP TEMPORARY TABLE IF EXISTS DuplicatedId;

CREATE TEMPORARY TABLE DuplicatedId engine memory
SELECT
  s1.Id
FROM
  usersettings.SupplierIntersection s1
group by s1.ClientId, s1.SupplierId
having COUNT(*) > 1;

DELETE
FROM
  usersettings.SupplierIntersection
WHERE
  Id IN
  (SELECT
    Id
  FROM
    DuplicatedId);

DROP TEMPORARY TABLE DuplicatedId;

ALTER TABLE usersettings.SupplierIntersection
  ADD UNIQUE (ClientId, SupplierId);