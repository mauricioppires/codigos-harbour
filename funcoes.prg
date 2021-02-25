// Mauricio P Pires <mauricioppires at gmail dot com>

FUNCTION Percentual(nValorMax, nValorAtual)
RETURN((nValorAtual * 100) / nValorMax)

// Obs.: Passar nValor1 e nValor2 por referencia (@)
FUNCTION Swap(nValor1, nValor2)
    LOCAL nValor3
    nValor3 := nValor1
    nValor1 := nValor2
    nValor2 := nValor3
RETURN( .T. )

FUNCTION Janela(nTopo, nEsquerda, nBaixo, nDireita, cTitulo )
    LOCAL cCorcCor, cBarra
    cCorcCor := SETCOLOR()
    SETCOLOR("B+/W+*")
    @ nTopo, nEsquerda, nBaixo, nDireita BOX SPACE(9)
    HB_Shadow(nTopo, nEsquerda, nBaixo, nDireita)
    cBarra := (nDireita - nEsquerda) +1
    @ nTopo, nEsquerda    SAY space(cBarra) COLOR "W+*/B+"
    @ nTopo, nEsquerda +1 SAY cTitulo       COLOR "W+*/B+"
    SETCOLOR(cCor)
RETURN Nil

FUNCTION Mensagem(cTitulo, cMensagem)
    LOCAL cTela, cCor, nSimNao
    cTela := SAVESCREEN(00,00,24,79)
    cCor  := SETCOLOR()
    WHILE .T.
        Janela(17,11,21,66,cTitulo)
        @ 19, 12 SAY cMensagem COLOR "N/W+*"
        cCor := SETCOLOR()
        SETCOLOR("N+/W,GR+/R")
        @ 20, 61 PROMPT " Ok "
        MENU TO nSimNao
        DO CASE
            CASE nSimNao == 1
                SETCOLOR(cCor)
                EXIT
        ENDCASE
    ENDDO
    RESTSCREEN(00,00,24,79,cTela)
    SETCOLOR(cCor)
RETURN NIL


// #include "getexit.ch"
// #include "Getpass.ch"
// cSenha := SPACE(15)
// @ 10, 0 GET cSenha PASSWORD PICTURE "XXXXXXXXXXXXXXX" VALID !EMPTY(cSenha)

FUNCTION GetPassword(oGet)
    LOCAL nKey
    MEMVAR nChar
    MEMVAR cKey
    IF (GetPreValidate(oGet))
        oGet:SetFocus()
        oGet:cargo := ""
        DO WHILE (oGet:exitState == GE_NOEXIT)
            IF (oGet:typeOut)
                oGet:exitState := GE_ENTER
            ENDIF
            DO WHILE (oGet:exitState == GE_NOEXIT)
                nKey := InKey(0)
                IF nKey >= 32 .AND. nKey <= 255
                    oGet:cargo += Chr(nKey)
                    GetApplyKey(oGet, Asc("*"))
                ELSEIF nKey == K_BS
                    oGet:cargo := Substr(oGet:cargo, 1, Len(oGet:cargo) - 1)
                    GetapplyKey(oGet, nKey)
                ELSEIF nKey == K_ENTER
                    GetApplyKey(oGet, nKey)
                ENDIF
            ENDDO
            IF (!GetPostValidate(oGet))
                oGet:exitState := GE_NOEXIT
            ENDIF
        ENDDO
        oGet:KillFocus()
    ENDIF
    IF oGet:exitState != GE_ESCAPE
        oGet:varPut(oGet:cargo)
    ENDIF
RETURN Nil
