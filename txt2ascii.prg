// Mauricio P Pires <mauricioppires at gmail dot com>
#include "inkey.ch"

FUNCTION Main()
    LOCAL cCodigo, cTexto, cLinha, x
    IF !FILE("caderno.dbf")
        aCaderno := { { "CODIGO", "C",  10, 00 }, ;
                      { "LINHA" , "C", 200, 00 } }
        DBCREATE("caderno.dbf", aCaderno)
    ENDIF
    USE caderno NEW
    SELECT caderno
    CLS
    @ 02, 02 SAY "Texto2ASCII"
    @ 10, 10 SAY "Codigo"
    @ 10, 21 SAY "Texto"
    @ 22, 02 SAY "ESC - Sair do Modulo."
    WHILE .T.
        DBGOBOTTOM()
        cCodigo := STRZERO(VAL(caderno->CODIGO)+1,10)
        cTexto  := SPACE(50)
        cLinha  := ""
        @ 12, 10 SAY cCodigo 
        @ 12, 21 GET cTexto 
        READ
        IF LASTKEY() == K_ESC
            EXIT
        ENDIF
        cTexto := ALLTRIM(cTexto)
        cLinha := ""
        FOR x = 1 TO LEN(cTexto)
            IF (x != LEN(cTexto))
                cLinha += ALLTRIM(STR(ASC(SUBSTR(cTexto, x, 1)))) + ","
            ELSE
                cLinha += ALLTRIM(STR(ASC(SUBSTR(cTexto, x, 1))))
            ENDIF
        NEXT
        DBAPPEND()
        caderno->CODIGO := cCodigo
        caderno->LINHA  := cLinha
        DBCOMMIT()
    ENDDO
    MostraRegistro( 1 )
    CLOSE DATA
RETURN Nil


FUNCTION MostraRegistro( nRegistro )
    LOCAL aLinha, x, cTxtRestaurado
    DBGOTO( nRegistro )
    aLinha := &("{" + caderno->LINHA + "}")
    cTxtRestaurado := ""
    FOR x = 1 TO LEN(aLinha)
        cTxtRestaurado += CHR(aLinha[x])
    NEXT
    ALERT("Registro # [" + ALLTRIM(STR(nRegistro)) + "];;" + "Conteudo [" + cTxtRestaurado + "]")
RETURN Nil
