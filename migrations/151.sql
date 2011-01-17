UPDATE reports.Report_Type_Properties
   SET DisplayName = 'Клиент',
       Optional = 1
 where ReportTypeCode = 10
   and PropertyName = 'ClientCode';