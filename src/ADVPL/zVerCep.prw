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
Static Function VerifyCEP(cToken)
    Local cURL := ''
    Local nT := 0
    Local aCEPs := {}
    Local aECeps := {}
    Local oHTTP := HttpGet(cUrl)

    Local jDados
    Local cQry1 := ""
    Local cAlias1 := ""
    
    
    
    cAlias1 	:= GetNextAlias()

    // retorna todos os 
    cQry1 := "SELECT DISTINCT SA2.A2_CEP AS CEP ,SA2.A2_NOME AS NOME, SA2.A2_EMAIL AS EMAIL"
    cQry1 += ENTER + "WITH (NO LOCK)"
    cQry1 += ENTER + "FROM"+ RetSqlName('SA2')+ "AS SA2" 

    TCQUERY cQry1 NEW ALIAS &cAlias1

    (cAlias1)->(DbGoTop())

    while (cAlias1)->(!Eof())   
        cUrl := 'https://viacep.com.br/ws/'+CEP+'/json/'
        oHTTP := HttpGet(cUrl)

        if oHTTP:nStatusCode == 200
            oJson := JsonDecode(oHTTP:cContent)

            

    end


Return return_var
