$PACKAGE BD.Soc
*
* Implementation of BD.SOC.SocGetDate
*
* Y.TODAY(IN) :
* Y.START.DATE(OUT) :
* Y.END.DATE(OUT) :
*
FUNCTION BD.SOC.GETDATE(Y.ACCOUNTNO, Y.START.DATE, Y.END.DATE)
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING AC.AccountOpening
    $USING EB.SystemTables
    
    R.ACC=AC.AccountOpening.Account.Read(Y.ACCOUNTNO, Error)
    Y.ArrStartDate= R.ACC<AC.AccountOpening.Account.OpeningDate>
    Y.END.DATE = EB.SystemTables.getToday()
    Y.END.MNTH = Y.END.DATE[5,2] 'R%2'
    IF Y.END.MNTH LE '06' THEN
        Y.START.DATE = Y.END.DATE[1,4]:'0101'
        Y.END.DATE = Y.END.DATE[1,4]:'0630'
    END ELSE
        Y.START.DATE = Y.END.DATE[1,4]:'0701'
        Y.END.DATE = Y.END.DATE[1,4]:'1231'
    END
    IF Y.START.DATE LT Y.ArrStartDate THEN
        Y.START.DATE = Y.ArrStartDate
    END
RETURN
