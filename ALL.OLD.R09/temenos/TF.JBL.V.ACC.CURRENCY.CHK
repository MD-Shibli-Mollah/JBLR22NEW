* @ValidationCode : MjoxMTI5MjQ1NTYzOkNwMTI1MjoxNTkzNzAwMzUxNjk4OkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Jul 2020 20:32:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE TF.JBL.V.ACC.CURRENCY.CHK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*Subroutine Description: This routine check drawings credit account currency and charge amt currency same or not
*Subroutine Type       : Validation routine
*Attached To           : Version - DRAWINGS,JBL.IMPMAT
*Attached As           : ROUTINE
*Developed by          : S.M. Sayeed
*Designation           : Technical Consultant
*Email                 : s.m.sayeed@fortress-global.com
*Incoming Parameters   :
*Outgoing Parameters   :
*-----------------------------------------------------------------------------
* Modification History :
* 1)
*    Date :
*    Modification Description :
*    Modified By  :
*
*-----------------------------------------------------------------------------
*
*1/S----Modification Start
*
*1/E----Modification End
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Updates
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    Y.FIELD = 'LT.DR.CHG.ACCT':VM:'LT.ADD.CHG.AMT'
    Y.APP ='DRAWINGS'
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
RETURN

PROCESS:
    Y.CR.ACC.NUM = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrPaymentAccount)
    EB.DataAccess.FRead(FN.ACC, Y.CR.ACC.NUM, REC.ACC, F.ACC, Er.ACC)
    Y.CR.ACC.CURRENCY = REC.ACC<AC.AccountOpening.Account.Currency>
    EB.Updates.MultiGetLocRef(Y.APP, Y.FIELD, Y.LT.POS)
    Y.CHG.AMT.POS = Y.LT.POS<1,2>
    Y.TOT.LOCALREF = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.ADD.CHG.AMT = Y.TOT.LOCALREF<1,Y.CHG.AMT.POS>
    IF Y.ADD.CHG.AMT THEN
        Y.AMT.CURRENCY = Y.ADD.CHG.AMT[1,3]
        IF Y.CR.ACC.CURRENCY NE Y.AMT.CURRENCY THEN
            Y.ERR.MSG = "Credit Account Currency ":Y.CR.ACC.CURRENCY:" Crg Amt Currency ":Y.AMT.CURRENCY:" both are not same!"
            EB.SystemTables.setEtext(Y.ERR.MSG)
            EB.SystemTables.setAf(LC.Contract.Drawings.TfDrLocalRef)
            EB.SystemTables.setAv(Y.CHG.AMT.POS)
            EB.ErrorProcessing.StoreEndError()
        END
    END
RETURN

END
