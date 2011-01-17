insert into logs.DocumentSendLogs(UserId, DocumentId, UpdateId)
select af.UserId, dl.RowId, af.UpdateId
from usersettings.AnalitFDocumentsProcessing A
join logs.AnalitFUpdates af on af.UpdateId = a.UpdateId
join logs.document_logs dl on dl.RowId = a.DocumentId
join Future.Users u on u.Id = af.UserId
where dl.AddressId is not null;