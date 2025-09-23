#include "Protheus.ch"
#include "TOTVS.ch"



/*
Esse fonte tem como objetivo o estudo da cria��o de uma tela para gerar um relat�rio, j� tenho um pronto, 
por�m preciso ter certeza do que estou fazendo 
*/


//Primeiro precisamos criar uma User Function que ser� respons�vel por puxar o relat�rio. 

User Function Relato()
     // Esse oReport � de fato o relat�rio que vamos chamar
     Local oReport
     //cPerg � meio que a familia das perguntas que temos na SX1
     Local cPerg := "RELATO"
	

     //Essa fun��o tem como objetivo puxar as perguntas que temos na SX1
     //O segundo parametro de Pergunte � um bool que diz: Quer apare�a um pop-up para a pergunta?
     Pergunte(cPerg, .T.)

     //Recebe o retorno da nossa fun��o criada!
     //A ReportDef � respons�vel pela estrutura do nosso relat�rio
     /*Precisamos passar os dados das perguntas como um parametro*/
     oReport := ReportDef(cPerg)
     oReport:PrintDialog()


return 



User Function ReportDef(cPerg)
	// variavel criada com o mesmo nome para que n�o ocorra confus�es 
	Local oReport
	// Essas variaveis de objetos s�o respons�veis por criar e dar vida as se��es do nosso relatorio.
	/*
		Nesse exemplo, nos vamos criar tr�s se��es:
		1 - Todos os clientes cadastrados
		2 - Todos os pedidos de vendas dos clientes
		3 - Os itens atrelados ao pedidos de vendas que est�o atrelados aos clientes
	*/

	Local oSection1
	Local oSection2 
	Local oSection3
	
	Local cTitulo := "Pedidos de clientes"
	
	//TReport():New(cNome, cTitulo, cPerg, Function)
	/*
		Ao colocar o atributo de passagem cNome, � altamente recomendado colocar o nome da fun��o criada
		O Titulo vai vir da var chamada cTitulo
		Perguntas
		Aqui, no quarto parametro � onde o relat�rio vai realmente ser gerado, onde vamos pegar realmente os dados que precisamos 
		para gerar o relat�rio. 
	*/
	oReport := TReport():New('Relato', cTitulo, cPerg, {|oReport| PrintReport(oReport)})
	//Aqui definimos como queremos que a pagina do relat�rio seja.
	oReport:SetLandscape()


	/*======================= Montando a Estrutura do Relat�rio ========================*/

	//Criando a primeira se��o! 

	// Passamos o objeto oReport e o nome da sheet que vamos criar 
	oSection1 := TRSection():New(oReport, 'Cliente')

	/*agora, vamos precisar colocar as colunas
	  TRCell():New(1�, 2�, 3�, 4�, 5�, 6�)
	  1 - Objeto que estamos trabalhando, por exemplo, estamos usando o oSection1 ao inves do oSection2 
	  2 - Esse aqui � o nome da tabela, podemos passar ele como o nome da tabela ou at� mesmo um ALIAS, no caso, estamos fazendo a passagem como nome do campo da tabela. Por�m, ao passar esse nome da coluna, precisamos que ele siga o padr�o mostrado aqui.  
	  3 - Como vamos pegar os dados de uma query, n�o precisamos preencher ela, mas caso fosse preciso, era para colocar o nome da tabela, apenas se pegarmos uma tabela direto do protheus 
	  4 - Esse � realmente o nome da coluna que o cliente vai ver ao gerar o relat�rio
	  5 - Aqui precisamos colocar a mascara do campo, como � um texto, ele vai ficar vazio
	  6 - Vamos informar o tamanho desse campo, podendo ser fixo ou pegando com o valor da sx3.
	  
	*/
	TRCell():New(oSection1, 'A1_COD',,'Cod.Cliente', '', TamSX3('A1_COD')[1])
	TRCell():New(oSection1, 'A1_LOJA',,'Loja', '', TamSX3('A1_LOJA')[1])
	TRCell():New(oSection1, 'A1_NOME',,'Nome', '', TamSX3('A1_NOME')[1])

	
	//Criando a segunda se��o

	oSection2 := TRSection():New(oReport, 'Pedidos')
	TRCell():New(oSection2, 'C5_NUM', , 'Pedido', '', TamSX3('C5_NUM')[1])

	
	//Criando a terceira se��o
	oSection3 := TRSection():New(oReport, 'Produtos')
	TRCell():New(oSection3, 'C6_PRODUTO', ,'Produto:', '', TamSX3('C6_PRODUTO')[1])
	TRCell():New(oSection3, 'DESC_PRO', ,'Descri��o', '', TamSX3('B1_ZZDESC')[1])
	TRCell():New(oSection3, 'C6_QTDVEN', ,'Quantidade', '@E 9999',TamSX3('C6_QTDVEN')[1])
	TRCell():New(oSection3, 'C6_VALOR', , 'Vlr Total', '@E 9,999,999.99', TamSX3('C6_VALOR')[1])


