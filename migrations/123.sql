alter table Logs.CostOptimizationLogs
add column ClientId int unsigned after LoggedOn,
add index (ClientId)
;
