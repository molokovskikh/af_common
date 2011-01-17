update usersettings.PriceItems pi
join farm.FormRules fr on fr.Id = pi.FormRuleId
set fr.PriceFormatId = 8
where fr.PriceFormatId = 4 and pi.Id in (399);
