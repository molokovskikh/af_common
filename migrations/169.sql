drop trigger if exists usersettings.RetClientsSetLogDelete;
drop trigger if exists usersettings.RetClientsSetLogUpdate;
drop trigger if exists usersettings.RetClientsSetLogInsert;


CREATE 
	DEFINER = RootDBMS@127.0.0.1
TRIGGER usersettings.RetClientsSetLogDelete
	AFTER delete
	ON usersettings.RetClientsSet
	FOR EACH ROW
BEGIN
  INSERT 
  INTO `logs`.RetClientsSetLogs
  SET LogTime = now(),
    OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)), 
    OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)), 
    Operation = 2, 
    ClientCode = OLD.ClientCode,
    InvisibleOnFirm = OLD.InvisibleOnFirm,
    BaseFirmCategory = OLD.BaseFirmCategory,
    RetUpCost = OLD.RetUpCost,
    OverCostPercent = OLD.OverCostPercent,
    DifferenceCalculation = OLD.DifferenceCalculation,
    AlowRegister = OLD.AlowRegister,
    AlowRejection = OLD.AlowRejection,
    AlowDocuments = OLD.AlowDocuments,
    MultiUserLevel = OLD.MultiUserLevel,
    AdvertisingLevel = OLD.AdvertisingLevel,
    AlowWayBill = OLD.AlowWayBill,
    AllowDocuments = OLD.AllowDocuments,
    AlowChangeSegment = OLD.AlowChangeSegment,
    ShowPriceName = OLD.ShowPriceName,
    WorkRegionMask = OLD.WorkRegionMask,
    OrderRegionMask = OLD.OrderRegionMask,
    EnableUpdate = OLD.EnableUpdate,
    CheckCopyID = OLD.CheckCopyID,
    AlowCumulativeUpdate = OLD.AlowCumulativeUpdate,
    CheckCumulativeUpdateStatus = OLD.CheckCumulativeUpdateStatus,
    ServiceClient = OLD.ServiceClient,
    SubmitOrders = OLD.SubmitOrders,
    AllowSubmitOrders = OLD.AllowSubmitOrders,
    BasecostPassword = OLD.BasecostPassword,
    OrdersVisualizationMode = OLD.OrdersVisualizationMode,
    CalculateLeader = OLD.CalculateLeader,
    AllowPreparatInfo = OLD.AllowPreparatInfo,
    AllowPreparatDesc = OLD.AllowPreparatDesc,
    SmartOrderRuleId = OLD.SmartOrderRuleId,
    FirmCodeOnly = OLD.FirmCodeOnly,
    MaxWeeklyOrdersSum = OLD.MaxWeeklyOrdersSum,
    CheckWeeklyOrdersSum = OLD.CheckWeeklyOrdersSum,
    AllowDelayOfPayment = OLD.AllowDelayOfPayment,
    Spy = OLD.Spy,
    SpyAccount = OLD.SpyAccount,
    ShowNewDefecture = OLD.ShowNewDefecture,
    MigrateToPrgDataService = OLD.MigrateToPrgDataService;
END;


CREATE 
	DEFINER = RootDBMS@127.0.0.1
TRIGGER usersettings.RetClientsSetLogInsert
	AFTER insert
	ON usersettings.RetClientsSet
	FOR EACH ROW
