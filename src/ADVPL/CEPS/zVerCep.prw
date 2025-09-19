#include 'protheus.ch'
#Include 'TOTVS.ch'
#Include "TopConn.ch"

#DEFINE ENTER CHAR(13) + CHAR(10)



/*/{Protheus.doc} CepsErr
    (long_description)
    @type  Function
    @author user
    @since 17/09/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function CepsErr()
    Private oReport
    Private oSection1

    Private cAlias1 := ""
    Private cNomeRel := FunName()
    Private cTitulo := "CEP's errados" + cDados[5]
	Private cPerg := Upper(Padr(cNomeRel, 10))
    Private cDescrRel := "Contém todos os CEP's que não estão corretos"

    oReport:= reportDef()
    oReport:printDialog()

Return 

/*/{Protheus.doc} reportDef
    (long_description)
    @type  Static Function
    @author user
    @since 17/09/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function reportDef()
    Local nLinha := 1 


    oReport := TReport():New(cNomeRel, cTitulo, cPerg, {|oReport| PrintReport(oReport)}, cDescrRel)
    oReport:SetLandScape()
    oReport:OPage:setPaperSize(9)
    oReport:SetTotalLine(.F.)
    oReport:ShowHeader()

    oSection1 := TRSection():New(oReport, cTitulo)
    oSection1:SetTotalInLine(.F.)

    oReport:nfontBody := 7 
    oReport:cfontBody := "Arial"
    oReport:SetLineHeight(50)

    // TRCell():New(oSection, cCampo, cAlias, cTitulo, bFormula, nLargura, nTipo, nDecimais)
    //                  ok      n       n       ok          ok      ok      ok         ok
    //                           cTitulo    cFormula, percorre o Array para os próximos valores.
    //  {cEmail, cCep, cNome,"Formato Inválido"}
    //   1         2    3       4                 
    TRCell():New(oSection1, , , "EMAIL", {|| aDados[nLinha++]}, 30)
    TRCell():New(oSection1, , , "CEP", {|| aDados[nLinha++]}, 10)
    TRCell():New(oSection1, , , "NOME", {|| aDados[nLinha++]}, 30)
    TRCell():New(oSection1, , , "ERRO", {|| aDados[nLinha++]}, 30)

    // oBreak := TRBreak():New(oSection1, oSection1:Cell("EMAIL"),, .F.)



Return (oReport)

/*/{Protheus.doc} PrintReport
    (long_description)
    @type  Static Function
    @author user
    @since 19/09/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PrintReport(oReport)
   // passar o array de aDados 
    Local oSection1 := oReport:Section(1)
    Local nRegs := 0 
    Local nI := 1
	// Metodo para pegar as perguntas, aqui, nós vamos decidir qual vai ser a planinlha que será usada
	Pergunte(cPerg, .F.)
	

    Private lEndSection := .F.
    Private lEndReport := .F.

    oSection1:Init()
    oSection:SetHeaderSection(.T.)

    Count to nRegs  // acredito que isso aqui não é tão bom 
    oReport:SetMeter(nRegs) // igual ao de cima, não deve ser util no meu caso
    
    for nI := 1 to Len(aDados)
        If oReport:Cancel()
            Exit 
        Endif

        oSection1:Cell("EMAIL"):setValue(aDados[1])
        oSection1:Cell("CEP"):setValue(aDados[2])
        oSection1:Cell("NOME"):setValue(aDados[3])
        oSection1:Cell("ERRO"):setValue(aDados[4])

        oSection1:PrintLine()
        
        oReport:ThinLine()

        oSection1:Finish()
    next
Return 

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



/*/{Protheus.doc} fGetCEP
(long_description)
@type user function
@author user
@since 16/09/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function fGetCEP(cCEP,cEmail,cNome ,cTNome)
	Local cURL := 'https://viacep.com.br/ws/'+cCEP+'/json/'
	Local jDados AS JSON 
	Local cResult := ""
	Local aDados := {}
	
	//refazer isso aqui para ele realmente alimentar um dicionário de dados! Assim eu consigo passar ele direto para o Report
	// fica bem mais fácil de ser lido. 
	cResult := HttpGet(cURL)
	if cResult:nStatusCode == 200
		jDados := JsonDecode(cResult:cContent)

		if jDados:GetJsonObject('error')
			// u_rErCeps(cEmail, cCEP, cNome,"Formato Válido, porém CEP inexistente", cTNome)
			aAdd(aDados, {{cEmail, cCep, cNome,"Formato Válido, porém CEP inexistente", cTNome }})
			FreeObj(jDados)
		endif

	else
		jDados := JsonDecode(cResult:cContent)
		aAdd(aDados, {{cEmail, cCep, cNome,"Formato Inválido", cTNome }})
		// u_rErCeps(cEmail, cCEP, cNome,, "Formato Inválido")
        
    endif
	
