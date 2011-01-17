DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleInsert;
DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleUpdate;
DROP TRIGGER IF EXISTS ordersendrules.SmartOrderRuleDelete;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER ordersendrules.SmartOrderRuleInsert AFTER INSERT ON ordersendrules.smart_order_rules
FOR EACH ROW BEGIN
    INSERT 
    INTO `logs`.SmartOrderRuleLogs
    SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)), 
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)), 
		Operation = 0, 
		RuleId = NEW.Id,
		OffersClientCode = NEW.OffersClientCode,
		ParseAlgorithm = NEW.ParseAlgorithm,
		CheckAverageCost = NEW.CheckAverageCost,
		AverageCostBasedOnLineCount = NEW.AverageCostBasedOnLineCount,
		DoNotOrderIfNotOrderedEarly = NEW.DoNotOrderIfNotOrderedEarly,
		CheckOrderCost = NEW.CheckOrderCost,
		CheckRequestRatio = NEW.CheckRequestRatio,
		SearchInCategory = NEW.SearchInCategory,
		From5To4 = NEW.From5To4,
		From4To3 = NEW.From4To3,
		From3To2 = NEW.From3To2,
		From2To1 = NEW.From2To1,
		From1To0 = NEW.From1To0,
		CheckMinOrderCount = NEW.CheckMinOrderCount,
		OverPercentAverageCost = NEW.OverPercentAverageCost,
		AssortimentPriceCode = NEW.AssortimentPriceCode;
END;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER ordersendrules.SmartOrderRuleUpdate AFTER UPDATE ON ordersendrules.smart_order_rules
FOR EACH ROW BEGIN
    INSERT 
    INTO `logs`.SmartOrderRuleLogs
    SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)), 
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)), 
		Operation = 1, 
		RuleId = OLD.Id,
		OffersClientCode = NULLIF(NEW.OffersClientCode, OLD.OffersClientCode),
		ParseAlgorithm = NULLIF(NEW.ParseAlgorithm, OLD.ParseAlgorithm),
		CheckAverageCost = NULLIF(NEW.CheckAverageCost, OLD.CheckAverageCost),
		AverageCostBasedOnLineCount = NULLIF(NEW.AverageCostBasedOnLineCount, OLD.AverageCostBasedOnLineCount),
		DoNotOrderIfNotOrderedEarly = NULLIF(NEW.DoNotOrderIfNotOrderedEarly, OLD.DoNotOrderIfNotOrderedEarly),
		CheckOrderCost = NULLIF(NEW.CheckOrderCost, OLD.CheckOrderCost),
		CheckRequestRatio = NULLIF(NEW.CheckRequestRatio, OLD.CheckRequestRatio),
		SearchInCategory = NULLIF(NEW.SearchInCategory, OLD.SearchInCategory),
		From5To4 = NULLIF(NEW.From5To4, OLD.From5To4),
		From4To3 = NULLIF(NEW.From4To3, OLD.From4To3),
		From3To2 = NULLIF(NEW.From3To2, OLD.From3To2),
		From2To1 = NULLIF(NEW.From2To1, OLD.From2To1),
		From1To0 = NULLIF(NEW.From1To0, OLD.From1To0),
		CheckMinOrderCount = NULLIF(NEW.CheckMinOrderCount, OLD.CheckMinOrderCount),
		OverPercentAverageCost = NULLIF(NEW.OverPercentAverageCost, OLD.OverPercentAverageCost),
		AssortimentPriceCode = NULLIF(NEW.AssortimentPriceCode, OLD.AssortimentPriceCode);
END;

CREATE DEFINER = RootDBMS@127.0.0.1 TRIGGER ordersendrules.SmartOrderRuleDelete AFTER DELETE ON ordersendrules.smart_order_rules
FOR EACH ROW BEGIN
    INSERT 
    INTO `logs`.SmartOrderRuleLogs
    SET LogTime = now(),
		OperatorName = IFNULL(@INUser, SUBSTRING_INDEX(USER(),'@',1)), 
		OperatorHost = IFNULL(@INHost, SUBSTRING_INDEX(USER(),'@',-1)), 
		Operation = 2, 
		RuleId = OLD.Id,
		OffersClientCode = OLD.OffersClientCode,
		ParseAlgorithm = OLD.ParseAlgorithm,
		CheckAverageCost = OLD.CheckAverageCost,
		AverageCostBasedOnLineCount = OLD.AverageCostBasedOnLineCount,
		DoNotOrderIfNotOrderedEarly = OLD.DoNotOrderIfNotOrderedEarly,
		CheckOrderCost = OLD.CheckOrderCost,
		CheckRequestRatio = OLD.CheckRequestRatio,
		SearchInCategory = OLD.SearchInCategory,
		From5To4 = OLD.From5To4,
		From4To3 = OLD.From4To3,
		From3To2 = OLD.From3To2,
		From2To1 = OLD.From2To1,
		From1To0 = OLD.From1To0,
		CheckMinOrderCount = OLD.CheckMinOrderCount,
		OverPercentAverageCost = OLD.OverPercentAverageCost,
		AssortimentPriceCode = OLD.AssortimentPriceCode;
END;
