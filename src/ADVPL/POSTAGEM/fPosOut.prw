#Include "Protheus.ch"
#Include 'TOTVS.ch'

#DEFINE ENTER := CHAR(10) + CHAR(13)


User Function fOPSer()

return 






// recuperando dados do banco para a cria��o do JSON com dados para a pr�-postagem, retorna o objeto em string.
/*/{Protheus.doc} fEtiPre
Fun��o respons�vel por recuperar os dados do banco para cria��o do JSON da pr�-postagem, 
retornando o objeto como uma string JSON.
@type user function
@author user
@since 08/09/2025
@version version
@param  cCodCli, character, C�digo do cliente para o qual a pr�-postagem ser� gerada.
@param  cCodNF,  character, C�digo ou n�mero da Nota Fiscal relacionada.
@param  cPedNum, character, N�mero do pedido vinculado � etiqueta.
@return cPayLoad, character, Objeto com os dados necess�rios para a cria��o da pr�-postagem em formato de string.
@example
    // Exemplo de uso:
    cEtiqueta := fEtiPre("000123", "NF000456", "PED000789")
    ConOut(cEtiqueta) // Exibe a string retornada no console

@see (links_or_references)
/*/
User Function fEtiPre(cCodCli, cCodNF,cPedNum)
	// pesquisar quais s�o os campos que devemos pegar, ou usar como gatilho para puxar os dados.
	Local cURL := ""
	Local cQry1 := ""
	Local cAlias1 := ""
	Local cPayLoad AS CHARACTER
	Local cExpTkn := AllTrim(GetMv('ZZ_EXPTKN'))
	Local cCodPos := AllTrim(GetMv('ZZ_CODPOST'))
	//pensando seriamente em criar as fun��es que buscam esses valores ali para cima, igual o zPropag
	Local aOpcSer := {}
	Local aOpcObj := {}
	Local aOpcDet := {}

	cAlias1 := GetNextAlias()

	cQry1 := "SELECT TOP 10"
	cQry1 += ENTER + "    SA1.A1_COD,"
	cQry1 += ENTER + "    SA1.A1_NOME /*dstnom*/,"
	cQry1 += ENTER + "CASE"
	cQry1 += ENTER + "    WHEN SA1.A1_COMPENT <> '' THEN SA1.A1_COMPENT"
	cQry1 += ENTER + "    ELSE ''"
	cQry1 += ENTER + "END A1_COMPENT, /*-> Complemento do destinat�rio*/"
	cQry1 += ENTER + "    SA1.A1_END /*dstend*/,"
	cQry1 += ENTER + "    SA1.A1_ZZNUM  /*dstendnum*/,"
	cQry1 += ENTER + "    SA1.A1_BAIRRO /*dstbai*/,"
	cQry1 += ENTER + "    SA1.A1_MUN /*dstcid*/,"
	cQry1 += ENTER + "    SA1.A1_EST /*dstest*/,"
	cQry1 += ENTER + "    SA1.A1_CEP /*dstxcep*/,"
	cQry1 += ENTER + "    SA1.A1_EMAIL /*dstxemail*/,"
	cQry1 += ENTER + "    SA1.A1_TEL /*dstxcel*/,"
	cQry1 += ENTER + "    SF2.F2_DOC /*dstxnfi*/"
	cQry1 += ENTER + "FROM"
	cQry1 += ENTER + ""+ RetSqlName('SA1') + "AS SA1"
	cQry1 += ENTER + "    INNER JOIN " +RetSqlName('SC5')+ "AS SC5 ON SC5.D_E_L_E_T_ <> '*'"
	cQry1 += ENTER + "    AND SC5.C5_CLIENTE = SA1.A1_COD"
	cQry1 += ENTER + "    INNER JOIN " +RetSqlName('SF2')+ "AS SF2 ON SF2.D_E_L_E_T_ <> '*'"
	cQry1 += ENTER + "    AND SF2.F2_CLIENT = SA1.A1_COD"
	cQry1 += ENTER + "WHERE"
	cQry1 += ENTER + "SA1.A1_MSBLQL <> '1'"
	cQry1 += ENTER + "AND SF2.F2_CLIENTE = '"+cCodCli+"'"
	cQry1 += ENTER + "AND SC5.C5_NUM = '"+cPedNum+"'"
	cQry1 += ENTER + "AND SF2.F2_DOC = '"+cCodNF+"'"

	TCQUERY cQry1 NEW ALIAS &cAlias1

	(cAlias1)->(DbGoTop())

	While (cAlias1)->(!EOF())
		//criando a string json com os dados que temos acesso
		cPayLoad := "{"
		cPayLoad += ENTER + '"parmIn" : {'
		cPayLoad += ENTER '                "Token": "'+cExpTkn+","                                                             /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxrmtcod": "1",'                      		/*C�digo do remetente*/                 /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxcar": "''",'              /*Cart�o de Postagem*/                  /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstnom": "' +(cAlias1)->SA1.A1_NOME+ '",'      /*Nome do destinatario */               /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstend":"'+(cAlias1)->SA1.A1_END+'", '         /*Endere�o do Destinat�rio*/            /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstendnum":"'+(cAlias1)->SA1.A1_ZZNUM+'", '    /*N�mero do destinat�rio*/              /*paramatro obrigat�rio*/
		cPayLoad += ENTER '					"dstcpl":" '++'",'
		cPayLoad += ENTER '                 "dstcpl":"'+(cAlias1)->SA1.A1_COMPENT+'", '     /*Complemento do destinatario*/         /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstbai":"'+(cAlias1)->SA1.A1_BAIRRO+'", '      /*Bairro do destinatario*/              /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstcid":"'+(cAlias1)->SA1.A1_MUN+ '",'         /*Municipio do destinatario*/           /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstest":" '+(cAlias)->SA1.A1_EST+'",'          /*UF do destinatario*/                  /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxcep": "' +(cAlias1)->SA1.A1_CEP+ '",'      /*CEP do destinatario*/                 /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxemail": "' +(cAlias1)->SA1.A1_EMAIL+ '",'  /*email do destinatario*/               /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxcel":"'+(cAlias1)->SA1.A1_TEL+ '",'        /*telefone do destinatario*/            /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "dstxnfi":" '+(cAlias1)->SF2.F2_DOC+'",'        /*Numero da NF*/                        /*paramatro obrigat�rio*/
		cPayLoad += ENTER '                 "impetq": "B2W",'
		cPayLoad += ENTER '                 "servicos": ['
		for nI := 1 to Len(aOpcSer)
			cPayLoad += ENTER + '                           {'
			cPayLoad += ENTER + '                               "servico":' +aOpcSer[nI]+ '"' /*Op��es que temos para envio*/       /*paramatro obrigat�rio*/
			cPayLoad += ENTER + '                           },'
		next

		cPayLoad += ENTER '                 ],' /*esse colchete est� fechando o servicos*/
		cPayLoad += ENTER '                 "objetos": ['
		for nI := 1 to Len(aOpcObj) /*{ {"dstxItem", "dstxobs", dstxvd, dstxadi}  }*/
			cPayLoad += ENTER + '                          {'
			cPayLoad += ENTER + '                               "dstxItem":" '+aOpcObj[nI][1]+ '",'
			cPayLoad += ENTER + '                               "dstxobs":" '+aOpcObj[nI][2]+'","'
			cPayLoad += ENTER + '                               "dstxvd":" '+aOpcObj[nI][3]+'",'
			cPayLoad += ENTER + '                               "dstxadi":"'+aOpcObj[nI][4]+'",'
			cPayLoad += ENTER + '                          }'

		next
		cPayLoad += ENTER '                 ],' /*esse colchete est� fechando os objetos*/
		cPayLoad += ENTER '                 "det": [' /*Outros Detalhes da postagem, com defini��o especifica para cada cliente*/
		for nI += 1 to Len(aOpcDet) /*{ {"detParm", "detParmVal"} }*/
			cPayLoad += ENTER + '                   {'
			cPayLoad += ENTER + '                       "detParm": "' +aOpcDet[nI][1]+ '"'
			cPayLoad += ENTER + '                       "detParmVal": "' +aOpcDet[nI][2]+ '"'
			cPayLoad += ENTER + '                   }'
		next
		cPayLoad += ENTER + '                       ]' /*cholchete fechando o det*/
		cPayLoad += ENTER + '}' /*essa chave est� fechando o campo paramIn*/
		cPayLoad += "}" /*essa chave est� fechando o campo inteiro!*/

	EndDo

Return cPayLoad
