DROP TABLE IF EXISTS `telephony`.`UnresolvedPhone`;
CREATE TABLE  `telephony`.`UnresolvedPhone` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Phone` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=cp1251;