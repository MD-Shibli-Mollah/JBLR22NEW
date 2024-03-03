SUBROUTINE TF.BD.A.CHNG.REM.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $INSERT I_F.EB.BD.TF.STUDENTFILE
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.DataAccess
    $USING FT.Contract
    $USING EB.ErrorProcessing
   
    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
    
RETURN

********************
INITIALIZE:
********************
    FN.StdFile = 'F.EB.BD.TF.STUDENTFILE'
    F.StdFile = ''
    
    EB.DataAccess.Opf(FN.StdFile, F.StdFile)

    yAppName = 'FUNDS.TRANSFER':FM:'EB.BD.TF.STUDENTFILE'
    yLocalFields ='LT.STD.REM.AMT':VM:'LT.TF.STUD.FLNO':VM:'LT.TF.MX.AW.AMT':FM:'LT.STD.REM.AMT':VM:'LT.TF.MX.AW.AMT':VM:'LT.TF.STUD.FLNO'
    yFieldsPos = ""
    EB.Updates.MultiGetLocRef(yAppName,yLocalFields,yFieldsPos)
    yFtRemAmtPos = yFieldsPos<1,1>; yFtStdIdPos = yFieldsPos<1,2>; yFtMaxlimPos = yFieldsPos<1,3>
    yStdRemAmtPos = yFieldsPos<2,1>; yStdMaxLimPos = yFieldsPos<2,2>; yStdIdPos = yFieldsPos<2,3>
        
RETURN

********************
MAIN.PROCESS:
********************
  
    
    yFtLocRef = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    *yFtRemAmt = yFtLocRef<1,yFtRemAmtPos>
    yFtStdId = yFtLocRef<1,yFtStdIdPos>
    yFtMaxLim = yFtLocRef<1,yFtMaxlimPos>
    yFtCrAmt = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
   * yFtDrAmt = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AmountDebited)
    *yFtdebitAmt  = yFtDrAmt[4,LEN(yFtDrAmt)-3]
    EB.DataAccess.FRead(FN.StdFile,yFtStdId,RecStdFile,F.StdFile,ErrStdFile)
    yStdlocref = RecStdFile<EB.JBL50.LOCAL.REF> 
    yFtRemAmt = yStdlocref<1,yStdRemAmtPos>
     IF yFtCrAmt GT yFtRemAmt THEN
       EB.SystemTables.setAf(FT.Contract.FundsTransfer.AmountDebited)
	   EB.SystemTables.setEtext('Transaction Not possible') 
       EB.ErrorProcessing.StoreEndError()
     END
    yFtRemFinAmt = yFtRemAmt - yFtCrAmt
    yFtLocRef<1,yFtRemAmtPos> = yFtRemFinAmt
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, yFtLocRef)
    *EB.DataAccess.FRead(FN.StdFile,yFtStdId,RecStdFile,F.StdFile,ErrStdFile)
    
    yStdlocref<1,yStdRemAmtPos> = yFtRemFinAmt
    yStdlocref<1, yStdIdPos> = yFtStdId
    yStdlocref<1,yStdMaxLimPos> = yFtMaxLim
    RecStdFile<EB.JBL50.LOCAL.REF> = yStdlocref
    WRITE RecStdFile ON F.StdFile, yFtStdId 

RETURN

END
