SUBROUTINE TF.BD.I.BLOCK.LIM.AMT
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
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.ErrorProcessing
            
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
RETURN

*-------
INIT:
*-------
    FN.STDFILE='F.EB.BD.TF.STUDENTFILE'
    F.STDFILE=''
    
    FN.STDFILE.REC ='F.EB.BD.FT.STUDENTFILE.REC'
    F.STDFILE.REC =''
    
    Y.APP.NAME = 'EB.BD.TF.STUDENTFILE'
    LOCAL.FIELDS ='LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT':VM:'LT.TF.STUD.FLNO'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.LT.TF.MX.AW.AMT.STD.POS = FLD.POS<1,1>
    Y.LT.STD.REM.AMT.POS = FLD.POS<1,2>
    Y.LT.TF.STD.FL.NO.STD.POS = FLD.POS<1,3>
RETURN

*------------
OPENFILES:
*------------
    EB.DataAccess.Opf(FN.STDFILE, F.STDFILE)
    EB.DataAccess.Opf(FN.STDFILE.REC, F.STDFILE.REC)
RETURN

*--------
PROCESS:
*--------
    Y.STUDENT.OLD.ID = EB.SystemTables.getIdNew()
    Y.BB.PER.DATE = EB.SystemTables.getRNew(EB.JBL50.BB.PERMISSION.DATE)[1,4]
    Y.LOC.REF = EB.SystemTables.getRNew(EB.JBL50.LOCAL.REF)
    Y.MAX.PR.LIM = Y.LOC.REF<1,Y.LT.TF.MX.AW.AMT.STD.POS>
    Y.STUDENT.ID = Y.STUDENT.OLD.ID:'.':Y.BB.PER.DATE
    EB.DataAccess.FRead(FN.STDFILE.REC,Y.STUDENT.ID, REC.STD.FILE, F.STDFILE.REC,Y.ERR.REC)
    IF REC.STD.FILE NE '' THEN
        Y.REMIT.AMT = REC.STD.FILE<EB.JBL70.REMIT.AMT>
        FOR I=1 TO DCOUNT(Y.REMIT.AMT,@VM)
            Y.TOT.REMIT.AMT = Y.TOT.REMIT.AMT + Y.REMIT.AMT<1,I>
        NEXT I
        IF Y.TOT.REMIT.AMT GE Y.MAX.PR.LIM THEN
            EB.SystemTables.setEtext('Increase Limit: Limit less than existing Txn')
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN

END
