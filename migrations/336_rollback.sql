CREATE PROCEDURE catalogs.CreateGUPSynonymByProductId(IN pPriductId INT UNSIGNED)
  SQL SECURITY INVOKER
BEGIN
-- INSERT
-- INTO    farm.SYNONYM
--         (
--         PriceCode,
--         SYNONYM  ,
--         ProductId
--         )
-- SELECT  2647                                                                                          ,
--         trim(concat(c.name,'  ', group_concat(ifnull(pv.`value`,'') order by pv.Value SEPARATOR ' '))),
--         P.id
-- FROM    Catalogs.Catalog C      ,
--         Catalogs.Products P
--         LEFT JOIN Catalogs.ProductProperties PP
--         ON      pp.productid = p.id
--         LEFT JOIN Catalogs.PropertyValues Pv
--         ON      pv.id = pp.propertyvalueid
--         LEFT JOIN farm.synonym s
--         ON      s.pricecode=2647
--             AND s.ProductId=p.Id
-- WHERE  P.CatalogId        =C.id
--     AND s.synonymcode     IS NULL
--     AND P.id               =pPriductId
-- GROUP BY p.id;
END;
