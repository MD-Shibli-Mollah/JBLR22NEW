SUBROUTINE TF.BD.STUDENT.FILE.NO.CHECK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.BD.TF.STUDENTFILE
    
    
    $USING ST.Customer
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
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
    FN.STDFILE='F.EB.BD.TF.STUDENTFILE'
    F.STDFILE=''
    
    Y.APP.NAME = 'EB.BD.TF.STUDENTFILE'
    LOCAL.FIELDS = 'LT.TF.STUD.FLNO'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.LT.TF.STD.FL.NO.POS = FLD.POS<1,1>

RETURN

*-----------
OPENFILES:
*------------
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    EB.DataAccess.Opf(FN.STDFILE, F.STDFILE)
    
RETURN
*--------
PROCESS:
*--------
    Y.CUS.ID = EB.SystemTables.getIdNew()
    Y.STD.LOC.REF = EB.SystemTables.getRNew(EB.JBL50.LOCAL.REF)
    Y.STD.FILE.NO = Y.STD.LOC.REF<1,Y.LT.TF.STD.FL.NO.POS>
          
    IF Y.CUS.ID NE Y.STD.FILE.NO THEN
        EB.SystemTables.setAf(EB.JBL50.LOCAL.REF)
        EB.SystemTables.setAv(Y.LT.TF.STD.FL.NO.POS)
        EB.SystemTables.setEtext('Student file must be same customer No.')
        EB.ErrorProcessing.StoreEndError()
    END
RETURN

END
