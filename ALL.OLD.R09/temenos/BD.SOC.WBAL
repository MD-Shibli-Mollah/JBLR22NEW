$PACKAGE BD.Soc
*
* Implementation of BD.Soc.GetWBal
*
* Y.ACCOUNTNO(IN) :
* Y.WBAL(OUT) :
*
FUNCTION BD.SOC.WBAL(Y.ACCOUNTNO, Y.WBAL)


    $USING  EB.DataAccess
    $USING  AC.AccountOpening
    
    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACCOUNTNO, R.ACC, F.ACCOUNT, Er)
    Y.WBAL=R.ACC<AC.AccountOpening.Account.WorkingBalance>
RETURN