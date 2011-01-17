alter table future.Users add Registrant varchar(100);
alter table future.Users add RegistrationDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP;