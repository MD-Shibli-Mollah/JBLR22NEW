    SUBROUTINE BD.ENQ.SDSA.OUT.BAL(Y.DATA)
!    PROGRAM BD.ENQ.SDSA.OUT.BAL
    $INSERT GLOBUS.BP I_COMMON
    $INSERT GLOBUS.BP I_EQUATE
    $INSERT GLOBUS.BP I_F.ACCOUNT
    $INSERT JBL.BP I_F.BD.SDSA.ENTRY.DETAILS
    $INSERT GLOBUS.BP I_ENQUIRY.COMMON

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
    RETURN

INIT:
    FN.SDSA = 'F.BD.SDSA.ENTRY.DETAILS'
    F.SDSA = ''
    FN.AC = 'F.ACCOUNT'
    F.AC = ''

    Y.AC.NUMBER = ENQ.SELECTION<4,1>

    RETURN

OPENFILE:
    CALL OPF(FN.SDSA,F.SDSA)
    CALL OPF(FN.AC,F.AC)
    RETURN

PROCESS:
!DEBUG
!    Y.AC.NUMBER = 'BDT14940'
    IF LEN(Y.AC.NUMBER) EQ 8 THEN
        SEL.CMD = 'SELECT ':FN.SDSA:' WITH CO.CODE EQ ':ID.COMPANY:' AND AC.NUMBER EQ ':Y.AC.NUMBER:'0001':RIGHT(ID.COMPANY,4):' AND OUTSTANDING.AMT GT 0'
    END ELSE
        SEL.CMD = 'SELECT ':FN.SDSA:' WITH CO.CODE EQ ':ID.COMPANY:' AND AC.NUMBER EQ ':Y.AC.NUMBER:' AND OUTSTANDING.AMT GT 0'
    END
    CALL EB.READLIST(SEL.CMD, SEL.LIST, '', NO.OF.REC, RET.CODE)
!SEL.LIST = 'B7'
    LOOP
        REMOVE Y.SDSA.ID FROM SEL.LIST SETTING POS
    WHILE Y.SDSA.ID:POS

        Y.ORG.DATE = ''
        Y.ORG.PARTICULAR = ''
        Y.ORG.AMT = ''
        Y.TOT.ORG.AMT = ''
        Y.ADJ.DATE = ''
        Y.ADJ.PARTICULAR = ''
        Y.ADJ.AMT = ''
        Y.TOT.ADJ.AMT = ''

        CALL F.READ(FN.SDSA, Y.SDSA.ID, R.SDSA, F.SDSA, Y.SDSA.ERR)
        Y.ORG.TRANS.REF.NO.CNT = DCOUNT(R.SDSA<BD.SDSA.ORG.TRANS.REF.NO>, @VM)
        Y.CNT.ORG = 1
        FOR I = 1 TO Y.ORG.TRANS.REF.NO.CNT
            Y.ORG.REVE = R.SDSA<BD.SDSA.ORG.REVE, I>
            IF Y.ORG.REVE EQ 'NOT.REVE' THEN
                IF Y.CNT.ORG > 1 THEN
                    Y.ORG.DATE = Y.ORG.DATE :@VM: R.SDSA<BD.SDSA.ORG.DATE, I>
                    Y.ORG.PARTICULAR = Y.ORG.PARTICULAR :@VM: R.SDSA<BD.SDSA.ORG.PARTICULAR, I>
                    Y.ORG.AMT = Y.ORG.AMT :@VM: R.SDSA<BD.SDSA.ORG.AMT, I>
                END
                ELSE
                    Y.ORG.DATE = R.SDSA<BD.SDSA.ORG.DATE, I>
                    Y.ORG.PARTICULAR = R.SDSA<BD.SDSA.ORG.PARTICULAR, I>
                    Y.ORG.AMT = R.SDSA<BD.SDSA.ORG.AMT, I>
                END
                Y.TOT.ORG.AMT = R.SDSA<BD.SDSA.TOT.ORG.AMT>
                Y.CNT.ORG = Y.CNT.ORG + 1
            END
        NEXT I

        Y.ADJ.TRANS.REF.NO.CNT = DCOUNT(R.SDSA<BD.SDSA.ADJ.TRANS.REF.NO>, @VM)
        Y.CNT.ADJ = 1
        FOR I = 1 TO Y.ADJ.TRANS.REF.NO.CNT
            Y.ADJ.REVE = R.SDSA<BD.SDSA.ADJ.REVE, I>
            IF Y.ADJ.REVE EQ 'NOT.REVE' THEN
                IF Y.CNT.ADJ > 1 THEN
                    Y.ADJ.DATE = Y.ADJ.DATE :@VM: R.SDSA<BD.SDSA.ADJ.DATE, I>
                    Y.ADJ.PARTICULAR = Y.ADJ.PARTICULAR :@VM: R.SDSA<BD.SDSA.ADJ.PARTICULAR, I>
                    Y.ADJ.AMT = Y.ADJ.AMT :@VM: R.SDSA<BD.SDSA.ADJ.AMT, I>
                END
                ELSE
                    Y.ADJ.DATE = R.SDSA<BD.SDSA.ADJ.DATE, I>
                    Y.ADJ.PARTICULAR = R.SDSA<BD.SDSA.ADJ.PARTICULAR, I>
                    Y.ADJ.AMT = R.SDSA<BD.SDSA.ADJ.AMT, I>
                END
                Y.TOT.ADJ.AMT = R.SDSA<BD.SDSA.TOT.ADJ.AMT>
                Y.CNT.ADJ = Y.CNT.ADJ + 1
            END
        NEXT I
        Y.OUTSTANDING.AMT = R.SDSA<BD.SDSA.OUTSTANDING.AMT>
        Y.ORG.AC.NO = R.SDSA<BD.SDSA.AC.NUMBER>
        CALL F.READ(FN.AC,Y.ORG.AC.NO,R.AC,F.AC,Y.AC.ERR)
        Y.AC.TITLE = R.AC<AC.SHORT.TITLE>
        Y.ORG.AC.TITLE = Y.ORG.AC.NO:'(':Y.AC.TITLE:')'
        IF Y.CNT.ORG GT 1 OR Y.CNT.ADJ GT 1 THEN
            Y.DATA<-1> = Y.SDSA.ID:'*':Y.ORG.DATE:'*':Y.ORG.PARTICULAR:'*':Y.ORG.AMT:'*':Y.TOT.ORG.AMT:'*':Y.ADJ.DATE:'*':Y.ADJ.PARTICULAR:'*':Y.ADJ.AMT:'*':Y.TOT.ADJ.AMT:'*':Y.OUTSTANDING.AMT:'*':Y.AC.NUMBER:'*':Y.ORG.AC.TITLE
!                             1             2                  3                 4               5               6                  7                8              9                   10                11               12
        END
    REPEAT
!    PRINT Y.DATA
    RETURN

END
