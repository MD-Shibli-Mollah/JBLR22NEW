SUBROUTINE TF.JBL.I.DR.EXP.PAY.AMT.CHECK
*-----------------------------------------------------------------------------
* Developed by : s.azam@fortress-global.com
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.EXP.PART.PAY.INFO
    
    $USING LC.Contract
    $USING FT.Contract
    $USING ST.CurrencyConfig
    $USING EB.Foundation
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*----
INIT:
*----
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    FN.JBL.EXP = 'F.JBL.EXP.PART.PAY.INFO'
    F.JBL.EXP = ''
    FLD.POS = ''
    APPLICATION.NAME = 'FUNDS.TRANSFER'
    LOCAL.FIELDS = 'LT.FT.DR.REFNO':VM:'LT.TF.CO.DOCAMT':VM:'LT.DOC.OUST.AMT'
    EB.Foundation.MapLocalFields(APPLICATION.NAME, LOCAL.FIELDS, FLD.POS)
    Y.FT.DR.REFNO.POS = FLD.POS<1,1>
    Y.TF.CO.DOCAMT.POS = FLD.POS<1,2>
    Y.DOC.OUST.AMT.POS = FLD.POS<1,3>
      
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.CUR, F.CUR)
    EB.DataAccess.Opf(FN.JBL.EXP, F.JBL.EXP)
RETURN

*-------
PROCESS:
*-------
    Y.FT.DR.REFNO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.FT.DR.REFNO.POS>
    Y.FT.CCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
    Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)

    EB.DataAccess.FRead(FN.DR,Y.FT.DR.REFNO,R.DR,F.DR,ERR.DR)
    Y.DR.TYPE = R.DR<LC.Contract.Drawings.TfDrDrawingType>
    Y.DR.CCY = R.DR<LC.Contract.Drawings.TfDrDrawCurrency>
    Y.DR.AMT = R.DR<LC.Contract.Drawings.TfDrDocumentAmount>
    IF R.DR EQ '' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
        EB.SystemTables.setAv(Y.FT.DR.REFNO.POS)
        Y.OVERR.ID = 'Invalid Drawings ID'
        EB.SystemTables.setEtext(Y.OVERR.ID)
        EB.ErrorProcessing.StoreEndError()
    END
    IF Y.DR.TYPE NE 'CO' THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.LocalRef)
        EB.SystemTables.setAv(Y.FT.DR.REFNO.POS)
        Y.OVERR.ID = 'Drawing Type must be CO'
        EB.SystemTables.setEtext(Y.OVERR.ID)
        EB.ErrorProcessing.StoreEndError()
    END
   
    EB.DataAccess.FRead(FN.CUR,Y.FT.CCY,R.CR.CUR,F.CUR,E.DR.CUR.ERR)
    EB.DataAccess.FRead(FN.CUR,Y.DR.CCY,R.DR.CUR,F.CUR,E.DR.CUR.ERR)
    Y.DR.MID.RATE = R.DR.CUR<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    BEGIN CASE
        CASE Y.FT.CCY EQ LCCY AND Y.DR.CCY EQ LCCY
            Y.EX.RATE = '1'
        CASE Y.FT.CCY EQ Y.DR.CCY
            Y.EX.RATE = '1'
        CASE Y.FT.CCY EQ LCCY AND Y.DR.CCY NE LCCY
            Y.CR.EXC.RATE = '1'
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.DR.CUR<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.DR.MKT.POS1, Y.DR.MKT.POS2, Y.DR.MKT.POS3 THEN
                Y.DR.EXC.RATE = R.DR.CUR<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.DR.MKT.POS2>
            END
            Y.EX.RATE = DROUND((Y.CR.EXC.RATE / Y.DR.EXC.RATE),4)
        CASE Y.FT.CCY NE LCCY AND Y.DR.CCY EQ LCCY
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.CR.CUR<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CR.MKT.POS1, Y.CR.MKT.POS2, Y.CR.MKT.POS3 THEN
                Y.CR.EXC.RATE = R.CR.CUR<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CR.MKT.POS2>
            END
            Y.DR.EXC.RATE = '1'
            Y.EX.RATE = DROUND((Y.CR.EXC.RATE / Y.DR.EXC.RATE),4)
        
        CASE Y.FT.CCY NE LCCY AND Y.DR.CCY NE LCCY
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.CR.CUR<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CR.MKT.POS1, Y.CR.MKT.POS2, Y.CR.MKT.POS3 THEN
                Y.CR.EXC.RATE = R.CR.CUR<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CR.MKT.POS2>
            END
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.DR.CUR<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.DR.MKT.POS1, Y.DR.MKT.POS2, Y.DR.MKT.POS3 THEN
                Y.DR.EXC.RATE = R.DR.CUR<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.DR.MKT.POS2>
            END
            Y.EX.RATE = DROUND((Y.CR.EXC.RATE / Y.DR.EXC.RATE),4)
    END CASE
    Y.DOC.AMT = DROUND((Y.EX.RATE * Y.CR.AMT),2)
    EB.DataAccess.FRead(FN.JBL.EXP,Y.FT.DR.REFNO,R.JBL.EXP,F.JBL.EXP,E.JBL.IMP)
    Y.TOT.AMT = R.JBL.EXP<JBL.EXP.TOTAL.RECV.AMT>
    Y.TEMP.TOT.AMT = Y.DR.AMT - Y.TOT.AMT
    IF R.JBL.EXP EQ '' AND Y.DOC.AMT GE Y.DR.AMT THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
        Y.OVERR.ID = 'Transaction Amount Exceed OutStanding Doc Amount'
        EB.SystemTables.setEtext(Y.OVERR.ID)
        EB.ErrorProcessing.StoreEndError()
    END
    IF R.JBL.EXP NE '' AND Y.DOC.AMT GE Y.TEMP.TOT.AMT THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAmount)
        Y.OVERR.ID = 'Transaction Amount Exceed OutStanding Doc Amount'
        EB.SystemTables.setEtext(Y.OVERR.ID)
        EB.ErrorProcessing.StoreEndError()
    END
    Y.LOCAL.FIELD = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LOCAL.FIELD<1, Y.TF.CO.DOCAMT.POS> = Y.DOC.AMT
    Y.LOCAL.FIELD<1, Y.DOC.OUST.AMT.POS> = Y.TEMP.TOT.AMT
    EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef,Y.LOCAL.FIELD)
RETURN

END
