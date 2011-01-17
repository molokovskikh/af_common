insert into reports.report_type_properties 
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, SelectStoredProcedure, DefaultValue) 
values 
  (12, 'PriceCode', 'Прайс-лист', 'INT', 1, 'GetPriceCode', 0),
  (12, 'ReportIsFull', 'По всему ассортименту', 'BOOL', 1, null, 0);