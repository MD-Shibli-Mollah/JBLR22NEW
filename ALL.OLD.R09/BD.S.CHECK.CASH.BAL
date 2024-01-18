*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE BD.S.CHECK.CASH.BAL
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    RETURN

INIT:

    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    R.ACC = ''
    Y.CR.ACC = ''
    Y.CR.AMT = ''
    Y.TT.TR.CODE = ''
    Y.AC.CATEG = ''
    Y.WORKING.BAL = ''

    RETURN

OPENFILES:

    CALL OPF(FN.ACC,F.ACC)

    RETURN

PROCESS:
*--------
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.CR.ACC = R.NEW(FT.CREDIT.ACCT.NO)
        IF R.NEW(FT.DEBIT.AMOUNT) NE '' THEN
            Y.CR.AMT = R.NEW(FT.DEBIT.AMOUNT)
        END ELSE
            Y.CR.AMT = R.NEW(FT.CREDIT.AMOUNT)
        END
        AF = 2
        GOSUB CASH.AC.VAL
    END

    IF APPLICATION EQ 'TELLER' THEN
        Y.CR.ACC = R.NEW(TT.TE.ACCOUNT.1)
        Y.CR.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
        AF = 6
        GOSUB CASH.AC.VAL
    END
    RETURN

CASH.AC.VAL:
*-----------
    CALL F.READ(FN.ACC,Y.CR.ACC,R.ACC,F.ACC,ERR.AC)
    Y.AC.CATEG = R.ACC<AC.CATEGORY>
    Y.WORKING.BAL  = R.ACC<AC.WORKING.BALANCE> + Y.CR.AMT
    IF Y.AC.CATEG EQ '10001' OR Y.AC.CATEG EQ '10011' THEN
        IF Y.WORKING.BAL GT 0 THEN
            E = "Insufficient Cash Account Balance"
            CALL ERR
            RETURN
        END
    END
    RETURN
END
