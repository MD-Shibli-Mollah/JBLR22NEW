* @ValidationCode : MjoxODgwMzU0NjExOkNwMTI1MjoxNTkzODAzMjg3ODQ4OkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAxNzEwLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 04 Jul 2020 01:08:07
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE TF.JBL.A.LT.UPDATE.CRG.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
*Subroutine Description: This routine check drawings credit account currency and charge amt currency same or not
*Subroutine Type       : Before Auth routine
*Attached To           : Version
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
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.Updates
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    Y.FIELD = 'LT.TOT.CRDT.AMT':VM:'LT.ADD.CHG.AMT'
    Y.APP ='DRAWINGS'
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
RETURN
PROCESS:
    EB.Updates.MultiGetLocRef(Y.APP, Y.FIELD, Y.LT.POS)
    Y.CRDT.AMT.POS = Y.LT.POS<1,1>
    Y.ADD.CHG.POS = Y.LT.POS<1,2>
    Y.TOT.LOCALREF = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.DOC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrPaymentAmount)
*Y.DOC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    Y.ADD.CHG.AMT = Y.TOT.LOCALREF<1,Y.ADD.CHG.POS>
    BEGIN CASE
        CASE Y.ADD.CHG.AMT MATCHES '3A...' AND Y.ADD.CHG.AMT NE ''
            Y.CHARGE.AMT = Y.ADD.CHG.AMT[3,99]
            IF Y.CHARGE.AMT MATCHES '1A...' THEN
                Y.CHARGE.AMT = Y.ADD.CHG.AMT[4,99]
                Y.TOT.AMT = Y.DOC.AMOUNT + Y.CHARGE.AMT
                Y.TOT.LOCALREF<1,Y.CRDT.AMT.POS> = Y.TOT.AMT
                EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TOT.LOCALREF)
            END ELSE
                Y.CHARGE.AMT = Y.ADD.CHG.AMT[3,99]
                Y.TOT.AMT = Y.DOC.AMOUNT + Y.CHARGE.AMT
                Y.TOT.LOCALREF<1,Y.CRDT.AMT.POS> = Y.TOT.AMT
                EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TOT.LOCALREF)
            END
        CASE Y.ADD.CHG.AMT EQ ''
            Y.TOT.AMT = Y.DOC.AMOUNT
            Y.TOT.LOCALREF<1,Y.CRDT.AMT.POS> = Y.TOT.AMT
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TOT.LOCALREF)
    END CASE
    
RETURN
END
