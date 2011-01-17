SET @reportType = (select ReportTypeCode from reports.reporttypes where ReportClassName = 'Inforoom.ReportSystem.CombReport');

delete from reports.report_type_properties 
  where ReportTypeCode = @reportType and PropertyName = 'FirmCodeEqual';

insert into reports.report_type_properties 
  (ReportTypeCode, DisplayName, PropertyName, PropertyType, SelectStoredProcedure, DefaultValue, Optional)
VALUES
  (@reportType, 'Список поставщиков', 'FirmCodeEqual', 'LIST', 'GetAllFirmCode', 0, 1);

update reports.Report_Type_Properties
   set SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportType
   and PropertyName = 'ClientCode';