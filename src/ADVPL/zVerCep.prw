#include 'protheus.ch'
#Include 'TOTVS.ch'
#include 'Http.ch'

ENTER := CHAR(10) + CHAR(13)

//verifica CEP 

/*/{Protheus.doc} VerifyCEP
    (Verifica o CEP dos clientes com base na API do https://viacep.com.br/ws/{cep}/json/)
    @type  Static Function
    @author user
    @since 11/08/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function rErCeps(cEmail, cCep, cNome, cMotivo, cFName)
	Local oExcel := Nil
	Local oSheet := Nil
	Local cFileName := "ceps-errados-"+cFName+".xlsx"
	Local nLastRow := 2

	if File(cFileName)
		oExcel := FWMsExcel():New()
		oExcel:Load( cFileName )
		oSheet := oExcel:ActiveSheet()
		nLastRow := oSheet:LastRow() + 1
	else
		oExcel := FWMsExcel():New()
		oSheet := oExcel:AddSheet( "CEPs Errados - " + cFName )

		// Cabeçalho formatado
		oSheet:Write( 1, 1, "Email" )
		oSheet:Write( 1, 2, "CEP" )
		oSheet:Write( 1, 3, "Nome")
		oSheet:Write( 1, 4, "Motivo")

		// Negrito e centralizado
		oSheet:SetFontBold( 1, 1, 1, 2, .T. )
		oSheet:SetAlignment( 1, 1, 1, 2, EXCEL_ALIGN_CENTER )
		oSheet:SetBackColor( 1, 1, 1, 2, RGB(200,200,200) ) // Cinza no cabeçalho
	endif

	// escreve os dados
	oSheet:Write(nLastRow, 1, cEmail)
	oSheet:Write(nLastRow, 2, cCep)
    oSheet:Write(nLastRow, 3, cNome)
    oSheet:Write(nLastRow, 4, cMotivo)

	oSheet:AutoFit(1,1)
	oSheet:AutoFit(1,2)
    oSheet:AutoFit(1,3)
    oSheet:AutoFit(1,4)

	oExcel:SaveAs(cFileName)
	oExcel:Close()


Return return_var


/*/{Protheus.doc} zGETSA1
(Função para pegar todos os CEPS da SA1)
@type user function
@author leonardo.larangeira
@since 12/08/2025
@version version
@param
@return
@example
(examples)
@see (links_or_references)
/*/
User Function zGETSA1()

	Local cURL := ''
	Local nT := 0
	Local aCEPs := {}
	Local aECeps := {}
	Local oHTTP := HttpGet(cUrl)

	Local jDados

	Local cQry1 := ""
	Local cAlias1 := ""


	cAlias1 := GetNextAlias()
	cQry1 := "SELECT TOP 10 DISTINCT"
	cQry1 += ENTER + "SA1.A1_CEP AS CEP, SA1.A1_EMAIL AS EMAIL , SA1.A1_NOME AS NOME"
	cQry1 += ENTER + "FROM " +RetSqlName('SA1')+ " AS SA1"
	cQry1 += ENTER + "WHERE"
	cQry1 += ENTER + "SA1.D_E_L_E_T_ <> '*'"
	cQry1 += ENTER + "AND SA1.A1_MSBLQL <> '1'"
	cQry1 += ENTER + "AND SA1.A1_CEP <> ''"
	cQry1 += ENTER + "AND SA1.A1_CEP <> '00000000'"
	TCQUERY cQry1 NEW ALIAS &cAlias1

	(cAlias1)->(DbGoTop())

	while (cAlias1)->(!Eof())
		cUrl := 'https://viacep.com.br/ws/'+CEP+'/json/'
		oHTTP := HttpGet(cUrl)

		if oHTTP:nStatusCode == 200
			oJson := JsonDecode(oHTTP:cContent)

			if oJson:GetJsonObjet('error'):

				aAdd(aECeps, {(cAlias1)->CEP, (cAlias1)->EMAIL, (cAlias1)->NOME})
                u_rErCeps((cAlias1)-> EMAIL , (cAlias1)->CEP, (cAlias1)->NOME, /*Motivo*/ "Formato Válido, porém CEP inexistente",/*Fname = SA1*/ 'SA1')
				FreeObj(oJson)
			end

        else:
            oJson := JsonDecode(oHTTP:cContent)
            aAdd(aECeps, {(cAlias1)->CEP, (cAlias1)->EMAIL, (cAlias1)->NOME})
            u_rErCeps((cAlias1)-> EMAIL , (cAlias1)->CEP, (cAlias1)->NOME, "Formato Inválido")
        
        endif
		(cAlias1)->(dbSkip())
    EndDo
	(cAlias1)->(dbCloseArea())   
	Return aECeps 



