alter table logs.document_logs
  add column `SendUpdateId` int unsigned DEFAULT NULL,
  add CONSTRAINT `FK_document_logs_SendUpdateId` FOREIGN KEY (`SendUpdateId`) REFERENCES `analitfupdates` (`UpdateId`) ON DELETE CASCADE ON UPDATE CASCADE;