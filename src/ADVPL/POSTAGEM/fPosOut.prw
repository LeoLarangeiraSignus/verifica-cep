#Include "Protheus.ch"
#Include 'TOTVS.ch'

#DEFINE ENTER := CHAR(10) + CHAR(13)

// recuperando dados do banco para a criação da etiqueta, retorna o objeto em string.
/*/{Protheus.doc} fEtiPre
(long_description)
@type user function
@author user
@since 08/09/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function fEtiPre(cCodCli, c)
    // pesquisar quais são os campos que devemos pegar, ou usar como gatilho para puxar os dados.
    Local cURL := ""
    Local cQry1 = ""
    Local cAlias1 = "" 
    Local cPayLoad AS CHARACTER


    cAlias1 := GetNextAlias()

    cQry1 := "SELECT TOP 10"
    cQry1 += ENTER + "    SA1.A1_COD,"
    cQry1 += ENTER + "    SA1.A1_NOME /*dstnom*/,"
    cQry1 += ENTER + "    SA1.A1_END /*dstend*/,"
    cQry1 += ENTER + "    SZ6.Z6_NUM  /*dstendnum*/,"
    cQry1 += ENTER + "    SA1.A1_BAIRRO /*dstbai*/,"
    cQry1 += ENTER + "    SA1.A1_MUN /*dstcid*/,"
    cQry1 += ENTER + "    SA1.A1_EST /*dstest*/,"
    cQry1 += ENTER + "    SA1.A1_CEP /*dstxcep*/,"
    cQry1 += ENTER + "    SA1.A1_EMAIL /*dstxemail*/,"
    cQry1 += ENTER + "    SA1.A1_TEL /*dstxcel*/,"
    cQry1 += ENTER + "    SF2.F2_DOC /*dstxnfi*/,"
    cQry1 += ENTER + "CASE"
    cQry1 += ENTER + "    WHEN SZ6.Z6_AR = 'S' THEN 'AR'"
    cQry1 += ENTER + "    ELSE"
    cQry1 += ENTER + "END Z6_AR"
    cQry1 += ENTER + "FROM"
    cQry1 += ENTER + '    ' + RetSqlName('SA1') + 'AS SA1'
    cQry1 += ENTER + "    INNER JOIN " ++ "AS SC5 ON SC5.D_E_L_E_T_ <> '*'" 
    cQry1 += ENTER + "    AND SC5.C5_CLIENTE = SA1.A1_COD"
    cQry1 += ENTER + "    INNER JOIN " ++ "AS SF2 ON SF2.D_E_L_E_T_ <> '*'"
    cQry1 += ENTER + "    AND SF2.F2_CLIENT = SA1.A1_COD"
    cQry1 += ENTER + "    INNER JOIN " ++ "AS SZ6 ON SZ6.D_E_L_E_T_ <> '*'"
    cQry1 += ENTER + "    AND SZ6.Z6_CLIFOR = SA1.A1_COD"
    cQry1 += ENTER + "WHERE"
    cQry1 += ENTER + "SA1.A1_MSBLQL <> '1'"
    cQry1 += ENTER + "AND SA1.A1_C0D = " + "'"++"'"
    cQry1 += ENTER + "AND SC5.C5_NUM LIKE " + "'"++"'"
    cQry1 += ENTER + "AND SF2.F2_CLIENTE = " + "'"++"'"
    cQry1 += ENTER + "AND SF2.F2_DOC = " + "'"++"'"

    TCQUERY cQry1 NEW ALIAS &cAlias1

    (cAlias1)->(DbGoTop())

    While (cAlias1)->(!EOF()) 


    EndDo

Return return_var