/*/{Protheus.doc} zGETSA2
(Função para pegar todos os valores da SA2)
@type user function
@author leonardo.larangeira
@since 12/08/2025
@version version
@param no params needed
@return there is no return defined
@example
(examples)
@see (links_or_references)
/*/
User Function zGETSA2()
	Local cURL := ''
	Local nT := 0
	Local aCEPs := {}
	Local aECeps := {}
	Local oHTTP := HttpGet(cUrl)

	Local jDados

	Local cQry2 := ""
	Local cAlias2 := ""


	cAlias2 := GetNextAlias()
	cQry2 := "SELECT TOP 10 DISTINCT"
	cQry2 += ENTER + "SA2.A1_CEP AS CEP, SA2.A1_EMAIL AS EMAIL , SA2.A1_NOME AS NOME"
	cQry2 += ENTER + "FROM " +RetSqlName('SA2')+ " AS SA2"
	cQry2 += ENTER + "WHERE"
	cQry2 += ENTER + "SA2.D_E_L_E_T_ <> '*'"
	cQry2 += ENTER + "AND SA2.A1_MSBLQL <> '1'"
	cQry2 += ENTER + "AND SA2.A1_CEP <> ''"
	cQry2 += ENTER + "AND SA2.A1_CEP <> '00000000'"
	TCQUERY cQry2 NEW ALIAS &cAlias2

	(cAlias2)->(DbGoTop())

	while (cAlias2)->(!Eof())
		cUrl := 'https://viacep.com.br/ws/'+CEP+'/json/'
		oHTTP := HttpGet(cUrl)

		if oHTTP:nStatusCode == 200
			oJson := JsonDecode(oHTTP:cContent)

			if oJson:GetJsonObjet('error')

				aAdd(aECeps, {(cAlias2)->CEP, (cAlias2)->EMAIL, (cAlias2)->NOME})
                u_rErCeps((cAlias2)-> EMAIL , (cAlias2)->CEP, (cAlias2)->NOME,/*Motivo*/ "Formato Válido, porém CEP inexistente", /*Tabela*/ 'SA2')
				FreeObj(oJson)
			end

        else
            oJson := JsonDecode(oHTTP:cContent)
            aAdd(aECeps, {(cAlias1)->CEP, (cAlias1)->EMAIL, (cAlias1)->NOME})
            u_rErCeps((cAlias1)-> EMAIL , (cAlias1)->CEP, (cAlias1)->NOME,/*Motivo*/ "Formato Inválido", /*Tabela*/'SA2')
        
        endif
		(cAlias2)->(DbSkip())
     EndDo
	 (cAlias2)->(dbCloseArea())
	Return aECeps 


