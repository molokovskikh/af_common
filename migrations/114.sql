INSERT INTO usersettings.AssignedPermissions (UserId, PermissionId)
select usr.Id, up.Id
  from future.Users usr
       join future.Clients cl on cl.Id = usr.ClientId
       join usersettings.ret_save_grids rsg on rsg.ClientCode = cl.Id
       join usersettings.save_grids sg on sg.ID = rsg.SaveGridID
       join usersettings.Userpermissions up on SUBSTRING(up.Name, 1, 45) = SUBSTRING(sg.DisplayName, 1, 45)