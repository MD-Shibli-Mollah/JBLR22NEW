SUBROUTINE TF.BD.V.STDFILE.SET.REM.AMT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $INSERT I_F.EB.BD.FT.STUDENTFILE.REC
    $INSERT I_F.EB.BD.TF.STUDENTFILE
    $USING EB.SystemTables
    $USING EB.Updates
    $USING EB.DataAccess
       
    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
    
RETURN

********************
INITIALIZE:
********************
    FN.STDFILE.REC='F.EB.BD.FT.STUDENTFILE.REC'
    F.STDFILE.REC=''
    
    FN.STDFILE = 'F.EB.BD.TF.STUDENTFILE'
    F.STDFILE  = ''
    EB.DataAccess.Opf(FN.STDFILE.REC, F.STDFILE.REC)
    EB.DataAccess.Opf(FN.STDFILE, F.STDFILE)


    yAppName = 'EB.BD.TF.STUDENTFILE'
    yLocalFields ='LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT':VM:'LT.TF.STUD.FLNO'
    yFieldsPos = ""
    EB.Updates.MultiGetLocRef(yAppName,yLocalFields,yFieldsPos)
    yStdMaxLimAmtPos = yFieldsPos<1,1>
    yStdRemAmtPos = yFieldsPos<1,2>
    ystudentIdPos = yFieldsPos<1,3>
    
RETURN

********************
MAIN.PROCESS:
********************
    yStdMaxAmt = EB.SystemTables.getComi()

    yLocRef = EB.SystemTables.getRNew(EB.JBL50.LOCAL.REF)
    yStudentId = yLocRef<1,ystudentIdPos>
    yBBperDate = EB.SystemTables.getRNew(EB.JBL50.BB.PERMISSION.DATE)[1,4]
    ystudentIdDT = yStudentId:'.':yBBperDate
    
    EB.DataAccess.FRead(FN.STDFILE.REC,ystudentIdDT, Rec.Std, F.STDFILE.REC,Y.ERR.REC)
    IF Rec.Std EQ '' THEN
        yLocRef<1,yStdRemAmtPos> = yStdMaxAmt
        EB.SystemTables.setRNew(EB.JBL50.LOCAL.REF, yLocRef)
    END

RETURN

END
