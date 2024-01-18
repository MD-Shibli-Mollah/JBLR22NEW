SUBROUTINE TF.JBL.V.LTR.DISBURSEMENT
*-----------------------------------------------------------------------------
* create by: Mahmudur Rahman Udoy
* Description : This routine auto-populate debit account info from LTR information with Credit account(PAD ID)
* VERSION: FUNDS.TRANSFER,JBL.LTR.DISBURSEMENT
* Validation Field: Credit Account that hold PAD Account number.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.LTR.INNER
     
    $USING FT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.INNER = 'F.JBL.LTR.INNER';
    F.INNER = '';

    Y.PAD.ID = EB.SystemTables.getComi()
    
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.INNER,F.INNER)
RETURN
 
**********
PROCESS:
**********
    EB.DataAccess.FRead(FN.INNER, Y.PAD.ID, REC.INNER, F.INNER, ERR.INNER)
    IF REC.INNER NE '' THEN
        Y.UTILIZE  = REC.INNER<LTR.INNER.PAD.UTILIZE>
        IF Y.UTILIZE EQ 'N' THEN
            Y.LTR.CUR = REC.INNER<LTR.INNER.LTR.CCY>
            Y.LTR.AMT = REC.INNER<LTR.INNER.LTR.AMOUNT>
            Y.LTR.ID = REC.INNER<LTR.INNER.LTR.ID>
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.LTR.ID)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitCurrency, Y.LTR.CUR)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAmount, Y.LTR.AMT)
        END
    END
RETURN
END

