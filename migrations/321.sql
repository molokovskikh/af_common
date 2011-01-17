
ALTER TABLE `future`.`Intersection`
add constraint FK_Intersection_LegalEntityId foreign key (LegalEntityId) references Billing.LegalEntities(Id);
