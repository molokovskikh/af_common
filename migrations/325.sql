delete from farm.BuyingMatrix;

alter table farm.BuyingMatrix
  drop foreign key FK_BuyingMatrix_AssortmentId;
