alter table logs.iislogs
  add index `LogTimeUserNameIDX` (LogTime, UserName);
