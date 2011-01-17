DROP PROCEDURE IF EXISTS usersettings.GetStatLog;
CREATE DEFINER=`RootDBMS`@`127.0.0.1` PROCEDURE `GetStatLog`(IN inLogStart DATETIME, IN inLogEnd DATETIME)
BEGIN

  DROP TEMPORARY TABLE IF EXISTS tempdownlogs;
  CREATE TEMPORARY TABLE tempdownlogs(
    rowid INT UNSIGNED,
    priceitemid INT UNSIGNED,
    resultcode MEDIUMINT UNSIGNED,
    fixedtime DATETIME,
    KEY (rowid),
    KEY (priceitemid),
    KEY (resultcode)
  ) ENGINE = MEMORY;

  DROP TEMPORARY TABLE IF EXISTS logs.tempdownlogs2;
  CREATE TEMPORARY TABLE logs.tempdownlogs2
    SELECT MAX(LogTime) AS LogTime, PriceItemId
    FROM logs.downlogs
    WHERE (inLogStart < logtime) AND (logtime < inLogEnd)
    GROUP BY PriceItemId;

  INSERT
  INTO tempdownlogs
  SELECT
    d.rowid, d.priceitemid, d.resultcode, NULL
  FROM
    LOGS.downlogs d
    JOIN logs.tempdownlogs2 tmp on d.logtime = tmp.logtime and d.priceitemid = tmp.priceitemid
  WHERE
    (inLogStart < d.logtime) AND (d.logtime < inLogEnd);

  SELECT
    MIN(Rowid)
  INTO
    @minrowid
  FROM
    tempdownlogs
  WHERE
    resultcode IN
    (3, 5);
  UPDATE
    tempdownlogs, LOGS.downlogs dl
  SET
    fixedtime = dl.logtime
  WHERE
    tempdownlogs.priceitemid = dl.priceitemid
    AND tempdownlogs.rowid >= @minrowid
    AND @minrowid < dl.rowid
    AND tempdownlogs.rowid < dl.rowid
    AND dl.resultcode = 2
    AND tempdownlogs.resultcode IN
    (3, 5);

  DROP TEMPORARY TABLE IF EXISTS tempformlogs;
  CREATE TEMPORARY TABLE tempformlogs(
    rowid INT UNSIGNED PRIMARY KEY,
    logtime DATETIME,
    priceitemid INT UNSIGNED,
    resultid MEDIUMINT UNSIGNED,
    fixedtime DATETIME,
    KEY priceitemid (rowid, priceitemid),
    KEY resultid (rowid, resultid)
  ) ENGINE = MEMORY;
  INSERT
  INTO tempformlogs
  SELECT
    rowid, logtime, priceitemid, resultid, NULL
  FROM
    LOGS.formlogs d
  WHERE
    (inLogStart < logtime) AND (logtime < inLogEnd);
  SELECT
    MIN(Rowid)
  INTO
    @minrowid
  FROM
    tempformlogs;
  UPDATE
    tempformlogs, LOGS.formlogs dl
  SET
    fixedtime = dl.logtime
  WHERE
    tempformlogs.priceitemid = dl.priceitemid
    AND tempformlogs.rowid >= @minrowid
    AND @minrowid < dl.rowid
    AND tempformlogs.rowid < dl.rowid
    AND dl.resultid IN
    (2, 3)
    AND tempformlogs.resultid = 5;
  SELECT
    1 AS LAppCode, 
    LogTime AS LLogTime, 
    logs.priceitemid AS LPriceItemId, 
    NULL AS LFirmName, 
    NULL AS LRegion, 
    NULL AS LFirmSegment,
    NULL AS LPriceName, 
    NULL AS LPriceCode, 
    NULL AS LForm, 
    NULL AS LUnform, 
    NULL AS LZero, 
    NULL AS LForb, 
    IF(ResultCode = 2, NULL, Addition) AS LAddition,
    IF(ResultCode = 2, NULL, IFNULL(ShortErrorMessage, Addition)) AS LShortErrorMessage, 
    srcTypes.Type As LSourceType,
    ResultCode AS LResultID, 1 AS LStatus
  FROM
    LOGS.downlogs AS LOGS
  LEFT JOIN farm.sourcetypes AS srcTypes ON srcTypes.Id = logs.SourceTypeId
  WHERE
    logs.priceitemid IS NULL
    AND logs.LogTime > inLogStart
    AND logs.LogTime < inLogEnd
  UNION
  SELECT
    1 AS LAppCode, 
    logs.LogTime AS LLogTime, 
    logs.priceitemid AS LPriceItemId, 
    cd.ShortName AS LFirmName, 
    r.Region AS LRegion, 
    cd.FirmSegment AS LFirmSegment, 
    IF(pd.CostType = 1, CONVERT(CONCAT(pd.PriceName, CONVERT(" [Колонка] " USING CP1251), pc.CostName) USING CP1251), pd.PriceName) AS LPriceName, 
    pd.PriceCode AS LPriceCode, 
    NULL AS LForm, 
    NULL AS LUnform, 
    NULL AS LZero, 
    NULL AS LForb, 
    IF(logs.ResultCode = 2, NULL, logs.Addition) AS LAddition,
    IF(logs.ResultCode = 2, NULL, IFNULL(ShortErrorMessage, Addition)) AS LShortErrorMessage, 
    srcTypes.Type As LSourceType,
    logs.ResultCode AS LResultID, 
    IF((logs.ResultCode = 2), 0, IF(tempdownlogs.fixedtime IS NULL, 1, 2)) AS LStatus
  FROM
    (LOGS.downlogs AS LOGS,
    usersettings.PriceItems pim,
    usersettings.clientsdata cd,
    usersettings.pricesdata pd,
    usersettings.pricescosts pc,
    farm.regions r,
    tempdownlogs)
  LEFT JOIN farm.sourcetypes AS srcTypes ON srcTypes.Id = logs.SourceTypeId
  WHERE
    pim.Id = logs.PriceItemId
    AND pc.PriceItemId = pim.Id
    AND pc.PriceCode = pd.PriceCode
    AND ((pd.CostType = 1) OR (pc.BaseCost = 1))
    AND cd.firmcode = pd.firmcode
    AND r.regioncode = cd.regioncode
    AND tempdownlogs.RowId = logs.RowID
    AND logs.LogTime > inLogStart
    AND logs.LogTime < inLogEnd
  UNION
  SELECT
    0 AS LAppCode, 
    LogTime AS LLogTime, 
    logs.priceitemid AS LPriceItemId, 
    NULL AS LFirmName, 
    NULL AS LRegion, 
    NULL AS LFirmSegment, 
    NULL AS LPriceName, 
    NULL AS LPriceCode, 
    IF(Form IS NULL, 0, Form) AS LForm, 
    IF(Unform IS NULL, 0, Unform) AS LUnform, 
    IF(Zero IS NULL, 0, Zero) AS LZero, 
    IF(Forb IS NULL, 0, Forb) AS LForb, 
    Addition AS LAddition, 
    Addition AS LShortErrorMessage, 
    null As LSourceType,
    ResultID AS LResultID, 
    1 AS LStatus
  FROM
    LOGS.formlogs AS LOGS
  WHERE
    logs.PriceItemId IS NULL
    AND logs.LogTime > inLogStart
    AND logs.LogTime < inLogEnd
  UNION
  SELECT
    0 AS LAppCode, 
    logs.LogTime AS LLogTime, 
    logs.priceitemid AS LPriceItemId, 
    cd.ShortName AS LFirmName, 
    r.Region AS LRegion, 
    cd.FirmSegment AS LFirmSegment, 
    IF(pd.CostType = 1, CONVERT(CONCAT(pd.PriceName, CONVERT(" [Колонка] " USING CP1251), pc.CostName) USING CP1251), pd.PriceName) AS LPriceName, 
    pd.PriceCode AS LPriceCode, 
    IF(logs.Form IS NULL, 0, logs.Form) AS LForm, 
    IF(logs.Unform IS NULL, 0, logs.Unform) AS LUnform,
    IF(logs.Zero IS NULL, 0, logs.Zero) AS LZero, 
    IF(logs.Forb IS NULL, 0, logs.Forb) AS LForb, 
    logs.Addition AS LAddition, 
    logs.Addition AS LShortErrorMessage, 
    null As LSourceType,
    logs.ResultID AS LResultID, 
    IF((logs.ResultID = 2) OR (logs.ResultID = 3), 0, IF(tempformlogs.fixedtime IS NULL, 1, 2)) AS LStatus
  FROM
    LOGS.formlogs AS LOGS,
    usersettings.PriceItems pim,
    usersettings.clientsdata cd,
    usersettings.pricesdata pd,
    usersettings.pricescosts pc,
    farm.regions r,
    tempformlogs
  WHERE
    pim.Id = logs.PriceItemId
    AND pc.PriceItemId = pim.Id
    AND pc.PriceCode = pd.PriceCode
    AND ((pd.CostType = 1) OR (pc.BaseCost = 1))
    AND cd.firmcode = pd.firmcode
    AND r.regioncode = cd.regioncode
    AND tempformlogs.RowId = logs.RowId
    AND logs.LogTime > inLogStart
    AND logs.LogTime < inLogEnd
  ORDER BY
    LLogTime;
END