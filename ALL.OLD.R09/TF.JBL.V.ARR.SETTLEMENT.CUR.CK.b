SUBROUTINE TF.JBL.V.ARR.SETTLEMENT.CUR.CK
*-----------------------------------------------------------------------------
*Subroutine Description: this routine check all settlement account ccy match with arrangement ccy.
*Subroutine Type       :
*Attached To           :
*Attached As           : PRE VALIDATION Routine
*Developed by          : #-mahmudur rahman udoy-#
*Activity.api          : JBL.TF.FDBP.API & JBL.TF.IBD.API
*Incoming Parameters   :
*Outgoing Parameters   :
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
*
    $USING EB.SystemTables
    $USING AA.Framework
    $USING AA.Settlement
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
*
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
*-------
INIT:
*-------
    FN.ACC = 'F.ACCOUNT'
    F.ACC  = ''
RETURN
*---------
OPENFILE:
*---------
    EB.DataAccess.Opf(FN.ACC,F.ACC)
RETURN
*-------
PROCESS:
*-------
    Y.ARR.CUR = c_aalocArrActivityRec<AA.Framework.ArrangementActivity.ArrActCurrency>
    Y.PAYIN.ACC  = EB.SystemTables.getRNew(AA.Settlement.Settlement.SetPayinAccount)
    Y.PAYOUT.ACC = EB.SystemTables.getRNew(AA.Settlement.Settlement.SetPayoutAccount)
   
    EB.DataAccess.FRead(FN.ACC, Y.PAYIN.ACC, REC.ACC, F.ACC, REC.ERR)
    IF REC.ACC THEN
        Y.PAYIN.CUR =   REC.ACC<AC.AccountOpening.Account.Currency>
        IF Y.ARR.CUR NE Y.PAYIN.CUR AND Y.PAYIN.CUR NE '' THEN
            EB.SystemTables.setAf(AA.Settlement.Settlement.SetPayinAccount)
            EB.SystemTables.setEtext("ARR currency and Settlement payin account currency must be same!")
            EB.ErrorProcessing.StoreEndError()
        END
    END
     
    EB.DataAccess.FRead(FN.ACC, Y.PAYOUT.ACC, REC.OUT.ACC, F.ACC, REC.ERR)
    IF REC.OUT.ACC THEN
        Y.PAYOUT.CUR =  REC.OUT.ACC<AC.AccountOpening.Account.Currency>
        IF Y.ARR.CUR NE Y.PAYOUT.CUR AND Y.PAYOUT.CUR NE '' THEN
            EB.SystemTables.setAf(AA.Settlement.Settlement.SetPayoutAccount)
            EB.SystemTables.setEtext("ARR currency and Settlement payout account currency must be same!")
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN
END

