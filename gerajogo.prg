// Mauricio P Pires <mauricioppires at gmail dot com>
// Gera 100 jogos da megasena, gravando em um arquivo de dados.
// Em desenvolvimento.

// #define Maior(nValor1, nValor2)     (IF(nValor1 > nValor2, nValor1, nValor2))


FUNCTION Main()
    LOCAL x, j, z, p, m, n, aMega, aLinha, nNumX, nNumOLD, var
    IF !FILE("mega.dbf")
        aMega := { { "id"    , "N", 04, 00 }, ;
                   { "bola01", "C", 02, 00 }, ;
                   { "bola02", "C", 02, 00 }, ;
                   { "bola03", "C", 02, 00 }, ;
                   { "bola04", "C", 02, 00 }, ;
                   { "bola05", "C", 02, 00 }, ;
                   { "bola06", "C", 02, 00 } }
        DBCREATE("mega.dbf", aMega)
    ENDIF
    USE mega NEW
    SELECT mega
    CLS
    FOR x = 1 TO 100
        DBAPPEND()
        FOR j = 1 TO 100
            aLinha := {}
            mega->id := x
            // ---
            // verificar a eliminacao de numero repetidos
            nNumX := nNumOLD := 0
            FOR z = 1 TO 6
                nNumX := HB_RandomInt(1,60)
                IF (nNumX == nNumOLD)
                    LOOP
                ELSE
                    AADD(aLinha, nNumX)
                ENDIF
                nNumOLD := nNumX
            NEXT
            IF LEN(aLinha) < 6
                LOOP
            ENDIF
            // ---
            // ordena os numeros de cada jogo
            ASORT(aLinha,,,{|m,n| m < n })
            FOR p = 1 TO 6
                var := "bola" + STRZERO(p, 2)
                mega->&var. := STRZERO(aLinha[p], 2)
            NEXT
        NEXT
        DBCOMMIT()
    NEXT
    CLOSE DATA
RETURN Nil
