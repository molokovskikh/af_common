SET @reportType = (select ReportTypeCode from reports.reporttypes where ReportClassName = 'Inforoom.ReportSystem.DefReport');
update reports.Report_Type_Properties
   set SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportType
   and PropertyName = 'ClientCode';

SET @reportType = (select ReportTypeCode from reports.reporttypes where ReportClassName = 'Inforoom.ReportSystem.SpecReport');
update reports.Report_Type_Properties
   set SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportType
   and PropertyName = 'ClientCode';

SET @reportType = (select ReportTypeCode from reports.reporttypes where ReportClassName = 'Inforoom.ReportSystem.SpecShortReport');
update reports.Report_Type_Properties
   set SelectStoredProcedure = 'GetClientCodeWithNewUsers'
 where ReportTypeCode = @reportType
   and PropertyName = 'ClientCode';