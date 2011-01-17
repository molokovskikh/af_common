insert into ordersendrules.SpecialHandlers (SupplierId, HandlerId)
select FirmCode, SenderId
  from ordersendrules.order_send_rules osr
       left join ordersendrules.SpecialHandlers sh on 
  sh.HandlerId = osr.senderid  and sh.SupplierId = osr.FirmCode
 where senderId <> 1 and senderId <> 2 and senderId <> 9 and sh.ID is NULL
union
select FirmCode, FormaterId
  from ordersendrules.order_send_rules osr
       left join ordersendrules.SpecialHandlers sh on 
  sh.HandlerId = osr.formaterid and sh.SupplierId = osr.FirmCode
 where formaterId <> 172 and formaterId <> 195 and formaterId <> 197 and formaterId <> 12 and sh.ID is NULL