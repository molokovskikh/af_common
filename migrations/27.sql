update
  farm.UnrecExp,
  usersettings.PricesCosts pc,
  usersettings.PricesData pd,
  farm.synonym s
set
  UnrecExp.ProductSynonymId = s.SynonymCode
where
    ((UnrecExp.Already & 1) > 0)
and (pc.PriceItemId = UnrecExp.PriceItemId)
and (pd.PriceCode = pc.PriceCode)
and ((pd.CostType = 1) or (pc.BaseCost = 1))
and (s.Synonym = UnrecExp.Name1)
and (s.PriceCode = ifnull(pd.ParentSynonym, pd.PriceCode));

update
  farm.UnrecExp,
  usersettings.PricesCosts pc,
  usersettings.PricesData pd,
  farm.synonymfirmcr sfc
set
  UnrecExp.ProducerSynonymId = sfc.SynonymFirmCrCode
where
    ((UnrecExp.Already & 2) > 0)
and (PriorProducerId is not null)
and (FirmCr is not null)
and (length(FirmCr) > 0)
and (pc.PriceItemId = UnrecExp.PriceItemId)
and (pd.PriceCode = pc.PriceCode)
and ((pd.CostType = 1) or (pc.BaseCost = 1))
and (sfc.PriceCode = ifnull(pd.ParentSynonym, pd.PriceCode))
and (sfc.Synonym = UnrecExp.FirmCr);

update
  farm.UnrecExp,
  usersettings.PricesCosts pc,
  usersettings.PricesData pd,
  farm.synonymfirmcr sfc
set
  UnrecExp.ProducerSynonymId = sfc.SynonymFirmCrCode
where
    ((UnrecExp.Already & 2) > 0)
and (PriorProducerId is null)
and (FirmCr is not null)
and (length(FirmCr) > 0)
and (pc.PriceItemId = UnrecExp.PriceItemId)
and (pd.PriceCode = pc.PriceCode)
and ((pd.CostType = 1) or (pc.BaseCost = 1))
and (sfc.PriceCode = ifnull(pd.ParentSynonym, pd.PriceCode))
and (sfc.Synonym = UnrecExp.FirmCr);