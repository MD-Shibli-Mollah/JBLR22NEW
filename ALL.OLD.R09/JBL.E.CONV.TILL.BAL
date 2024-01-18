*-----------------------------------------------------------------------------
* <Rating>179</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE JBL.E.CONV.TILL.BAL
!PROGRAM JBL.E.CONV.TILL.BAL
    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.STMT.ENTRY

!DEBUG
!Y.AC.ID = 'BDT1000111110888'
!Y.TEST = ''

    Y.AC.ID = O.DATA
    GOSUB INITIALISE
    GOSUB PROCESS

    RETURN
*--------------------------------------------------------------------------
INITIALISE:
*----------
    FN.AC = 'F.ACCOUNT'
    F.AC  = ''
    CALL OPF(FN.AC,F.AC)

    FN.AC.ENT.TODAY = 'F.ACCT.ENT.TODAY'
    F.AC.ENT.TODAY  = ''
    CALL OPF(FN.AC.ENT.TODAY,F.AC.ENT.TODAY)

    FN.STMT = 'F.STMT.ENTRY'
    F.STMT  = ''
    CALL OPF(FN.STMT,F.STMT)

    R.AC.ENT.TODAY.REC = ''
    Y.ENT.TODAY.ERR    = ''
    Y.ENT.TODAY.CNT    = ''
    R.STMT.REC         = ''
    Y.STMT.ERR         = ''
    Y.STMT.ID          = ''
    Y.TILL.CASH.REC    = ''
    Y.TILL.CASH.PAY    = ''
    Y.TILL.TO.VOLT     = ''
    Y.VOLT.TO.TILL     = ''

    RETURN
*-------------------------------------------------------------------------------------
PROCESS:
*------
!DEBUG
    CALL F.READ(FN.AC.ENT.TODAY,Y.AC.ID,R.AC.ENT.TODAY.REC,F.AC.ENT.TODAY,Y.ENT.TODAY.ERR)
    Y.ENT.TODAY.CNT = DCOUNT(R.AC.ENT.TODAY.REC,@FM)
    FOR I = 1 TO Y.ENT.TODAY.CNT
        Y.STMT.ID = R.AC.ENT.TODAY.REC<I>
        CALL F.READ(FN.STMT,Y.STMT.ID,R.STMT.REC,F.STMT,Y.STMT.ERR)
        IF R.STMT.REC THEN
            IF R.STMT.REC<AC.STE.TRANSACTION.CODE> EQ '34' OR R.STMT.REC<AC.STE.TRANSACTION.CODE> EQ '84' THEN
                IF R.STMT.REC<AC.STE.TRANSACTION.CODE> EQ '34' THEN
                    Y.VOLT.TO.TILL = Y.VOLT.TO.TILL + ABS(R.STMT.REC<AC.STE.AMOUNT.LCY>)
                END
                IF R.STMT.REC<AC.STE.TRANSACTION.CODE> EQ '84' THEN
                    Y.TILL.TO.VOLT = Y.TILL.TO.VOLT + ABS(R.STMT.REC<AC.STE.AMOUNT.LCY>)
                END
            END ELSE
                IF R.STMT.REC<AC.STE.AMOUNT.LCY> LT 0 THEN
                    Y.TILL.CASH.REC = Y.TILL.CASH.REC + ABS(R.STMT.REC<AC.STE.AMOUNT.LCY>)
                END
                IF R.STMT.REC<AC.STE.AMOUNT.LCY> GT 0 THEN
                    Y.TILL.CASH.PAY = Y.TILL.CASH.PAY + ABS(R.STMT.REC<AC.STE.AMOUNT.LCY>)
                END
            END
        END
    NEXT I

    O.DATA = Y.TILL.CASH.REC:'#':Y.TILL.CASH.PAY:'#':Y.TILL.TO.VOLT:'#':Y.VOLT.TO.TILL

!Y.TEST = Y.TILL.CASH.REC:';':Y.TILL.CASH.PAY:';':Y.TILL.TO.VOLT:';':Y.VOLT.TO.TILL

    RETURN
*---------------------------------------------------------------------------------
END
