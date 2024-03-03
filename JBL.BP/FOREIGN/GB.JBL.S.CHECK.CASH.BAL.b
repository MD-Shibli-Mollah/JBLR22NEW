SUBROUTINE GB.JBL.S.CHECK.CASH.BAL
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History : ! Retrofit NILOY SARKAR
    ! NITSL 09/14/2022
*-----------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING FT.Contract
    $USING TT.Contract
    $USING AC.AccountOpening
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.ErrorProcessing


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


    EB.DataAccess.Opf(FN.ACC, F.ACC)
    

RETURN

PROCESS:
*--------

    IF EB.SystemTables.getApplication() 'FUNDS.TRANSFER' THEN
        Y.CR.ACC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        Y.FT.DEBIT.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
*  Y.FT.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
*        IF R.NEW(FT.DEBIT.AMOUNT) NE '' THEN
*            Y.CR.AMT = R.NEW(FT.DEBIT.AMOUNT)
*        END ELSE
*            Y.CR.AMT = R.NEW(FT.CREDIT.AMOUNT)
*        END
*        AF = 2
        IF Y.FT.DEBIT.AMT NE '' THEN
            Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        END ELSE
            Y.CR.AMT=  EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        END
*AF = 2
        GOSUB CASH.AC.VAL
    END

*    IF APPLICATION EQ 'TELLER' THEN
*        Y.CR.ACC = R.NEW(TT.TE.ACCOUNT.1)
*        Y.CR.AMT = R.NEW(TT.TE.AMOUNT.LOCAL.1)
*        AF = 6
*        GOSUB CASH.AC.VAL
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.CR.ACC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
        Y.CR.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalOne)
        GOSUB CASH.AC.VAL
    END
RETURN
*----------
CASH.AC.VAL:
*-----------
*CALL F.READ(FN.ACC,Y.CR.ACC,R.ACC,F.ACC,ERR.AC)
    EB.DataAccess.FRead(FN.ACC, Y.CR.ACC, R.ACC, F.ACC,Y.ERR)
* Y.AC.CATEG = R.ACC<AC.CATEGORY>
    Y.AC.CATEG = R.ACC<AC.AccountOpening.Account.Category>
* Y.WORKING.BAL  = R.ACC<AC.WORKING.BALANCE> + Y.CR.AMT
    Y.WORKING.BAL = R.ACC<AC.AccountOpening.Account.WorkingBalance>+Y.CR.AMT
    IF Y.AC.CATEG EQ '10001' OR Y.AC.CATEG EQ '10011' THEN
        IF Y.WORKING.BAL GT 0 THEN
            EB.SystemTables.setEtext('Insufficient Cash Account Balance')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN

END
