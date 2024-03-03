SUBROUTINE TF.BD.STD.AMT.LIM.CHK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* ATTACH AS A INPUT ROUTINE IN TO STUDENT FILE MODULE
* VERSION NANE : FUNDS.TRANSFER,JBL.OT103.STD.REM
* CALCULATE THE TOTAL LIMIT AMOUNT AND REMAINING AMOUNT
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
    LOCAL.FIELDS ='LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT':VM:'LT.TF.STUD.FLNO':FM:'LT.TF.MX.AW.AMT':VM:'LT.STD.REM.AMT':VM:'LT.TF.STUD.FLNO'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
* Y.LT.TF.STDFILE.NO.POS = FLD.POS<1,1>
    Y.LT.TF.MX.AW.AMT.FT.POS = FLD.POS<1,1>
    Y.LT.STD.REM.AMT.FT.POS = FLD.POS<1,2>
    Y.LT.TF.STUD.FLNO.FT.POS = FLD.POS<1,3>
    Y.LT.TF.MX.AW.AMT.STD.POS = FLD.POS<2,1>
    Y.LT.STD.REM.AMT.POS = FLD.POS<2,2>
    Y.LT.TF.STD.FL.NO.STD.POS = FLD.POS<2,3>

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
    Y.STDFILE.NO = Y.FT.LOC.REF<1,Y.LT.TF.STUD.FLNO.FT.POS>
    Y.LT.TF.MX.AW.AMT.FT = Y.FT.LOC.REF<1,Y.LT.TF.MX.AW.AMT.FT.POS>
    EB.DataAccess.FRead(FN.STDFILE,Y.STDFILE.NO,REC.STD,F.STDFILE,Y.ERR)
    Y.BB.PER.DATE = REC.STD<EB.JBL50.BB.PERMISSION.DATE>[1,4]
    Y.CR.DATE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditValueDate)[1,4]
    IF Y.BB.PER.DATE NE Y.CR.DATE THEN
        EB.SystemTables.setEtext('DATE NOT SAME')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    Y.STD.LOC.REF = REC.STD<EB.JBL50.LOCAL.REF>
    Y.FT.REM.AMT = Y.STD.LOC.REF<1,Y.LT.STD.REM.AMT.POS>
    IF Y.BB.PER.DATE EQ Y.CR.DATE THEN
        Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        * Y.AMT.DEBT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AmountDebited)
	* Y.AMT.DEBT = Y.AMT.DEBT[4,LEN(Y.AMT.DEBT)-3]
        IF Y.CR.AMT GT Y.LT.TF.MX.AW.AMT.FT THEN
            EB.SystemTables.setEtext('Credit amount cross the maximum limit amount')
            EB.ErrorProcessing.StoreEndError()
        END
	* IF Y.AMT.DEBT GT Y.LT.TF.MX.AW.AMT.FT THEN
         *   EB.SystemTables.setEtext('Credit amount cross the maximum limit amount')
          * EB.ErrorProcessing.StoreEndError()
        *END

        IF Y.CR.AMT GT Y.FT.REM.AMT THEN
            EB.SystemTables.setEtext('User Already Crossed Remaining Limit Amount')
            EB.ErrorProcessing.StoreEndError()
        END
	*IF Y.AMT.DEBT GT Y.FT.REM.AMT THEN
         *   EB.SystemTables.setEtext('User Already Crossed Remaining Limit Amount')
          *  EB.ErrorProcessing.StoreEndError()
        *END

       
    END
RETURN

END
