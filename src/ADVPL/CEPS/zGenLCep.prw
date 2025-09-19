#include 'protheus.ch'
#include 'TOTVS.ch'
#include "TopConn.ch"








User /*/{Protheus.doc} CepsErr
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
Function CepsErr()
    Private oReport
    Private oSection1

    Private cAlias1 := ""
    Private cNomeRel := FunName()
    Private cTitulo := "CEP's errados" + cDados[5]
    Private cDescrRel := "Contém todos os CEP's que não estão corretos"
    

    oReport:= reportDef()
    oReport:printDialog()

Return 




















/*/{Protheus.doc} eErCeps
    Gera um relatorio para cada tabela de cadastro que contenha CEPS
@type user function
@author leonardo.larangeira
@since 17/09/2025
@version version
@param cEmail, character, e-mail para contato caso ocorra um erro.
@param cCep, character, Numero do CEP que queremos usar.
@param cNome, character, Nome de contato para caso ocorra um erro. 
@param cMotivo, character, Motivo do erro, podendo ser apenas dois. 
@param, cFName, character, Parâmetro que usamos para diferenciar qual tabela foi usada
@example
    // Exemplo de uso 
    cErro := eErCeps('teste@mail.com', '123456789', 'teste', 'motivo de erro', 'SA1')
@see (links_or_references)
/*/
User Function eErCeps(cEmail, cCep, cNome, cMotivo, cFName)
    Local aDados := {}
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


    oReport := TReport():New(cNomeRel, cTitulo, , {|oReport| PrintReport(oReport)}, cDescrRel)
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

    Private lEndSection := .F.
    Private lEndReport := .F.

    oSection1:Init()
    oSection:SetHeaderSection(.T.)

    Count to nRegs 
    oReport:SetMeter(nRegs)
    
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
Return return_var

