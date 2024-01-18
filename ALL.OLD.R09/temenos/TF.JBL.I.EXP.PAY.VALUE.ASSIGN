SUBROUTINE TF.JBL.I.EXP.PAY.VALUE.ASSIGN
*-----------------------------------------------------------------------------
* Developed by : s.azam@fortress-global.com
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.EXP.PART.PAY.INFO
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING LC.Contract
    $USING EB.ErrorProcessing
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    FN.JBL.EXP = 'F.JBL.EXP.PART.PAY.INFO'
    F.JBL.EXP = ''
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.JBL.EXP, F.JBL.EXP)
RETURN

*-------
PROCESS:
*-------
    Y.DR.NO = EB.SystemTables.getIdNew()
    Y.TfDrAssignmentRef = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssignmentRef)
    Y.TfDrAssnCrAcct = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssnCrAcct)
    Y.TfDrAssnAmount = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssnAmount)
    Y.DR.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
    EB.DataAccess.FRead(FN.JBL.EXP,Y.DR.NO,R.JBL.EXP,F.JBL.EXP,E.JBL.EXP)
    Y.TOT.PAY.AMT = R.JBL.EXP<JBL.EXP.TOTAL.RECV.AMT>
    Y.REALZ.DATE = R.JBL.EXP<JBL.EXP.DOC.REALZ.DATE>
    IF Y.REALZ.DATE NE '' THEN
        Y.OVERR.ID = 'Already Paid'
        EB.SystemTables.setEtext(Y.OVERR.ID)
        EB.ErrorProcessing.StoreEndError()
    END
    Y.ASIGNMENT.REF = 'TPRECV':VM:'TPPAY'
***************************20210921***************START************************
    Y.ASSN.CR.ACCT = Y.DR.CCY:'13504':VM:Y.DR.CCY:'13504'
***************************20210921***************END************************
    Y.ASSN.AMT = Y.TOT.PAY.AMT:VM:Y.TOT.PAY.AMT
    IF Y.TfDrAssignmentRef EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssignmentRef, Y.ASIGNMENT.REF)
    END
    IF Y.TfDrAssnCrAcct EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssnCrAcct, Y.ASSN.CR.ACCT)
    END
    IF Y.TfDrAssnAmount EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssnAmount, Y.ASSN.AMT)
    END
RETURN
END
