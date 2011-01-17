drop table Billing.Recipients;

create table Billing.Recipients(
Id int not null auto_increment,
Name varchar(255),
primary key (id)
);

alter table Billing.Payers
add column RecipientId int;
