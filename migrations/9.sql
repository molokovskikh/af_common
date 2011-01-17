DROP TRIGGER IF EXISTS farm.FormRulesLogDelete;
DROP TRIGGER IF EXISTS farm.FormRulesLogInsert;
DROP TRIGGER IF EXISTS farm.FormRulesLogUpdate;

alter table farm.UnrecExp
  drop column Currency,
  drop column TmpCurrency,
  drop column CountryCr;

alter table farm.Zero
  drop column Currency;

alter table farm.FormRules
  drop column TxtCurrencyBegin,
  drop column TxtCurrencyEnd,
  drop column FCurrency,
  drop column Currency,
  drop column TxtCountryCrBegin,
  drop column TxtCountryCrEnd,
  drop column FCountryCr;

alter table logs.form_rules_logs
  drop column TxtCurrencyBegin,
  drop column TxtCurrencyEnd,
  drop column FCurrency,
  drop column Currency,
  drop column TxtCountryCrBegin,
  drop column TxtCountryCrEnd,
  drop column FCountryCr;