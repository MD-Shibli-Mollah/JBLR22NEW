SUBROUTINE TF.JBL.A.IMP.PAY.DATE.UPDATE
*-----------------------------------------------------------------------------
* Developed by : s.azam@fortress-global.com
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.IMP.PART.PAY.INFO
    
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.TransactionControl

*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.JBL.IMP = 'F.JBL.IMP.PART.PAY.INFO'
    F.JBL.IMP = ''
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.JBL.IMP, F.JBL.IMP)
RETURN
*-------
PROCESS:
*-------
    Y.DR.NO = EB.SystemTables.getIdNew()
    Y.CR.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)
    EB.DataAccess.FRead(FN.JBL.IMP,Y.DR.NO,R.JBL.IMP,F.JBL.IMP,E.JBL.IMP)
    R.JBL.IMP<JBL.IMP.DOC.PAY.DATE> = Y.CR.DATE
    EB.DataAccess.FWrite(FN.JBL.IMP,Y.DR.NO,R.JBL.IMP)
    EB.TransactionControl.JournalUpdate(Y.DR.NO)
RETURN
END
