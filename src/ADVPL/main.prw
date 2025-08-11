#include 'Protheus.ch'
#Include "TOTVS.ch"



User /*/{Protheus.doc} zJsonFile
    (long_description)
    @type  Function
    @author user
    @since 30/07/2025
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
Function zJsonFile()
    Local aArea := FWGetArea()
    Local cJsonText := ''
    Local jDados
    Local cError
    Local aSites
    Local cMensagem := ''
    Local nAtual

    //Monta o JSON que será convertido em um Objeto 

    cJsonText := '{' +CRLF
    cJsonText += '  "nome":"Atilio",' + CRLF
    cJsonText += '  "idade":29,' + CRLF
    cJsonText += '  "gostaDeLer":true,' + CRLF
    cJsonText += '  "sites":[' + CRLF
    cJsonText += '    {"nome":"Terminal de Informacao", "url":"terminaldeinformacao.com"},' + CRLF
    cJsonText += '      {"nome":"Atilio Sistemas", "url":"atiliosistemas.com"}' + CRLF
    cJsonText += '  ]' + CRLF
    cJsonText += '}' + CRLF


Return 