/*/{Protheus.doc} zGETSA3
(Função para pegar todos os valores da SA3)
@type user function
@author leonardo.larangeira
@since 12/08/2025
@version version
@param no params needed
@return no returns yet
@example
(examples)
@see (links_or_references)
/*/
User Function zGETSA3()
	Local cURL := ''
	Local nT := 0
	Local aCEPs := {}
	Local aECeps := {}
	Local oHTTP := HttpGet(cUrl)

	Local jDados

	Local cQry3 := ""
	Local cAlias3 := ""


	cAlias3 := GetNextAlias()
	cQry3 := "SELECT TOP 10 DISTINCT"
	cQry3 += ENTER + "SA3.A3_CEP, SA3.A3_EMAIL, SA3.A3_NOME"
	cQry3 += ENTER + "FROM " +RetSqlName('SA3')+ " AS SA3"
	cQry3 += ENTER + "WHERE"
	cQry3 += ENTER + "SA3.D_E_L_E_T_ <> '*'"
	cQry3 += ENTER + "AND SA3.A3_MSBLQL <> '1'"
	cQry3 += ENTER + "AND SA3.A3_CEP <> ''"
	cQry3 += ENTER + "AND SA3.A3_CEP <> '00000000'"
	TCQUERY cQry3 NEW ALIAS &cAlias3

	(cAlias3)->(DbGoTop())

	while (cAlias3)->(!Eof())
		cUrl := 'https://viacep.com.br/ws/'+CEP+'/json/'
		oHTTP := HttpGet(cUrl)

		if oHTTP:nStatusCode == 200
			oJson := JsonDecode(oHTTP:cContent)

			if oJson:=GetJsonObjet('erro'):
				aAdd(aECeps, {(cAlias3)->A3_CEP, (cAlias3)->A3_EMAIL, (cAlias3)->A3_NOME} )
				u_rErCeps((cAlias3)-> EMAIL , (cAlias3)->CEP, (cAlias3)->NOME,/*Motivo*/ /*Motivo*/ "Formato Válido, porém CEP inexistente", /*Tabela*/'SA3')
				FreeObj(oJson)
			endif
		else
			u_rErCeps((cAlias3)-> EMAIL , (cAlias3)->CEP, (cAlias3)->NOME,/*Motivo*/ "Formato Inválido", /*Tabela*/'SA3')
			FreeObj(oJson)

		endif

		(cAlias3)->(DbSkip())
	EndDo
	(cAlias3)->(dbCloseArea())

Return


/*/{Protheus.doc} zGETSA4
(zGETSA4)
@type user function
@author leonardo.larangeira
@since 12/08/2025
@version version
@param no params needed
@return there is no return yet
@example
(examples)
@see (links_or_references)
/*/
User Function zGETSA4()
	Local cURL := ''
	Local nT := 0
	Local aCEPs := {}
	Local aECeps := {}
	Local oHTTP := HttpGet(cUrl)

	Local jDados

	Local cQry4 := ""
	Local cAlias4 := ""

	// adicionar o campo complem
	cAlias4 := GetNextAlias()
	cQry4 := "SELECT TOP 10 DISTINCT"
	cQry4 += ENTER + "SA4.A4_CEP, SA4.A4_EMAIL, SA4.A4_NOME, SA4.COMPLEM"
	cQry4 += ENTER + "FROM " +RetSqlName('SA4')+ " AS SA4"
	cQry4 += ENTER + "WHERE"
	cQry4 += ENTER + "SA4.A4_CEP <> ''"
	cQry4 += ENTER + "AND SA4.A4_CEP <> '00000000'"
	cQry4 += ENTER + "AND SA4.D_E_L_E_T_ <> '*'"
	TCQUERY cQry4 NEW ALIAS &cAlias4

	(cAlias4)->(DbGoTop())

	while (cAlias4)->(!Eof())
		cUrl := 'https://viacep.com.br/ws/'+CEP+'/json/'
		oHTTP := HttpGet(cUrl)

		if oHTTP:nStatusCode == 200
			oJson := JsonDecode(oHTTP:cContent)

			if oJson:GetJsonObjet('erro'):
				aAdd(aECeps, {(cAlias4)->A4_CEP,(cAlias4)->A4_EMAIL,(cAlias4)->A4_NOME,})
				u_rErCeps((cAlias4)-> EMAIL , (cAlias4)->CEP, (cAlias4)->NOME,/*Motivo*/"Formato Válido, porém CEP inexistente", /*Tabela*/'SA4')
				FreeObj(oJson)
			endif
		else 
			oJson := JsonDecode(oHTTP:cContent) 
			aAdd(aECeps, {(cAlias4)->A4_CEP,(cAlias4)->A4_EMAIL,(cAlias4)->A4_NOME,})
			u_rErCeps((cAlias4)-> EMAIL , (cAlias4)->CEP, (cAlias4)->NOME, /*Motivo*/ "Formato Válido, porém CEP inexistente", /*Tabela*/'SA4')
			FreeObj(oJson)
		endif
		(cAlias4)->(DbSkip())
	EndDo
	(cAlias4)->(dbCloseArea())
Return
