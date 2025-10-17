#include "Totvs.ch"
#include "TopConn.ch"

#DEFINE ENTER CHR(13) + CHR(10)



/*/{Protheus.doc} fEtiPre
(long_description)
@type user function
@author user
@since 07/10/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function fEtiPre(cCodCli, cCodNF, cPedNum)
    // Local cURL AS CHARACTER
    Local cQry1 := ""
    Local cAlias1 := ""
    Local cExpTkn := "TST_TKN"
    Local cPayload AS CHARACTER
    // Local cExpTkn := AllTrim(GetMv('ZZ_EXPTKN'))
    // Local cCodPos := AllTrim(GetMv('ZZ_CODPOST'))
    Local nI := 1
    Local aOpcSer := {}
    Local aOpcObj := {}
    Local aOpcDet := {}

    cAlias1 := GetNextAlias()

    cQry1 := "SELECT SA1.A1_COD,"
    cQry1 += ENTER + "  SA1.A1_COD,"
    cQry1 += ENTER + "  SA1.A1_COD,"
    cQry1 += ENTER + "CASE"
    cQry1 += ENTER + " WHEN SA1.A1_COMPENT <> '' THEN SA1.A1_COMPENT"
    cQry1 += ENTER + " ELSE ''"
    cQry1 += ENTER + "END, "
    cQry1 += ENTER + "  SA1.A1_END,"
    cQry1 += ENTER + "  SA1.A1_ZZNUM,"
    cQry1 += ENTER + "  SA1.A1_BAIRRO,"
    cQry1 += ENTER + "  SA1.A1_MUN,"
    cQry1 += ENTER + "  SA1.A1_EST,"
    cQry1 += ENTER + "  SA1.A1_CEP,"
    cQry1 += ENTER + "  SA1.A1_EMAIL,"
    cQry1 += ENTER + "  SA1.A1_TEL,"
    cQry1 += ENTER + "  SF2.F2_DOC"
    cQry1 += ENTER + "FROM"
    cQry1 += ENTER + "" +RetSqlName('SA1')+ " AS SA1"
    cQry1 += ENTER + "  INNER JOIN " +RetSqlName('SC5')+ " AS SC5 ON SC5.D_E_L_E_T_ <> '*'"
    cQry1 += ENTER + "      AND SC5.C5_CLIENTE = SA1.A1_COD"
    cQry1 += ENTER + "  INNER JOIN " +RetSqlName('SF2') + " AS SF2 ON SF2.D_E_L_E_T_ <> '*'"
    cQry1 += ENTER + "      AND SF2.F2_CLIENT = SA1.A1_COD" 
    cQry1 += ENTER + "WHERE"
    cQry1 += ENTER + "  SA1.A1_MSBLQL <> '1'"
    cQry1 += ENTER + "  AND SF2.F2_CLIENTE = '"+cCodCli+"'"
    cQry1 += ENTER + "  AND SC5.C5_NUM = '"+cPedNum+"'"
    cQry1 += ENTER + "  AND SF2.F2_DOC = '"+cCodNF+"'"  

    TcQuery cQry1 NEW ALIAS &cAlias1

    (cAlias1)->(DbGoTop())
    
    // While 
    While (cAlias1)->(!EOF())
        		//criando a string json com os dados que temos acesso
		cPayLoad := "{"
		cPayLoad += ENTER + '"parmIn" : {'
		cPayLoad += ENTER + '                "Token": "'+cExpTkn+","                                                             /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxrmtcod": "1",'                      		/*Código do remetente*/                 /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxcar": "'+'",'              /*Cartão de Postagem*/                  /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstnom": "' +(cAlias1)->SA1.A1_NOME+ '",'      /*Nome do destinatario */               /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstend":"'+(cAlias1)->SA1.A1_END+'", '         /*Endereço do Destinatário*/            /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstendnum":"'+(cAlias1)->SA1.A1_ZZNUM+'", '    /*Número do destinatário*/              /*paramatro obrigatório*/
		cPayLoad += ENTER + '					"dstcpl":" '+'",'
		cPayLoad += ENTER + '                 "dstcpl":"'+(cAlias1)->SA1.A1_COMPENT+'", '     /*Complemento do destinatario*/         /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstbai":"'+(cAlias1)->SA1.A1_BAIRRO+'", '      /*Bairro do destinatario*/              /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstcid":"'+(cAlias1)->SA1.A1_MUN+ '",'         /*Municipio do destinatario*/           /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstest":" '+(cAlias)->SA1.A1_EST+'",'          /*UF do destinatario*/                  /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxcep": "' +(cAlias1)->SA1.A1_CEP+ '",'      /*CEP do destinatario*/                 /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxemail": "' +(cAlias1)->SA1.A1_EMAIL+ '",'  /*email do destinatario*/               /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxcel":"'+(cAlias1)->SA1.A1_TEL+ '",'        /*telefone do destinatario*/            /*paramatro obrigatório*/
		cPayLoad += ENTER + '                 "dstxnfi":" '+(cAlias1)->SF2.F2_DOC+'",'        /*Numero da NF*/                        /*paramatro obrigatório*/
		cPayLoad += ENTER +'                 "impetq": "B2W",'
		cPayLoad += ENTER + '                 "servicos": ['
		for nI := 1 to Len(aOpcSer)
			cPayLoad += ENTER + '                           {'
			cPayLoad += ENTER + '                               "servico":' +aOpcSer[nI]+ '"' /*Opções que temos para envio*/       /*paramatro obrigatório*/
			cPayLoad += ENTER + '                           },'
		next

		cPayLoad += ENTER + '                 ],' /*esse colchete está fechando o servicos*/
		cPayLoad += ENTER + '                 "objetos": ['
		for nI := 1 to Len(aOpcObj) /*{ {"dstxItem", "dstxobs", dstxvd, dstxadi}  }*/
			cPayLoad += ENTER + '                          {'
			cPayLoad += ENTER + '                               "dstxItem":" '+aOpcObj[nI][1]+ '",'
			cPayLoad += ENTER + '                               "dstxobs":" '+aOpcObj[nI][2]+'","'
			cPayLoad += ENTER + '                               "dstxvd":" '+aOpcObj[nI][3]+'",'
			cPayLoad += ENTER + '                               "dstxadi":"'+aOpcObj[nI][4]+'",'
			cPayLoad += ENTER + '                          }'

		next
		cPayLoad += ENTER + '                 ],' /*esse colchete está fechando os objetos*/
		cPayLoad += ENTER + '                 "det": [' /*Outros Detalhes da postagem, com definição especifica para cada cliente*/
		for nI := 1 to Len(aOpcDet) /*{ {"detParm", "detParmVal"} }*/
			cPayLoad += ENTER + '                   {'
			cPayLoad += ENTER + '                       "detParm": "' +aOpcDet[nI][1]+ '"'
			cPayLoad += ENTER + '                       "detParmVal": "' +aOpcDet[nI][2]+ '"'
			cPayLoad += ENTER + '                   }'
		next
		cPayLoad += ENTER + '                       ]' /*cholchete fechando o det*/
		cPayLoad += ENTER + '}' /*essa chave está fechando o campo paramIn*/
		cPayLoad += "}" /*essa chave está fechando o campo inteiro!*/

        (cAlias1)->(dbSkip())
    EndDo


Return  cAlias1
