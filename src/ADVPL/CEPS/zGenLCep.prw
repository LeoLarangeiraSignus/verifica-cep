#include 'protheus.ch'
#include 'TOTVS.ch'
#include "TopConn.ch"




User Function CepsErr()
    Private oReport
    Private oSection1

    Private cAlias1 := ""
    Private cNomeRel := FunName()
    Private cTitulo := "CEP's errados" + cDados[5]
    Private cDescrRel := "Contém todos os CEP's que não estão corretos"
    

    oReport:= reportDef()
    oReport:printDialog()

Return 



User Function eErCeps(cEmail, cCep, cNome, cMotivo, cFName)
    Local aDados := {}
Return 


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
    //                           cTitulo    cFormula, percorre o Array para os próximos valores.
    //  {cEmail, cCep, cNome,"Formato Inválido"}
    //   1         2    3       4                 
    TRCell():New(oSection1, , , "EMAIL", {|| aDados[nLinha++]}, 30)
    TRCell():New(oSection1, , , "CEP", {|| aDados[nLinha++]}, 10)
    TRCell():New(oSection1, , , "NOME", {|| aDados[nLinha++]}, 30)
    TRCell():New(oSection1, , , "ERRO", {|| aDados[nLinha++]}, 30)

    // oBreak := TRBreak():New(oSection1, oSection1:Cell("EMAIL"),, .F.)



Return (oReport)



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

