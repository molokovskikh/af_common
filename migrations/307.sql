update usersettings.PriceItems pi
join farm.FormRules fr on fr.Id = pi.FormRuleId
set fr.PriceFormatId = 10
where fr.PriceFormatId = 3 and pi.Id in (294, 955, 196, 866, 976, 513, 986, 1089, 636);