BEGIN
  INSERT 
  INTO `logs`.RetClientsSetLogs
  SET LogTime = now(),
    OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)), 
    OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)), 
    Operation = 0, 
    ClientCode = NEW.ClientCode,
    InvisibleOnFirm = NEW.InvisibleOnFirm,
    BaseFirmCategory = NEW.BaseFirmCategory,
    RetUpCost = NEW.RetUpCost,
    OverCostPercent = NEW.OverCostPercent,
    DifferenceCalculation = NEW.DifferenceCalculation,
    AlowRegister = NEW.AlowRegister,
    AlowRejection = NEW.AlowRejection,
    AlowDocuments = NEW.AlowDocuments,
    MultiUserLevel = NEW.MultiUserLevel,
    AdvertisingLevel = NEW.AdvertisingLevel,
    AlowWayBill = NEW.AlowWayBill,
    AllowDocuments = NEW.AllowDocuments,
    AlowChangeSegment = NEW.AlowChangeSegment,
    ShowPriceName = NEW.ShowPriceName,
    WorkRegionMask = NEW.WorkRegionMask,
    OrderRegionMask = NEW.OrderRegionMask,
    EnableUpdate = NEW.EnableUpdate,
    CheckCopyID = NEW.CheckCopyID,
    AlowCumulativeUpdate = NEW.AlowCumulativeUpdate,
    CheckCumulativeUpdateStatus = NEW.CheckCumulativeUpdateStatus,
    ServiceClient = NEW.ServiceClient,
    SubmitOrders = NEW.SubmitOrders,
    AllowSubmitOrders = NEW.AllowSubmitOrders,
    BasecostPassword = NEW.BasecostPassword,
    OrdersVisualizationMode = NEW.OrdersVisualizationMode,
    CalculateLeader = NEW.CalculateLeader,
    AllowPreparatInfo = NEW.AllowPreparatInfo,
    AllowPreparatDesc = NEW.AllowPreparatDesc,
    SmartOrderRuleId = NEW.SmartOrderRuleId,
    FirmCodeOnly = NEW.FirmCodeOnly,
    MaxWeeklyOrdersSum = NEW.MaxWeeklyOrdersSum,
    CheckWeeklyOrdersSum = NEW.CheckWeeklyOrdersSum,
    AllowDelayOfPayment = NEW.AllowDelayOfPayment,
    Spy = NEW.Spy,
    SpyAccount = NEW.SpyAccount,
    ShowNewDefecture = NEW.ShowNewDefecture,
    MigrateToPrgDataService = NEW.MigrateToPrgDataService;
END;


CREATE 
	DEFINER = RootDBMS@127.0.0.1
TRIGGER usersettings.RetClientsSetLogUpdate
	AFTER update
	ON usersettings.RetClientsSet
	FOR EACH ROW
BEGIN

	if OLD.SmartOrderRuleId is null and NEW.SmartOrderRuleId is not null then
		UPDATE intersection
		SET    invisibleonclient=0,
			   disabledbyclient =0,
			   CostCode         =2647
		WHERE  PriceCode        =2647
		   AND ClientCode       =OLD.ClientCode;
	end if;

	if OLD.SmartOrderRuleId is not null and NEW.SmartOrderRuleId is null then
		UPDATE intersection
		SET    invisibleonclient=1
		WHERE  PriceCode        =2647
		   AND ClientCode       =OLD.ClientCode;
	end if;

