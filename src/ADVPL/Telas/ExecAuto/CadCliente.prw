#include 'Protheus.ch'
#include 'FwMVCDef.ch'


/*/{Protheus.doc} CadCli

@type user function
@author user
@since 11/12/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function CadCli()
    Local oModel := NIL
    Local aErro  := {}
    Local cErro  := ''
    Local i      := 0


    RpcSetEnv('99','01') 

    oModel := FWLoadModel('CRMA980')
    oModel:SetOperation(MODEL_OPERATION_INSERT)
    oModel:Activate()

    //Acredito que eu posso passar valores que eu quiser nesse campo aqui, assim eu posso fazer o cadastro automatico 
    //desse valores, provalvelmente vai me ajudar a popular o banco de dados.
    oModel:SetValue('SA1MASTER', 'A1_COD',      '000003')
    oModel:SetValue('SA1MASTER', 'A1_LOJA',     '99')
    oModel:SetValue('SA1MASTER', 'A1_NOME',     'EXECAUTO MVC')
    oModel:SetValue('SA1MASTER', 'A1_NREDUZ',   'EXECAUTO')
    oModel:SetValue('SA1MASTER', 'A1_PESSOA',   'F')
    oModel:SetValue('SA1MASTER', 'A1_END',      'RUA TESTE MVC')
    oModel:SetValue('SA1MASTER', 'A1_TIPO',     'F')
    oModel:SetValue('SA1MASTER', 'A1_EST',      'SP')
    oModel:SetValue('SA1MASTER', 'A1_MUN',      'SAO PAULO')

    if oModel:VldData()
        oModel:CommitData()
        ConOut("Cliente incluido com sucesso")
    Else
        aErro := oModel:GetErroMessage()

        For i := 1 To Len(aErro)
            cErro += IIF(aErro[i] == 'C', aErro[i], '')
        Next

        ConOut(cErro)

    Endif

    oModel:DeActivate()
    oModel:Destroy()

    oModel := NIL

    RpcClearEnv()

Return 

