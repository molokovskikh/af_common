update logs.document_logs
set Ready = 1
where logtime < curdate() - interval 10 day;

update logs.document_logs d
set d.Ready = 1
where d.AddressId is not null and Ready = 0 and logtime > curdate() - interval 10 day
and exists( select * from usersettings.AnalitFDocumentsProcessing ap where ap.DocumentId = d.RowId) ; 
