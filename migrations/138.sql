CREATE TABLE  `telephony`.`NoRecordPhones` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Phone` varchar(10) DEFAULT NULL,
  `Enabled` tinyint(1) unsigned DEFAULT '0',
  `Comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;

insert into telephony.NoRecordPhones(Phone, Enabled, `Comment`)
Values('9081313250','1', 'test external number'), ('134','1', 'test local number');