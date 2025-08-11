#include 'protheus.ch'

// ENTER := CHAR(10) + CHAR(13)


Static Function zGenTK()
    Local cURL := 'https://google.com' // URL de conexao
    Local cPToken := GETMV(FormatIn('ZZ_PERMTOK')) // pega o token permanente que precisamos para poder gerar outros tokens de consulta 
    Local oRestClient := FWRest():New(cURL) //Objeto REST 
    Local cToken := ""
    Local aHeader := {}
    Local cTimeNow := "" //adiciona o horario em que ele foi criado
    Local jResultado // Resultado jogado em um tipo json

    oRestClient := FWRest():New(cURL + cPToken)

    if oRestClient:Post(aHeader)
        jResultado := JsonObject():New()
        jResponse:FromJson(oRestClient:cResAtual)

        cToken := Iif( ValType(jResultado['access_token']) != "U", jResultado['access_token'], "")
        cTimeNow //setmv value
    endif  

return cToken
    
    
    
    

return

User Function fBearer(cPToken)
    Local cURL := "https://"

return 



User Function zValidTK(cTime)
    Local cGenTime := GETMV(FormatIn("ZZ_TOKENTIME"))
    Local cToken := ""
    //valida se o token foi gerado nas ultimas 24h e se devemos ou não gerar um novo
    if cTime <= cGentTime
        cToken := zGenTK()
    endif
    
Return cToken

