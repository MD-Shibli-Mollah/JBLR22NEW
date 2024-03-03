SUBROUTINE TF.BD.A.REV.STD.FT
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
    $USING FT.Contract
    $USING EB.TransactionControl
   
    GOSUB INITIALIZE
    GOSUB MAIN.PROCESS
    
RETURN

********************
INITIALIZE:
********************
    FN.StdFileRec = 'F.EB.BD.FT.STUDENTFILE.REC'
    F.StdFileRec = ''
    FN.StdFile='F.EB.BD.TF.STUDENTFILE'
    F.StdFile=''
    FN.Ft = 'FBNK.FUNDS.TRANSFER'
    F.Ft = ''
    
    EB.DataAccess.Opf(FN.StdFileRec, F.StdFileRec)
    EB.DataAccess.Opf(FN.StdFile, F.StdFile)
    EB.DataAccess.Opf(FN.Ft, F.Ft)
    
    yAppName = 'FUNDS.TRANSFER':FM:'EB.BD.TF.STUDENTFILE'
    yLocalFields ='LT.TF.STUD.FLNO':FM:'LT.STD.REM.AMT'
    yFieldsPos = ""
    EB.Updates.MultiGetLocRef(yAppName,yLocalFields,yFieldsPos)
    yFtStdIdPos = yFieldsPos<1,1>
    yStdRemAmtPos = yFieldsPos<2,1>
RETURN

********************
MAIN.PROCESS:
********************

    IF EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus) EQ 'RNAU' THEN
        yFtRefId = EB.SystemTables.getIdNew()
        EB.DataAccess.FRead(FN.Ft,yFtRefId,RecFt,F.Ft,ErrFt)
        yFtLocRef = RecFt<FT.Contract.FundsTransfer.LocalRef>
        yFtStdId = yFtLocRef<1,yFtStdIdPos>
        yFtCrDt = RecFt<FT.Contract.FundsTransfer.CreditValueDate>[1,4]
        yStdId = yFtStdId:'.':yFtCrDt
        EB.DataAccess.FRead(FN.StdFileRec,yStdId,RStdFileRec,F.StdFileRec,ErrStdFileRec)
      *  IF RecStdFile NE '' THEN
	IF RStdFileRec NE '' THEN
            yStdFtAll = RStdFileRec<EB.JBL70.FT.TXN.REF>
            yStdFtRemAmt = RStdFileRec<EB.JBL70.REMIT.AMT>
            yStdFtDate = RStdFileRec<EB.JBL70.REMIT.DATE>
            
            LOCATE yFtRefId IN yStdFtAll<1,1> SETTING yFtIdPos THEN NULL
            IF yFtIdPos NE '' THEN

*                DEL RecStdFile<EB.JBL70.FT.TXN.REF,yFtIdPos>
*                DEL RecStdFile<EB.JBL70.REMIT.AMT,yFtIdPos>
*                DEL RecStdFile<EB.JBL70.REMIT.DATE,yFtIdPos>
                EB.DataAccess.FRead(FN.StdFile,yFtStdId,RecStdFile,F.StdFile,ErrStdFile)
                yStdlocref = RecStdFile<EB.JBL50.LOCAL.REF>
                yStdRemAmt = yStdlocref<1,yStdRemAmtPos>
               * yStdlocref<1,yStdRemAmtPos> = yStdRemAmt + RStdFileRec<EB.JBL70.REMIT.AMT,yFtIdPos>
                yStdNewAmt = yStdRemAmt + RStdFileRec<EB.JBL70.REMIT.AMT,yFtIdPos>
                yStdlocref<1,yStdRemAmtPos> = yStdNewAmt
                RecStdFile<EB.JBL50.LOCAL.REF> = yStdlocref
                WRITE RecStdFile ON F.StdFile, yFtStdId
                
                RStdFileRec<EB.JBL70.FT.TXN.REF,yFtIdPos> = ''
                RStdFileRec<EB.JBL70.REMIT.AMT,yFtIdPos> = ''
                RStdFileRec<EB.JBL70.REMIT.DATE,yFtIdPos> = ''
                WRITE RStdFileRec ON F.StdFileRec, yStdId
            END
        END
    END
RETURN
END