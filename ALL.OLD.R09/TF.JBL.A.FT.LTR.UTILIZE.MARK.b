SUBROUTINE TF.JBL.A.FT.LTR.UTILIZE.MARK
*-----------------------------------------------------------------------------
* create by: Mahmudur Rahman Udoy
* Modification History : it is create for to write a mark in JBL.LTR.INNER Template utilize filed.
* version: FUNDS.TRANSFER,JBL.LTR.DISBURSEMENT
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
    FN.LTR = 'F.JBL.LTR.INNER';
    F.LTR = '';
    Y.LTR.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LTR,F.LTR)
RETURN

**********
PROCESS:
**********
    EB.DataAccess.FRead(FN.LTR, Y.LTR.ID, REC.LTR, F.LTR, ERR.LTR)
    IF REC.LTR NE '' THEN
        REC.LTR<LTR.INNER.PAD.UTILIZE> = 'Y'
    END
RETURN
END

