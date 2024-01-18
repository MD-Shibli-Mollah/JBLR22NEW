SUBROUTINE TF.JBL.A.PAD.UTILIZE.MARK
*-----------------------------------------------------------------------------
*
* create by: Mahmudur Rahman Udoy
* Description : This routine utilize the unutilize mark in JBL.LTR.INNER Template after checking.
* VERSION: FUNDS.TRANSFER,JBL.LTR.DISBURSEMENT
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
 
    Y.UTILIZE = ''
    Y.PAD.ID = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    
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
    IF REC.INNER THEN
        Y.UTILIZE  = REC.INNER<LTR.INNER.PAD.UTILIZE>
        IF Y.UTILIZE EQ 'N' THEN
            REC.INNER<LTR.INNER.PAD.UTILIZE> = 'Y'
            EB.DataAccess.FWrite(FN.INNER,Y.PAD.ID,REC.INNER)
        END
    END
RETURN
END
