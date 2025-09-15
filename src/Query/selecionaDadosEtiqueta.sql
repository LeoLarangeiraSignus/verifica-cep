/*
Tabelas para Etiqueta
SA1 - CLIENTES
SF2 - 

Observa��o no sistema, as vezes, alguns dos clientes n�o est�o com n�meros
*/
SELECT
  TOP 10
  --*
  SA1.A1_COD,
  SA1.A1_NOME /*dstnom*/,
  SA1.A1_END /*dstend*/,
  SZ6.Z6_NUM /*dstendnum*/,
  SA1.A1_BAIRRO /*dstbai*/,
  SA1.A1_MUN /*dstcid*/,
  SA1.A1_EST /*dstest*/,
  SA1.A1_CEP /*dstxcep*/,
  SA1.A1_EMAIL /*dstxemail*/,
  SA1.A1_TEL /*dstxcel*/,
  SF2.F2_DOC /*dstxnfi*/,
  CASE
    WHEN SZ6.Z6_AR = 'S' THEN 'AR'
    ELSE ''
  END Z6_AR
FROM
  SA1010 AS SA1
  INNER JOIN SC5010 AS SC5 ON SC5.D_E_L_E_T_ <> '*'
  AND SC5.C5_CLIENTE = SA1.A1_COD
  INNER JOIN SF2010 AS SF2 ON SF2.D_E_L_E_T_ <> '*'
  AND SF2.F2_CLIENT = SA1.A1_COD
  INNER JOIN SZ6010 AS SZ6 ON SZ6.D_E_L_E_T_ <> '*'
  AND SZ6.Z6_CLIFOR = SA1.A1_COD
WHERE
  SA1.A1_MSBLQL <> '1'
  AND SA1.A1_COD = 'R00006'
  AND SC5.C5_NUM LIKE '031452'
  AND SF2.F2_CLIENTE = 'R00006'
  AND SF2.F2_DOC LIKE '000032592'