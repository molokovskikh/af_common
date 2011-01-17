insert into ordersendrules.SpecialHandlers (SupplierId, HandlerId)
select FirmCode, SenderId
  from ordersendrules.order_send_rules
 where senderId <> 1 and senderId <> 2 and senderId <> 9;
insert into ordersendrules.SpecialHandlers (SupplierId, HandlerId)
select FirmCode, FormaterId
  from ordersendrules.order_send_rules
 where formaterId <> 172 and formaterId <> 195 and formaterId <> 197 and formaterId <> 12