SUBROUTINE GB.JBL.I.OVRRD.ACC.CLSS.CHCK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.JBL.H.MUL.MCD
    $INSERT I_F.JBL.H.BK.MCD
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING TT.Contract
    
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

******
INIT:
******

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''

RETURN

**********
OPENFILES:
**********


    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.LocalReferences.GetLocRef('ACCOUNT', 'PR.ASSET.CLASS', Y.PR.ASSET.CLASS.POS)
    EB.LocalReferences.GetLocRef('FUNDS.TRANSFER','LEGAL.CHARGE',Y.LEGAL.CHARGE.FT.POS)
    EB.LocalReferences.GetLocRef('TELLER','LEGAL.CHARGE',Y.LEGAL.CHARGE.TT.POS)
RETURN


********
PROCESS:
*********
    IF APPLICATION EQ 'TELLER' THEN
        Y.ACCOUNT.ID = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        Y.LEGAL.CHARGE = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.LEGAL.CHARGE.TT.POS>
    END

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.ACCOUNT.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        Y.LEGAL.CHARGE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.LEGAL.CHARGE.FT.POS>
    END

    IF APPLICATION EQ 'ABL.H.MUL.MCD' THEN
        Y.ACCOUNT.ID = EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO)
    END

    EB.DataAccess.FRead(FN.ACCOUNT,Y.ACCOUNT.ID,R.ACCOUNT, F.ACCOUNT, Y.ACCOUNT.ERR)

    Y.PR.ASSET.CLASS = R.ACCOUNT <AC.AccountOpening.Account.LocalRef,Y.PR.ASSET.CLASS.POS>

    IF (Y.PR.ASSET.CLASS EQ 30 OR Y.PR.ASSET.CLASS EQ  40 OR Y.PR.ASSET.CLASS EQ 50) AND Y.LEGAL.CHARGE EQ '' AND APPLICATION EQ 'FUNDS.TRANSFER' THEN
        EB.SystemTables.setAf(FT.DEBIT.ACCT.NO)
        EB.SystemTables.setEtext("LOAN ACCOUNT IS CLASSIFIED ": Y.PR.ASSET.CLASS)
        EB.ErrorProcessing.StoreEndError()
    END

    IF (Y.PR.ASSET.CLASS EQ 30 OR Y.PR.ASSET.CLASS EQ  40 OR Y.PR.ASSET.CLASS EQ 50) AND Y.LEGAL.CHARGE EQ ''  AND APPLICATION EQ 'TELLER' THEN
        EB.SystemTables.setAf(TT.TE.ACCOUNT.2)
        EB.SystemTables.setEtext("LOAN ACCOUNT IS CLASSIFIED ": Y.PR.ASSET.CLASS)
        EB.ErrorProcessing.StoreEndError()
    END

    IF (Y.PR.ASSET.CLASS EQ 30 OR Y.PR.ASSET.CLASS EQ  40 OR Y.PR.ASSET.CLASS EQ 50) AND APPLICATION EQ 'ABL.H.MUL.MCD' THEN
        EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
        EB.SystemTables.setEtext("LOAN ACCOUNT IS CLASSIFIED ": Y.PR.ASSET.CLASS)
        EB.ErrorProcessing.StoreEndError()
    END
    IF (Y.PR.ASSET.CLASS EQ 30 OR Y.PR.ASSET.CLASS EQ  40 OR Y.PR.ASSET.CLASS EQ 50) AND APPLICATION EQ 'JBL.H.BK.MCD' THEN
        EB.SystemTables.setAf(MCD.BK.DEBIT.ACCT.NO)
        EB.SystemTables.setEtext("LOAN ACCOUNT IS CLASSIFIED ": Y.PR.ASSET.CLASS)
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
END