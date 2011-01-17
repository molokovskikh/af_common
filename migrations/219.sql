insert into Reports.ReportTypes(ReportTypeName, ReportTypeFilePrefix, AlternateSubject, ReportClassName)
values('Обезличенные предложения для аптеки с привязкой по прайс-листу', 'Offers', 'Обезличенные предложения для аптеки с привязкой по прайс-листу', 'FormaterLibrary.Special.OffersReport');

insert into Reports.report_type_properties(ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue)
select ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, PropertyEnumId, SelectStoredProcedure, DefaultValue
from Reports.report_type_properties
where ReportTypeCode = 5;

