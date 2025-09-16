#Include 'Totvs.ch'
#Include 'TbiConn.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} JBTKNCOR
GeraÃ§Ã£o de um novo token a cada 24hrs para o consumo da API dos Meus Correios 

@type Function
@version 1.0
@author leonardo.larangeira
@since 08/09/2025
@history 08/09/2025, leonardo.larangeira, Criação do Job para atualizar o token diariamente.
/*/
/***************************************************************************/

User Function JBTKNCOR()
    Local cToken := AllTrim(GetMv('ZZ_TKNCOR')) // Acessa a variavel que contem o Token que não expira
    Local cCodPos := AllTrim(GetMv('ZZ_CODPOST')) // Acessa a variavel que contem o codigo postal da empresa
    Local cExpTkn := AllTrim(GetMv('ZZ_EXPTKN')) // Pega o valor atual do Token que expira a cada 24hrs 
    Local cBody AS CHARACTER 
    
    Local cUrl := "" // Url para gerar um novo token

    Local cRetorno := ""
    Local jResultado AS Object
    
    
    PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FAT"
    
    MsgInfo('Gerando um novo token para a consumo da API Meus Correios </br> TOKEN ANTIGO: ' +cExpTkn )
    
    //Define os Headers
    HttpClearHeaders()
    HttpSetHeaders("Authorization: Bearer " + cToken)
    HttpSetHeaders("Content-Type: application/json")

    //Puxando um novo Token

    //Necessario passar o codigo postal
    cBody := '{codPostal: '+cCodPos+ '}'

    cRetorno += HttpPost(cUrl, cBody, "application/json" )

    jResultado := JsonDecode(oHTTP:cContent)
    if !Empty(jResultado:GetJsonObject('Token'))
        PutMv("ZZ_EXPTKN", jResultado:GetJsonObject('Token'))
    else
        MsgAlert('Não foi possivel acessar o token.')
    endif

    FreeObj(jResultado)

    RESET ENVIRONMENT
Return 
