insert into Reports.ReportTypes(ReportTypeName, ReportTypeFilePrefix, AlternateSubject, ReportClassName)
values('Предложения для аптеки с разбивкой по листам', 'LeakOffers', 'Предложения для аптеки с разбивкой по листам', 'Inforoom.ReportSystem.LeakOffersReport');

set @id = last_insert_id();

insert into reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select @id, 'ClientCode', 'Клиент', 'INT', 0, null, 'GetClientCodeWithNewUsers', 1;
