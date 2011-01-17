alter table future.Intersection
change column SupplierPaymentId SupplierPaymentId varchar(200);

alter table future.AddressIntersection
change column SupplierDeliveryId SupplierDeliveryId varchar(200);