IF(NEW.ClientCode!= OLD.ClientCode
OR NEW.InvisibleOnFirm!= OLD.InvisibleOnFirm 
OR NEW.BaseFirmCategory!= OLD.BaseFirmCategory 
OR NEW.RetUpCost!= OLD.RetUpCost 
OR NEW.OverCostPercent!= OLD.OverCostPercent 
OR NEW.DifferenceCalculation!= OLD.DifferenceCalculation 
OR NEW.AlowRegister!= OLD.AlowRegister 
OR NEW.AlowRejection!= OLD.AlowRejection 
OR NEW.AlowDocuments!= OLD.AlowDocuments 
OR NEW.MultiUserLevel!= OLD.MultiUserLevel 
OR NEW.AdvertisingLevel!= OLD.AdvertisingLevel 
OR NEW.AlowWayBill!= OLD.AlowWayBill 
OR NEW.AllowDocuments!= OLD.AllowDocuments 
OR NEW.AlowChangeSegment!= OLD.AlowChangeSegment 
OR NEW.ShowPriceName!= OLD.ShowPriceName 
OR NEW.WorkRegionMask!= OLD.WorkRegionMask 
OR NEW.OrderRegionMask!= OLD.OrderRegionMask 
OR NEW.EnableUpdate!= OLD.EnableUpdate 
OR NEW.CheckCopyID!= OLD.CheckCopyID 
OR NEW.AlowCumulativeUpdate!= OLD.AlowCumulativeUpdate 
OR NEW.CheckCumulativeUpdateStatus!= OLD.CheckCumulativeUpdateStatus 
OR NEW.ServiceClient!= OLD.ServiceClient 
OR NEW.SubmitOrders!= OLD.SubmitOrders 
OR NEW.AllowSubmitOrders!= OLD.AllowSubmitOrders 
OR NEW.BasecostPassword!= OLD.BasecostPassword 
OR NEW.OrdersVisualizationMode!= OLD.OrdersVisualizationMode 
OR NEW.CalculateLeader!= OLD.CalculateLeader 
OR NEW.AllowPreparatInfo!= OLD.AllowPreparatInfo 
OR NEW.AllowPreparatDesc!= OLD.AllowPreparatDesc 
OR NEW.SmartOrderRuleId!= OLD.SmartOrderRuleId 
OR NEW.FirmCodeOnly!= OLD.FirmCodeOnly
OR NEW.MaxWeeklyOrdersSum!= OLD.MaxWeeklyOrdersSum
OR NEW.CheckWeeklyOrdersSum!= OLD.CheckWeeklyOrdersSum
OR NEW.AllowDelayOfPayment!= OLD.AllowDelayOfPayment
OR NEW.Spy!= OLD.Spy
OR NEW.SpyAccount!= OLD.SpyAccount
OR NEW.ShowNewDefecture!= OLD.ShowNewDefecture
OR NEW.MigrateToPrgDataService!= OLD.MigrateToPrgDataService
)
then

