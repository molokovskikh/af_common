insert into Reports.ReportTypes(ReportTypeName, ReportTypeFilePrefix, AlternateSubject, ReportClassName)
values('Доля поставщика в заказах аптек', 'SupplierMarketShareByUser', 'Доля поставщика в заказах аптек', 'Inforoom.ReportSystem.ByOrders.SupplierMarketShareByUser');

set @id = last_insert_id();

insert into reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select @id, 'ByPreviousMonth', 'За предыдущий месяц', 'BOOL', 0, null, null, 1;

insert into reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select @id, 'SupplierId', 'Поставщик', 'INT', 0, null, 'GetFirmCode', 1;

insert into reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select @id, 'Regions', 'Регионы', 'LIST', 0, null, 'GetRegion', 1;

insert into reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select @id, 'ReportInterval', 'Интервал отчета (дни) от текущей даты', 'INT', 1, null, null, 7;
