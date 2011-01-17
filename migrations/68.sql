create table ordersendrules.SpecialHandlers
(
  Id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
  SupplierId INT NOT NULL REFERENCES usersettings.ClientsData(FirmCode),
  HandlerId INT NOT NULL REFERENCES ordersendrules.order_handlers(id)
)