insert into reports.report_type_properties
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, Optional, SelectStoredProcedure, DefaultValue)
select
  4, 'ClientCodeEqual', 'Список значений "Клиент"', 'LIST', 1, 'GetAllClientCode', 0
from dual
where not exists(select 1
               from reports.report_type_properties
              where ReportTypeCode=4 and PropertyName='ClientCodeEqual')