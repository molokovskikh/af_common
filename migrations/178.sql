delete from reports.ReportTypes
  where ReportTypeFilePrefix = 'PharmacyOffers';

insert into reports.ReportTypes 
  (ReportTypeFilePrefix, ReportClassName, ReportTypeName, AlternateSubject)
values
  ('PharmacyOffers', 'Inforoom.ReportSystem.FastReports.PharmacyOffersReport', 'Предложения для аптеки', 'Отчет по предложениям для аптеки');

set @reportTypeCode = LAST_INSERT_ID();

insert into reports.Report_Type_Properties
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, SelectStoredProcedure, DefaultValue)
values
  (@reportTypeCode, 'ClientCode', 'Клиент', 'INT', 0, 'GetClientCodeWithNewUsers', 1);