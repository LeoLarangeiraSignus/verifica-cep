#Include 'Totvs.ch'
#Include 'TbiConn.ch'
#Include 'TopConn.ch'



User Function JBTKNCOR()
    Local cToken := AllTrim(GetMv('ZZ_TKNCOR')) // Acessa a variavel que contém o Token que não expira
    Local cCodPos := AllTrim(GetMv('ZZ_CODPOST')) // Acessa a variavel que contem o código postal da empresa
    Local cExpTkn := AllTrim(GetMv('ZZ_EXPTKN')) // Pega o valor atual do Token que expira a cada 24hrs 
    
    
    Local cUrl := "" // Url para gerar um novo token

    Local cRetorno := ""
    Local jResultado 
    
    //Define os Headers
    HttpClearHeaders()
    HttpSetHeaders("Authorization: Bearer " + cToken)
    HttpSetHeaders("Content-Type: application/json")

    //Puxando um novo Token

    //Necessário passar o código postal
    Local cBody := '{codPostal: '+cCodPos+ '}'

    cRetorno += HttpPost(cUrl, cBody, "application/json" )

    jResultado := oJson := JsonDecode(oHTTP:cContent)
