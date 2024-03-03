SUBROUTINE TF.BD.A.STDFILE.TXN.DET
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.BD.FT.STUDENTFILE.REC
    $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING EB.TransactionControl
    
    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
RETURN

********************
INITIALIZE:
********************

    FN.StdData = "F.EB.BD.FT.STUDENTFILE.REC"
    F.StdData = ""

    EB.DataAccess.Opf(FN.StdData,F.StdData)

    yAppName ='FUNDS.TRANSFER'
    yLocalFields = 'LT.TF.STUD.FLNO' : VM : 'LT.TF.MX.AW.AMT'
    EB.Updates.MultiGetLocRef(yAppName, yLocalFields, yFieldsPos)
    yFtStdNoPos = yFieldsPos<1,1>
    yFtMaxLimAmtPos = yFieldsPos<1,2>

RETURN

********************
MAIN.PROCESS:
********************
 
    yStdId = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,yFtStdNoPos>:".":EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)[1,4]
    
    EB.DataAccess.FRead(FN.StdData,yStdId,RecStdData,F.StdData,ErrStdData)
    IF RecStdData EQ '' THEN
        RecStdData<EB.JBL70.FT.TXN.REF> = EB.SystemTables.getIdNew()
        RecStdData<EB.JBL70.LIMIT.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,yFtMaxLimAmtPos>
        RecStdData<EB.JBL70.REMIT.AMT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        RecStdData<EB.JBL70.REMIT.DATE> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)
    END ELSE
        RecStdData<EB.JBL70.LIMIT.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,yFtMaxLimAmtPos>
        yDcountFtId = DCOUNT(RecStdData<EB.JBL70.FT.TXN.REF>,VM) + 1
        RecStdData<EB.JBL70.FT.TXN.REF,yDcountFtId> = EB.SystemTables.getIdNew()
        RecStdData<EB.JBL70.REMIT.AMT,yDcountFtId> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        RecStdData<EB.JBL70.REMIT.DATE,yDcountFtId> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)
    END
    
    WRITE RecStdData ON F.StdData, yStdId
    
RETURN

END
