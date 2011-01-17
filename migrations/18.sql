alter table Usersettings.Defaults
  add constraint FK_FormaterId FOREIGN KEY FK_FormaterId(FormaterId) REFERENCES OrderSendRules.order_handlers(Id) ON DELETE RESTRICT ON UPDATE RESTRICT,
  add constraint FK_SenderId FOREIGN KEY FK_SenderId(SenderId) REFERENCES OrderSendRules.order_handlers(Id) ON DELETE RESTRICT ON UPDATE RESTRICT;
 