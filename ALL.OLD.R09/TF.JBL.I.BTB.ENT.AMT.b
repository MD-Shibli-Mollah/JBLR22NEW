SUBROUTINE TF.JBL.I.BTB.ENT.AMT
*-----------------------------------------------------------------------------
* CREATE DATE: 11/16/2020
* DESCRIPTION: *To check the new entitle amount exceed the job opend entitle amount
* ATTACHED VERSION: BD.SCT.CAPTURE,CONT.AMEND
* Created : Md. Ebrahim Khalil Rian
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*-----------------------------------------------------------------------------
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
   
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
INIT:
    FN.BD.BTB.JOB.REGISTER = 'F.BD.BTB.JOB.REGISTER'
    F.BD.BTB.JOB.REGISTER = ''
    
    Y.JOB.REG.ID = EB.SystemTables.getRNew(SCT.BTB.JOB.NO)
RETURN
OPENFILES:
    EB.DataAccess.Opf(FN.BD.BTB.JOB.REGISTER,F.BD.BTB.JOB.REGISTER)
RETURN

PROCESS:
    EB.DataAccess.FRead(FN.BD.BTB.JOB.REGISTER, Y.JOB.REG.ID, REC.JOB.REG, F.BD.BTB.JOB.REGISTER, ERR.JOB.REG)
    Y.TOT.BTB.USED.AMT = REC.JOB.REG<BTB.JOB.TOT.BTB.AMT>
    Y.BTB.ENT.AMT.OLD = EB.SystemTables.getROld(SCT.BTB.ENT.AMT)
    Y.BTB.ENT.AMT.NEW = EB.SystemTables.getRNew(SCT.BTB.ENT.AMT)
    Y.TOT.BTB.ENT.AMT = REC.JOB.REG<BTB.JOB.TOT.BTB.ENT.AMT>
    Y.NEW.TOT.BTB.ENT.AMT = (Y.TOT.BTB.ENT.AMT - Y.BTB.ENT.AMT.OLD + Y.BTB.ENT.AMT.NEW)

    IF Y.NEW.TOT.BTB.ENT.AMT LT Y.TOT.BTB.USED.AMT THEN
        EB.SystemTables.setAf(SCT.BTB.ENT.AMT)
        EB.SystemTables.setEtext("New BTB entitlement amount falls below the BTB used amount")
        EB.ErrorProcessing.StoreEndError()
    END

    Y.TOT.PC.USED.AMT = REC.JOB.REG<BTB.JOB.TOT.PC.AMT>
    Y.PCECC.ENT.AMT.OLD = EB.SystemTables.getROld(SCT.PCECC.ENT.AMT)
    Y.PCECC.ENT.AMT.NEW = EB.SystemTables.getRNew(SCT.PCECC.ENT.AMT)
    Y.TOT.PCECC.ENT.AMT = REC.JOB.REG<BTB.JOB.TOT.PC.ENT.AMT>
    Y.NEW.TOT.PC.ENT.AMT = (Y.TOT.PCECC.ENT.AMT - Y.PCECC.ENT.AMT.OLD + Y.PCECC.ENT.AMT.NEW)
    IF Y.NEW.TOT.PC.ENT.AMT LT Y.TOT.PC.USED.AMT THEN
        EB.SystemTables.setAf(SCT.PCECC.ENT.AMT)
        EB.SystemTables.setEtext("New PC entitlement amount falls below the PC used amount")
        EB.ErrorProcessing.StoreEndError()
    END
    
    Y.CONT.AMT = EB.SystemTables.getRNew(SCT.CONTRACT.AMT)
    Y.CONT.USE.AMT = EB.SystemTables.getRNew(SCT.CONTRACT.USE.AMT)
    IF Y.CONT.AMT LT Y.CONT.USE.AMT THEN
        EB.SystemTables.setAf(SCT.CONTRACT.AMT)
        EB.SystemTables.setEtext("New contact amount falls below the contact used amount")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

    
END
