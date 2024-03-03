SUBROUTINE GB.JBL.V.TT.BR
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $USING EB.SystemTables
    $USING TT.Contract
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.Updates
    
    
    Y.ACC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
     
*   IF OFS$OPERATION EQ 'BUILD' THEN
        
    FN.ACC = "F.ACCOUNT"
    F.ACC = ""
    Y.TT.LT.BRANCH = ""
    
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    
    EB.DataAccess.FRead(FN.ACC, Y.ACC, R.ACC, F.ACC, ACC.ERR)
    Y.CO.CODE = R.ACC<AC.AccountOpening.Account.CoCode>

    APPLICATION.NAME = 'TELLER'
    Y.FILED.NAME = 'LT.BRANCH'
    Y.FIELD.POS = ''
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,Y.FILED.NAME,Y.FIELD.POS)
    Y.LT.BRANCH.POS= Y.FIELD.POS<1,1>
    Y.TT.LT.BRANCH = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
    Y.TT.LT.BRANCH<1,Y.LT.BRANCH.POS> = Y.CO.CODE
    EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.TT.LT.BRANCH)

RETURN

END