return oReport

/*
Agora, precisamos criar aquela fun��o que passamos no TReport para ler todos os dados que queremos
*/

Static Function PrintReport(oReport)
	
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2) 
	Local oSection3 := oReport:Section(3)
	Local cAliasCl := GetNextAlias()
	Local cAliasPd := GetNextAlias()
	Local cAliasPr := GetNextAlias()
	// um pequeno contador para verficiar se a consulta retornou algum registro ou n�o.
	Local nRegs := 0 

	// Um pouco diferente do padr�o que trabalhamos, mas � uma abordagem legal
	// bora ver onde vamos parar 
	BeginSql Alias cAliasCl
		SELECT  SA1.A1_COD, 
				SA1.A1_LOJA, 
				SA1.A1_NOME
		FROM %Table:SA1% AS SA1
		WHERE SA1.%NotDel%
		AND A1_FILIAL = %xFilial:SA1%
		AND A1_COD BETWEEN %Exp:MV_PAR01% AND %MV_PAR03%
		AND A1_LOJA BETWEEN %Exp:MV_PAR02% AND %MV_PAR04%
	EndSql

	// se o contator retornar um registro a gente continua a l�gica.
	/*
	Quando n�s usamos essa fun��o Count to ele posiciona o ponteiro para o final da 
	tabela, isso nos obriga a usar a fun��o DbGoTop()
	para conseguir verificar de verdade todos os valores retornados da fun��o.
	*/
	Count to nRegs

	If nRegs > 0 
		(cAliasCl)->(DbGoTop())
		While (cAliasCl)->(!EOF())
			oSection1:Init()

			oSection1:Cell('A1_COD'):SetValue(AllTrim( (cAliasCl)->A1_COD) )
			oSection1:Cell('A1_LOJA'):SetValue(AllTrim( (cAliasCl)->A1_LOJA) )
			oSection1:Cell('A1_NOME'):SetValue(AllTrim( (cAliasCl)->A1_NOME) )

			oSection1:PrintLine()
			oReport:ThinLine()

			BeginSql Alias cAliasPd
				SELECT SC5.C5_NUM 
				FROM %Table:SC5% AS SC5
				WHERE SC5.%NotDel%
				AND	SC5.C5_CLIENTE = %Exp:(cAliasCl)->A1_COD% 
				AND SC5.C5_LOJACLI = %Exp:(cAliasCl)->A1_LOJA%
			EndSql

			nRegs := 0 

			Count to nRegs

			If nRegs > 0
				(cAliasPd)->(DbGoTop())
				While (cAliasCl)->(!EOF())
					oSection2:Init()

					oSection2:Cell('C5_NUM'):SetValue(AllTrim((cAliasPd)->C5_NUM))
					oSection2:PrintLine()
					// oReport:ThinLine()

					BeginSql Alias cAliasPr
						SELECT SC6.C6_PRODUTO
							, SB1.B1_ZZDESC AS DESC_PRO
							, SC6.C6_QTDVEN
							, SC6.C6_VALOR
						FROM %Table:SC6% AS SC6
						// INNER JOIN %Table:SB1% AS SB1
						// 	ON SB1.%NotDel%
						// 	AND SB1.B1_COD = SC6.C6_PRODUTO
						WHERE
							SC6.%NotDel%
							AND SC6.C6_NUM = %Exp:(cAliasPd)->C5_NUM%
							AND SC6.C6_CLIENT = %Exp:(cAliasCl)->A1_COD%
					EndSql

					nRegs := 0 

					Count to nRegs

					if nRegs > 0
						(cAliasPr)->(DbGoTop())
						While (cAliasPr)->(!EOF())
							oSection3:Init()

							oSection3:Cell('C6_PRODUTO'):SetValue(AllTrim((cAliasPr)->C6_PRODUTO))
							// oSection3:Cell('DESC_PRO'):SetValue(AllTrim((cAliasPr)->DESC_PRO))
							oSection3:Cell('DESC_PRO'):SetValue(AllTrim(Posicione('SB1',1 , xFilial('SB1') + (cAliasPr)->C6_PRODUTO, 'B1_ZZDESC')))
							oSection3:Cell('C6_QTDVEN'):SetValue((cAliasPr)->C6_QTDVEN)
							oSection3:Cell('C6_VALOR'):SetValue((cAliasPr)->C6_VALOR)
							oSection3:PrintLine()
							

							(cAliasPr)->(dbSkip())
						endDo

						oSection3:Finish()
						oReport:SkipLine(1)
				
					endIf
					oSection2:Finish()
					(cAliasPr)->(DbCloseArea())
					(cAliasPd)->(DbSkip())
				endDo
			endIf

			(cAliasPd)->(DbCloseArea())
			(cAliasCl)->(DbSkip())
			oReport:SkipLine(2)
			oSection1:Finish()
		endDo

	endIf
	(cAliasCl)->(DbCloseArea())
return
