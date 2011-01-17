alter table `documents`.`DocumentHeaders`
  add column `DownloadId` int(10) unsigned default null after `Id`,
  add CONSTRAINT `FK_DocumentHeaders_DownloadId` FOREIGN KEY (`DownloadId`) REFERENCES `logs`.`document_logs` (`RowId`) ON DELETE SET NULL;
