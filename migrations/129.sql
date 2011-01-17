insert into reports.Report_Type_Properties 
  (ReportTypeCode, PropertyName, DisplayName, PropertyType, SelectStoredProcedure, Optional, DefaultValue)
select rt.ReportTypeCode, 
       'ClientCode', 'Клиент', 'INT', 
       'GetCostOptimizationClientCode', 0, 0
  from reports.reporttypes rt
 where rt.ReportClassName = 'Inforoom.ReportSystem.OptimizationEfficiency'
   and not EXISTS(select * 
                    from reports.Report_Type_Properties rtp
                   where rtp.ReportTypeCode = rt.ReportTypeCode
                     and rtp.PropertyName = 'ClientCode')