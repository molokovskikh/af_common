insert into reports.report_type_properties (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, DefaultValue)
values (12, 'IncludeProducer', 'Учитывать изготовителя', 'BOOL', 0, 1),
(12, 'IncludeQuantity', 'Показывать остатки', 'BOOL', 0, 1),
(12, 'CostDiffThreshold', 'Оставить в отчете позиции, по кототорым вторая цена больше первой более, чем на X%', 'INT', 1, 0);