Return aDados




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
    Local cQry1 := ""
	Local cAlias1 := ""


	cAlias1	:= GetNextAlias()
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
		//cCEP,cEmail,cNome ,cTNome
		u_fGetCEP((cAlias1)->A1_CEP, (cAlias1)->A1_EMAIL, (cAlias1)->A1_NOME, 'SA1' )
		(cAlias1)->(dbSkip())
    EndDo
	(cAlias1)->(dbCloseArea())   
Return  



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

	//cCEP,cEmail,cNome ,cTNome
	while (cAlias2)->(!Eof())
		u_fGetCEP((cAlias2)->CEP,(cAlias2)-> EMAIL,(cAlias2)->NOME, 'SA2')
		(cAlias2)->(DbSkip())
     EndDo
	 (cAlias2)->(dbCloseArea())
Return  


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

	Local cQry3 := ""
	Local cAlias3 := ""


	cAlias3 := GetNextAlias()
	cQry3 := "SELECT TOP 10 DISTINCT"
	cQry3 += ENTER + "SA3.A3_CEP AS CEP, SA3.A3_EMAIL AS EMAIL, SA3.A3_NOME AS NOME"
	cQry3 += ENTER + "FROM " +RetSqlName('SA3')+ " AS SA3"
	cQry3 += ENTER + "WHERE"
	cQry3 += ENTER + "SA3.D_E_L_E_T_ <> '*'"
	cQry3 += ENTER + "AND SA3.A3_MSBLQL <> '1'"
	cQry3 += ENTER + "AND SA3.A3_CEP <> ''"
	cQry3 += ENTER + "AND SA3.A3_CEP <> '00000000'"
	TCQUERY cQry3 NEW ALIAS &cAlias3

	(cAlias3)->(DbGoTop())
	//cCEP,cEmail,cNome ,cTNome
	
	while (cAlias3)->(!Eof())
		u_fGetCEP((cAlias3)->CEP, (cAlias3)-> EMAIL ,(cAlias3)->NOME, 'SA3')
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

	Local cQry4 := ""
	Local cAlias4 := ""

	// adicionar o campo complem
	cAlias4 := GetNextAlias()
	cQry4 := "SELECT TOP 10 DISTINCT"
	cQry4 += ENTER + "SA4.A4_CEP AS CEP, SA4.A4_EMAIL AS EMAIL, SA4.A4_NOME AS NOME"
	cQry4 += ENTER + "FROM " +RetSqlName('SA4')+ " AS SA4"
	cQry4 += ENTER + "WHERE"
	cQry4 += ENTER + "SA4.A4_CEP <> ''"
	cQry4 += ENTER + "AND SA4.A4_CEP <> '00000000'"
	cQry4 += ENTER + "AND SA4.D_E_L_E_T_ <> '*'"
	TCQUERY cQry4 NEW ALIAS &cAlias4

	(cAlias4)->(DbGoTop())
	
	while (cAlias4)->(!Eof())
		u_fGetCEP((cAlias4)-> EMAIL , (cAlias4)->CEP, (cAlias4)->NOME, 'SA4')
		(cAlias4)->(DbSkip())
	EndDo
	(cAlias4)->(dbCloseArea())
Return
