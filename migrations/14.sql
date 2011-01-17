create table logs.RecordCalls(
  Id int unsigned not null AUTO_INCREMENT,
  `From` varchar(45) not null,
  `To` varchar(45) not null,
  PRIMARY KEY (Id)
) ENGINE=InnoDB DEFAULT CHARSET=cp1251;