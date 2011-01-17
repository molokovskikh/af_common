alter table logs.CostOptimizationLogs add SupplierId INT UNSIGNED;

UPDATE logs.CostOptimizationLogs
   SET SupplierId = 5;