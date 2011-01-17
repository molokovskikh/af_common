DROP TABLE IF EXISTS `telephony`.`NoRecordPhones`;
CREATE TABLE  `telephony`.`NoRecordPhones` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `To` varchar(10) DEFAULT NULL,
  `From` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=cp1251;