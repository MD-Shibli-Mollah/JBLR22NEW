SUBROUTINE TF.JBL.A.IMP.PAY.UPDATE
*-----------------------------------------------------------------------------
* Developed by : s.azam@fortress-global.com
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.IMP.PART.PAY.INFO
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING ST.CurrencyConfig
    $USING LC.Contract
    $USING FT.Contract
    $USING EB.TransactionControl
    
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*--
INIT:
*----
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    FN.JBL.IMP = 'F.JBL.IMP.PART.PAY.INFO'
    F.JBL.IMP = ''
    FLD.POS = ''
    APPLICATION.NAME = 'FUNDS.TRANSFER'
    LOCAL.FIELDS = 'LT.FT.DR.REFNO'
    EB.Foundation.MapLocalFields(APPLICATION.NAME, LOCAL.FIELDS, FLD.POS)
    Y.FT.DR.REFNO.POS = FLD.POS<1,1>
RETURN
*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.CUR, F.CUR)
    EB.DataAccess.Opf(FN.JBL.IMP, F.JBL.IMP)
RETURN

*-------
PROCESS:
*-------
    Y.FT.ID = EB.SystemTables.getIdNew()
    Y.FT.DR.REFNO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1,Y.FT.DR.REFNO.POS>
    Y.FT.CCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditCurrency)
    Y.CR.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    EB.DataAccess.FRead(FN.DR,Y.FT.DR.REFNO,R.DR,F.DR,ERR.DR)
    Y.DR.CCY = R.DR<LC.Contract.Drawings.TfDrDrawCurrency>
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
    EB.DataAccess.FRead(FN.JBL.IMP,Y.FT.DR.REFNO,R.JBL.IMP,F.JBL.IMP,E.JBL.IMP)
    IF R.JBL.IMP EQ '' THEN
        R.JBL.IMP<JBL.IMP.FT.TXN.REF> = Y.FT.ID
        R.JBL.IMP<JBL.IMP.FT.TXN.DATE> = EB.SystemTables.getToday()
        R.JBL.IMP<JBL.IMP.DOC.PAY.CCY> = Y.DR.CCY
        R.JBL.IMP<JBL.IMP.DOC.PAY.AMT> = Y.DOC.AMT
        R.JBL.IMP<JBL.IMP.TOTAL.PAY.AMT> = Y.DOC.AMT
        R.JBL.IMP<JBL.IMP.DOC.PAY.DATE> = ''
        R.JBL.IMP<JBL.IMP.CO.CODE> = EB.SystemTables.getIdCompany()
        R.JBL.IMP<JBL.IMP.INPUTTER> = EB.SystemTables.getOperator()
        R.JBL.IMP<JBL.IMP.AUTHORISER> = EB.SystemTables.getOperator()
    END ELSE
        Y.DCOUNT = DCOUNT(R.JBL.IMP<JBL.IMP.FT.TXN.REF>,VM) + 1
        R.JBL.IMP<JBL.IMP.FT.TXN.REF,Y.DCOUNT> = Y.FT.ID
        R.JBL.IMP<JBL.IMP.FT.TXN.DATE,Y.DCOUNT> = EB.SystemTables.getToday()
        R.JBL.IMP<JBL.IMP.DOC.PAY.CCY,Y.DCOUNT> = Y.DR.CCY
        R.JBL.IMP<JBL.IMP.DOC.PAY.AMT,Y.DCOUNT> = Y.DOC.AMT
        R.JBL.IMP<JBL.IMP.TOTAL.PAY.AMT> = R.JBL.IMP<JBL.IMP.TOTAL.PAY.AMT> + Y.DOC.AMT
        R.JBL.IMP<JBL.IMP.DOC.PAY.DATE> = ''
        R.JBL.IMP<JBL.IMP.INPUTTER> = EB.SystemTables.getOperator()
        R.JBL.IMP<JBL.IMP.AUTHORISER> = EB.SystemTables.getOperator()
    END
    EB.DataAccess.FWrite(FN.JBL.IMP,Y.FT.DR.REFNO,R.JBL.IMP)
    EB.TransactionControl.JournalUpdate(Y.FT.DR.REFNO)
RETURN
END
