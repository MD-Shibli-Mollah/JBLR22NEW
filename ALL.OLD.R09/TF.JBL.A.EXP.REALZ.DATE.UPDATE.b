SUBROUTINE TF.JBL.A.EXP.REALZ.DATE.UPDATE
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
    $USING EB.TransactionControl

*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.JBL.EXP = 'F.JBL.EXP.PART.PAY.INFO'
    F.JBL.EXP = ''
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.JBL.EXP, F.JBL.EXP)
RETURN

*-------
PROCESS:
*-------
    Y.DR.NO = EB.SystemTables.getIdNew()
    Y.CR.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)
    EB.DataAccess.FRead(FN.JBL.EXP,Y.DR.NO,R.JBL.EXP,F.JBL.EXP,E.JBL.EXP)
    R.JBL.EXP<JBL.EXP.DOC.REALZ.DATE> = Y.CR.DATE
    EB.DataAccess.FWrite(FN.JBL.EXP,Y.DR.NO,R.JBL.EXP)
    EB.TransactionControl.JournalUpdate(Y.DR.NO)
RETURN
END
