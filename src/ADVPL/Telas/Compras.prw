#include "Protheus.ch"
#include "FwMvcDef.ch"

/*/{Protheus.doc} Compras
Rotina de pedidos de compra customizada MVC
@type user function
@author Leonardo Larangeira
@since 11/12/2025
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function Compras()
    Local oBrowse := FWMBrowse():New()
    Local aRotina := Nil 
    
    aRotina := MenuDef()

    oBrowse():SetAlias('Z01')
    oBrowse():SetDescription('Solicitação de Compra - Cutomizado')

    oBrowse:Activate()
Return 


/*/{Protheus.doc} MenuDef
    Menu que será apresentado na tela inicial da rotina
    @type  Static Function
    @author user
    @since 11/12/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MenuDef()
    Local aRotina := {}

    ADD OPTION aRotina TITLE 'Incluir'     ACTION 'VIEWDEF.Compras'  OPERATION MODEL_OPERATION_INSERT ACCESS 0
    ADD OPTION aRotina TITLE 'Visualizar'  ACTION 'VIEWDEF.Compras'  OPERATION MODEL_OPERATION_VIEW   ACCESS 0
    ADD OPTION aRotina TITLE 'Alterar'     ACTION 'VIEWDEF.Compras'  OPERATION MODEL_OPERATION_UPDATE ACCESS 0
    ADD OPTION aRotina TITLE 'Excluir'     ACTION 'VIEWDEF.Compras'  OPERATION MODEL_OPERATION_DELETE ACCESS 0

Return aRotina


/*/{Protheus.doc} ModelDef
    Define o Modelo de Dados
    @type  Static Function
    @author user
    @since 11/12/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ModelDef()
    Local oModel := Nil 

    //Estrutura para os campos das tabela Z01 - Model 
    Local oStruZ01 := FWFormStruct(1, 'Z01')

    //Estrutura para os campos das tabela Z02 - Model 
    Local oStruZ02 := FWFormStruct(1, 'Z02')

    //Inicia a criação do Model 
    //Esse nome é de escolha do programador
    oModel := MPFormModel():New('COMP001')

    //Adiciona ao Model os campos da Z01 em formato Field 
    oModel:AddFields('Z01_MASTER', /*cOwner*/, oStruZ01)

    //Adiciona ao Model os campos em formta Grid 
    oModel:AddGrid('Z02_ITENS', 'Z01_MASTER', oStruZ02)

    //Define o relacionamento entre as tabelas Z02 (filho) e Z01 (pai)
    oModel:SetRelation('Z02_ITENS', {{'Z02_FILIAL', 'xFilial("Z02")'}, {'Z02_COD', 'Z01_COD'}}, Z02->(IndexKey(1)))

    //Defina a chave primária 
    //Precisa ser igual ao campo da APSDU, aquele campo de index 
    oModel:SetPrimaryKey({'Z01_FILIAL', 'Z01_COD'})
    
    //Descrição do Model 
    oModel:SetDescription('ModelDescription')
Return oModel


/*/{Protheus.doc} ViewDef
    Define a View
    @type  Static Function
    @author user
    @since 11/12/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ViewDef()
    Local oView := Nil

    //Recebe o model para atribuir a view 
    Local oModel := ModelDef()

    //Estrutura para os campos da tabela Z01 - View 
    Local oStrutZ01 := FWFormStruct(2, 'Z01')

    //Estrutura para os campos da tabela Z02 - View 
    Local oStrutZ02 := FWFormStruct(2, 'Z02')

    //Incia a crição do Model 
    oView := FWFormView():New()

    //Define o model que será utilizado na View
    oView:SetModel(oModel)

    //Adiciona a View os campos definidos no Model Z01_MASTER 
    oView:AddField('Z01_VIEW', oStrutZ01, 'Z01_MASTER')

    //Adiciona a View os campos definidos no Model Z02_ITENS
    oView:AddGrid('Z02_VIEW', oStrutZ02,'Z02_ITENS')

    //Define um campo da tabela que será preenchido automaticamente de forma incremental 
    oView:AddIncrementalField('Z02_VIEW', 'Z02_ITEM')

    //Cria na tela 2 caixas horizontais sendo 25% para cabeçalho e 75% para o grid de itens 
    oView:CreateHorizontalBox('CABEC', 25)
    oView:CreateHorizontalBox('ITENS', 75)

    //Atribui cada view a sua caixa para apresentar os dados na tela
    oView:SetOwnerView('Z01_VIEW', 'CABEC')
    oView:SetOwnerView('Z02_VIEW', 'ITENS')
Return oView
