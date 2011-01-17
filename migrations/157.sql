set @propertyId = (select rtp.ID
  from reports.report_type_properties rtp
where rtp.ReportTypeCode = 10 
  and rtp.PropertyName = 'FirmCode');

insert into reports.Report_Properties (ReportCode, PropertyID, PropertyValue)
select r.ReportCode, @propertyId, 5
  from reports.reports r
 where r.ReportTypeCode = 10
  and not EXISTS(
select 1
  from reports.report_type_properties rtp
       join reports.report_properties rp on rp.PropertyID = rtp.Id
where
      rtp.ReportTypeCode = 10 
  and rtp.PropertyName = 'FirmCode'
  and rp.ReportCode = r.ReportCode)