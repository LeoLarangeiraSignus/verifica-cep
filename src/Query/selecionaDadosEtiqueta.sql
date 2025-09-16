/*
Tabelas para Etiqueta
SA1 - CLIENTES
SF2 - 

Observa��o no sistema, as vezes, alguns dos clientes n�o est�o com n�meros
*/
SELECT TOP 10
	SA1.A1_COD,
	SA1.A1_NOME /*dstnom*/,
	 CASE
	WHEN SA1.A1_COMPENT <> '' THEN SA1.A1_COMPENT
	ELSE ''
	 END A1_COMPENT, /*-> Complemento do destinatário*/
	SA1.A1_END /*dstend*/,
	SA1.A1_ZZNUM  /*dstendnum*/,
	SA1.A1_BAIRRO /*dstbai*/,
	SA1.A1_MUN /*dstcid*/,
	SA1.A1_EST /*dstest*/,
	SA1.A1_CEP /*dstxcep*/,
	SA1.A1_EMAIL /*dstxemail*/,
	SA1.A1_TEL /*dstxcel*/,
	SF2.F2_DOC /*dstxnfi*/
	 FROM
	  SA1010 AS SA1
	INNER JOIN  SC5010 AS SC5 ON SC5.D_E_L_E_T_ <> '*'
	AND SC5.C5_CLIENTE = SA1.A1_COD
	INNER JOIN  SF2010 AS SF2 ON SF2.D_E_L_E_T_ <> '*'
	AND SF2.F2_CLIENT = SA1.A1_COD
	 WHERE
	 SA1.A1_MSBLQL <> '1'
	 AND SF2.F2_CLIENTE =  '001048'
	 AND SC5.C5_NUM =  '216840'
	 AND SF2.F2_DOC =  '000215395'

-- Usar esses dados para fazer a busca. 
