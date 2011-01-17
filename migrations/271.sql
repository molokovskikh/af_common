insert into reports.report_properties(ReportCode, PropertyId, PropertyValue)
select reportcode, 193, 1
from reports.reports
where reporttypecode = 12;
insert into reports.report_properties(ReportCode, PropertyId, PropertyValue)
select reportcode, 194, 1
from reports.reports
where reporttypecode = 12;