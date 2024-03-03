SUBROUTINE GB.JBL.I.TELLER.CHECK.CASH.BAL.FCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING FT.Contract
    $USING TT.Contract
    $USING AC.AccountOpening
    $USING EB.ErrorProcessing

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
RETURN

**********
OPENFILES:
**********
    CALL OPF(FN.ACC,F.ACC)
RETURN

********
PROCESS:
********
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.CR.ACC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        IF EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount) NE '' THEN
            Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        END ELSE
            Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        END
    END

    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.CR.ACC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
        Y.DR.ACC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        Y.CR.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountFcyOne)
    END

    EB.DataAccess.FRead(FN.ACC,Y.CR.ACC,R.ACC,F.ACC,ERR.AC)
    Y.AC.CATEG = R.ACC<AC.AccountOpening.Account.Category>
    Y.WORKING.BAL  = R.ACC<AC.AccountOpening.Account.WorkingBalance> + Y.CR.AMT
    IF Y.AC.CATEG EQ '10001' OR Y.AC.CATEG EQ '10011' THEN
        IF Y.WORKING.BAL GT 0 THEN
            EB.SystemTables.setEtext("Credit Till Closing Balance!!!")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN

END
