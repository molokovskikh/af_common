DROP TABLE IF EXISTS orders.OrderedOffers;
CREATE TABLE orders.OrderedOffers
(
  ID INT UNSIGNED PRIMARY KEY REFERENCES orders.OrdersList(RowID) on UPDATE cascade on DELETE cascade,
  Unit VARCHAR(15),
  Volume VARCHAR(15),
  Note VARCHAR(50),
  Period VARCHAR(50),
  Doc VARCHAR(20),
  MinBoundCost DECIMAL(8, 2),
  VitallyImportant TINYINT(1),
  RegistryCost DECIMAL(8, 2),
  MaxBoundCost  DECIMAL(8, 2),
  CoreUpdateTime TIMESTAMP,
  CoreQuantityUpdate TIMESTAMP,
  ProducerCost DECIMAL(12, 6)
)