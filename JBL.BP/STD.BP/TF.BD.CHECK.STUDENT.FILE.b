SUBROUTINE TF.BD.CHECK.STUDENT.FILE
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
    $USING FT.Contract
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
RETURN

*-------
INIT:
*-------
    FN.FT='F.FUNDS.TRANSFER'
    F.FT=''
    
    FN.STDFILE='F.EB.BD.TF.STUDENTFILE'
    F.STDFILE=''
    Y.APP.NAME = 'FUNDS.TRANSFER':FM:'EB.BD.TF.STUDENTFILE'
    LOCAL.FIELDS ='LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT':FM:'LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)

    Y.LT.TF.MX.AW.AMT.FT.POS = FLD.POS<1,1>
    Y.LT.REM.AMT.FT.POS = FLD.POS<1,2>
    Y.LT.TF.MX.AW.AMT.STD.POS = FLD.POS<2,1>
    Y.LT.REM.AMT.STD.POS = FLD.POS<2,2>

RETURN

*-----------
OPENFILES:
*------------
    EB.DataAccess.Opf(FN.STDFILE, F.STDFILE)
    EB.DataAccess.Opf(FN.FT,F.FT)
    
RETURN
*--------
PROCESS:
*--------
    Y.FT.LOC.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.STDFILE.NO = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.STDFILE,Y.STDFILE.NO,REC.STDFILE,F.STDFILE,Y.ERR)
    IF REC.STDFILE EQ "" THEN
        EB.SystemTables.setE('CUSTOMER NOT PRESENT IN STUDENT FILE')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    Y.EB.STD.LOC.REF= REC.STDFILE<EB.JBL50.LOCAL.REF>
    Y.STD.AACT = REC.STDFILE<EB.JBL50.ACCOUNT.NUMBER>
    Y.EB.MX.AW.AMT = Y.EB.STD.LOC.REF<1,Y.LT.TF.MX.AW.AMT.STD.POS>
    Y.EB.REM.AMT = Y.EB.STD.LOC.REF<1,Y.LT.REM.AMT.STD.POS>
    Y.FT.LOC.REF<1,Y.LT.TF.MX.AW.AMT.FT.POS> = Y.EB.MX.AW.AMT
    Y.FT.LOC.REF<1,Y.LT.REM.AMT.FT.POS> = Y.EB.REM.AMT
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.FT.LOC.REF)
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.STD.AACT)
RETURN

END
