SUBROUTINE TF.JBL.A.PAD.UNUTILIZE.MARK
*-----------------------------------------------------------------------------
* create by: Mahmudur Rahman Udoy
* Descriptoin : If PAD ID exsist in LTR arrangement this routine write value of LTR in
*               JBL.LTR.INNER Template with pad id as record id.
* Activity.Api: JBL.TF.INNER.API    Property: TERM.AMOUNT
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.JBL.LTR.INNER
     
    $USING AA.Framework
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING AA.Account
    $USING AA.TermAmount

*-----------------------------------------------------------------------------
    IF EB.SystemTables.getVFunction() EQ "A" THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN
*****
INIT:
*****
    FN.INNER = 'F.JBL.LTR.INNER';
    F.INNER = '';
    
    EB.Updates.MultiGetLocRef("AA.ARR.ACCOUNT","LT.TF.IMP.PADID",Y.POS)
    Y.PAD.AC.POS =Y.POS<1,1>
    
    Y.ARR.ID = AA.Framework.getC_aalocarrid();
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.INNER,F.INNER)
RETURN
 
**********
PROCESS:
**********
     
        
    Y.PROP.CLASS.IN = 'ACCOUNT'
    Y.PROPERTY = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS.IN,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES.ACCOUNT,ERR.MSG)
    Y.ACCOUNT.PROPERTY = RAISE(RETURN.VALUES.ACCOUNT)
    Y.AA.AC.LOC.REF = Y.ACCOUNT.PROPERTY<AA.Account.Account.AcLocalRef>
    Y.AA.PAD.AC = Y.AA.AC.LOC.REF<1, Y.PAD.AC.POS>
    A.LTR.ACCT.NUM = Y.ACCOUNT.PROPERTY<AA.Account.Account.AcAccountReference>
         
    IF Y.AA.PAD.AC NE '' THEN
        EB.DataAccess.FRead(FN.INNER, Y.AA.PAD.AC, REC.INNER, F.INNER, ERR.LTR)
        REC.INNER<LTR.INNER.LTR.ID> = A.LTR.ACCT.NUM
        REC.INNER<LTR.INNER.LTR.CCY> = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCurrency>
        REC.INNER<LTR.INNER.LTR.AMOUNT> = EB.SystemTables.getRNew(AA.TermAmount.TermAmount.AmtAmount)
        REC.INNER<LTR.INNER.PAD.UTILIZE> = 'N'
        EB.DataAccess.FWrite(FN.INNER,Y.AA.PAD.AC,REC.INNER)
    END

RETURN
END
 
