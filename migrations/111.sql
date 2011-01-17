update future.Users usr
  set WorkRegionMask = 
(select cl.MaskRegion
  from future.Clients cl
 where cl.Id = usr.ClientId ),
  OrderRegionMask = 
(select rcs.OrderRegionMask
  from future.Clients cl
        join usersettings.RetClientsSet rcs on rcs.ClientCode = cl.ID
 where cl.Id = usr.ClientId );