update usersettings.Intersection
set FirmClientCode = '20100327159999-953-12', FirmClientCode2 = '00050FF2-00000800-00002001-078BFBFF-AuthenticAMD'
where pricecode = 4820 and clientcode in (1518, 7625);
update usersettings.Intersection
set FirmClientCode = '20100227139999-843-12', FirmClientCode2 = '00000F65-00020800-0000E49D-BFEBFBFF-605B5101-007D7040-GenuineIntel', FirmClientCode3 = '02/05/2007-I945-6A79TG0AC-00'
where pricecode = 4820 and clientcode in (867, 2543, 3103, 5933, 5934, 6157, 6431, 7270, 7520);