INSERT
INTO   `logs`.RetClientsSetLogs SET LogTime = now()
       ,
       OperatorName = IFNULL
       (
              @INUser,
              SUBSTRING_INDEX(USER(),'@',1)
       )
       ,
       OperatorHost = IFNULL
       (
              @INHost,
              SUBSTRING_INDEX(USER(),'@',-1)
       )
       ,
       Operation  = 1,
       ClientCode = IFNULL
       (
              NEW.ClientCode,
              OLD.ClientCode
       )
       ,
       InvisibleOnFirm = NULLIF
       (
              NEW.InvisibleOnFirm,
              OLD.InvisibleOnFirm
       )
       ,
       BaseFirmCategory = NULLIF
       (
              NEW.BaseFirmCategory,
              OLD.BaseFirmCategory
       )
       ,
       RetUpCost = NULLIF
       (
              NEW.RetUpCost,
              OLD.RetUpCost
       )
       ,
       OverCostPercent = NULLIF
       (
              NEW.OverCostPercent,
              OLD.OverCostPercent
       )
       ,
       DifferenceCalculation = NULLIF
       (
              NEW.DifferenceCalculation,
              OLD.DifferenceCalculation
       )
       ,
       AlowRegister = NULLIF
       (
              NEW.AlowRegister,
              OLD.AlowRegister
       )
       ,
       AlowRejection = NULLIF
       (
              NEW.AlowRejection,
              OLD.AlowRejection
       )
       ,
       AlowDocuments = NULLIF
       (
              NEW.AlowDocuments,
              OLD.AlowDocuments
       )
       ,
       MultiUserLevel = NULLIF
       (
              NEW.MultiUserLevel,
              OLD.MultiUserLevel
       )
       ,
       AdvertisingLevel = NULLIF
       (
              NEW.AdvertisingLevel,
              OLD.AdvertisingLevel
       )
       ,
       AlowWayBill = NULLIF
       (
              NEW.AlowWayBill,
              OLD.AlowWayBill
       )
       ,
       AllowDocuments = NULLIF
       (
              NEW.AllowDocuments,
              OLD.AllowDocuments
       )
       ,
       AlowChangeSegment = NULLIF
       (
              NEW.AlowChangeSegment,
              OLD.AlowChangeSegment
       )
       ,
       ShowPriceName = NULLIF
       (
              NEW.ShowPriceName,
              OLD.ShowPriceName
       )
       ,
       WorkRegionMask = NULLIF
       (
              NEW.WorkRegionMask,
              OLD.WorkRegionMask
       )
       ,
       OrderRegionMask = NULLIF
       (
              NEW.OrderRegionMask,
              OLD.OrderRegionMask
       )
       ,
      
       EnableUpdate = NULLIF
       (
              NEW.EnableUpdate,
              OLD.EnableUpdate
       )
       ,
       CheckCopyID = NULLIF
       (
              NEW.CheckCopyID,
              OLD.CheckCopyID
       )
       ,
       AlowCumulativeUpdate = NULLIF
       (
              NEW.AlowCumulativeUpdate,
              OLD.AlowCumulativeUpdate
       )
       ,
       CheckCumulativeUpdateStatus = NULLIF
       (
              NEW.CheckCumulativeUpdateStatus,
              OLD.CheckCumulativeUpdateStatus
       )
       ,
       ServiceClient = NULLIF
       (
              NEW.ServiceClient,
              OLD.ServiceClient
       )
       ,
       SubmitOrders = NULLIF
       (
              NEW.SubmitOrders,
              OLD.SubmitOrders
       )
       ,
       AllowSubmitOrders = NULLIF
       (
              NEW.AllowSubmitOrders,
              OLD.AllowSubmitOrders
       )
       ,
       BasecostPassword = NULLIF
       (
              NEW.BasecostPassword,
              OLD.BasecostPassword
       )
       ,
       OrdersVisualizationMode = NULLIF
       (
              NEW.OrdersVisualizationMode,
              OLD.OrdersVisualizationMode
       )
       ,
       CalculateLeader = NULLIF
       (
              NEW.CalculateLeader,
              OLD.CalculateLeader
       )
       ,
       AllowPreparatInfo = NULLIF
       (
              NEW.AllowPreparatInfo,
              OLD.AllowPreparatInfo
       )
       ,
       AllowPreparatDesc = NULLIF
       (
              NEW.AllowPreparatDesc,
              OLD.AllowPreparatDesc
       )
       ,
       SmartOrderRuleId = NULLIF
       (
              NEW.SmartOrderRuleId,
              OLD.SmartOrderRuleId
       )
       ,
       FirmCodeOnly = NULLIF
       (
              NEW.FirmCodeOnly,
              OLD.FirmCodeOnly
       )
       ,
       MaxWeeklyOrdersSum = NULLIF
       (
              NEW.MaxWeeklyOrdersSum,
              OLD.MaxWeeklyOrdersSum
       )
       ,
       CheckWeeklyOrdersSum = NULLIF
       (
              NEW.CheckWeeklyOrdersSum,
              OLD.CheckWeeklyOrdersSum
       )
       ,
       AllowDelayOfPayment = NULLIF
       (
              NEW.AllowDelayOfPayment,
              OLD.AllowDelayOfPayment
       )
       ,
       Spy = NULLIF
       (
              NEW.Spy,
              OLD.Spy
       )
       ,
       SpyAccount = NULLIF
       (
              NEW.SpyAccount,
              OLD.SpyAccount
       )
       ,
       ShowNewDefecture = NULLIF
       (
              NEW.ShowNewDefecture,
              OLD.ShowNewDefecture
       )
       ,
       MigrateToPrgDataService = NULLIF
       (
              NEW.MigrateToPrgDataService,
              OLD.MigrateToPrgDataService
       );

end if;

END;
