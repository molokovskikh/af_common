update farm.Synonym
set synonym = replace(synonym, '00', '')
where pricecode = 4687;
update farm.Synonym
set synonym = replace(synonym, '0,540', '0,54')
where pricecode = 4687;
update farm.Synonym
set synonym = replace(synonym, '5,0', '5')
where pricecode = 4687;
