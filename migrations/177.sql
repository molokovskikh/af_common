delete from reports.ReportTypes
  where ReportTypeFilePrefix = 'PharmacyMixed';

update reports.ReportTypes
   set ReportTypeName = 'Смешанный для поставщика',
       AlternateSubject = 'Смешанный отчет для поставщика'
 where ReportTypeCode = 8;
       

insert into reports.ReportTypes 
  (ReportTypeFilePrefix, ReportClassName, ReportTypeName, AlternateSubject)
values
  ('PharmacyMixed', 'Inforoom.ReportSystem.PharmacyMixedReport', 'Смешанный для аптеки', 'Смешанный отчет для аптеки');

set @reportTypeCode = LAST_INSERT_ID();

insert into reports.Report_Type_Properties
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumID, SelectStoredProcedure, DefaultValue)

select @reportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumID, SelectStoredProcedure, DefaultValue
  from reports.Report_Type_Properties
 where ReportTypeCode = 8
   and PropertyName <> 'ShowCode'
   and PropertyName <> 'ShowCodeCr';

update reports.Report_Type_Properties
   set DisplayName = 'Аптека',
       SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportTypeCode
   and PropertyName = 'SourceFirmCode';

update reports.Report_Type_Properties
   set SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportTypeCode
   and PropertyName = 'BusinessRivals';