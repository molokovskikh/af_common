INSERT INTO reports.Report_Type_Properties 
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, DefaultValue)
VALUES
  (10, 'ByPreviousMonth', 'За предыдущий месяц', 'BOOL', 0, 0);

INSERT INTO reports.Report_Type_Properties 
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, DefaultValue)
VALUES
  (10, 'ReportInterval', 'Интервал отчета (дни) от текущей даты', 'INT', 0, 1);

UPDATE reports.Report_Type_Properties
   SET DisplayName = 'Клиент (все если не задан)'
 where ReportTypeCode = 10
   and PropertyName = 'ClientCode';