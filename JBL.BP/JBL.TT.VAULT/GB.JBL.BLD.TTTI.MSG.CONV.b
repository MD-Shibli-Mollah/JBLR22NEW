
SUBROUTINE GB.JBL.BLD.TTTI.MSG.CONV(Y.RETURN)

*--------------------------------------------------------------------------------
* Subroutine Description:
*
* Attach To: ENQUIRY - JBL.ENQ.TT.LIMIT.AUTH
* Attach As: BUILD ROUTINE
*-----------------------------------------------------------------------------

* Modification History :  Retrofit from TTTI.MSG.CONV
* 22/09/2024 -                          NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* Teller/Vault Limit Enquiry - E.TT.LIMIT.AUTH -- JBL.ENQ.TT.LIMIT.AUTH
* Teller Over Limit Enquiry by Branch - E.TT.LIMIT -- JBL.ENQ.TT.LIMIT
* Branch Wise Teller Over Limit Enquiry by HO - JBL.ENQ.TT.LIMIT.BR
* Date Wise Teller Over Limit Enquiry by HO - JBL.ENQ.TT.LIMIT.DT
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $INSERT I_F.EB.JBL.TT.TELLER.ID
    $INSERT I_F.EB.JBL.TT.OVER.LIMT
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    $USING ST.CompanyCreation
    $USING TT.Config
    $USING TT.Contract
    $USING EB.ErrorProcessing

    Y.ID.NEW = EB.SystemTables.getIdNew()
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
*
    IF Y.RETURN<1> EQ 'JBL.ENQ.TT.LIMIT.AUTH' THEN
        Y.RETURN<4,1>= Y.RETURN<4,1>:'.':Y.ID.COMPANY[6,4]
        RETURN
    END
    Y.ENQ = EB.Reports.getEnqSelection()<1,1>
    LOCATE 'TXN.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING POS THEN
        Y.DT = EB.Reports.getEnqSelection()<4,POS>
        Y.DT.OPD = EB.Reports.getEnqSelection()<3,POS>
    END
    LOCATE 'BR.CODE' IN EB.Reports.getEnqSelection()<2,1> SETTING POS1 THEN Y.BR.CODE = EB.Reports.getEnqSelection()<4,POS1>
    LOCATE 'TELLER.ID' IN EB.Reports.getEnqSelection()<2,1> SETTING POS2 THEN Y.TID = EB.Reports.getEnqSelection()<4,POS2>

    IF Y.DT.OPD EQ 'RG' THEN
        Y.DT1 = FIELD(Y.DT,@SM,1)
        Y.DT2 = FIELD(Y.DT,@SM,2)
        IF Y.DT1 EQ '!TODAY' THEN Y.DT1 = Y.TODAY
        IF Y.DT2 EQ '!TODAY' THEN Y.DT2 = Y.TODAY
        IF Y.DT1 GT Y.DT2 OR Y.DT1 EQ '' OR Y.DT2 EQ '' THEN RETURN
    END
    IF Y.DT GT Y.TODAY THEN RETURN
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT' THEN Y.BR.CODE = Y.ID.COMPANY[6,4]
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT' AND Y.ID.COMPANY EQ 'BD0012001' THEN RETURN
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT.BR' AND Y.ID.COMPANY NE 'BD0012001' THEN RETURN
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT.DT' AND Y.ID.COMPANY NE 'BD0012001' THEN RETURN

    FN.TL = 'F.EB.JBL.TT.OVER.LIMT'
    F.TL = ''
    EB.DataAccess.Opf(FN.TL,F.TL)
    
    FN.TT = 'F.TELLER'
    F.TT = ''
    EB.DataAccess.Opf(FN.TT,F.TT)
    
    FN.TTH = 'F.TELLER$HIS'
    F.TTH = ''
    EB.DataAccess.Opf(FN.TTH,F.TTH)

    SEL.CMD = 'SELECT ':FN.TL:' WITH @ID LIKE ':Y.BR.CODE:'.':Y.DT:'...'
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT.DT' AND Y.DT EQ '' THEN SEL.CMD = 'SELECT ':FN.TL:' WITH @ID LIKE ':Y.BR.CODE:'...'
    IF Y.ENQ EQ 'JBL.ENQ.TT.LIMIT.BR' AND Y.BR.CODE EQ '' THEN SEL.CMD = 'SELECT ':FN.TL:' WITH @ID LIKE ...':Y.DT:'...'

    EB.DataAccess.Readlist(SEL.CMD, SEL.LIST, F.TL, NO.OF.REC, RET.CODE)
    SEL.LIST = SORT(SEL.LIST)
    FOR II = 1 TO NO.OF.REC
        Y.TID.CK = 1
        IF Y.TID NE '' THEN
            IF FIELD(SEL.LIST<II>,'.',5) EQ Y.TID OR FIELD(SEL.LIST<II>,'.',4) EQ Y.TID THEN
            END
            ELSE Y.TID.CK = ''
        END
        IF Y.TID.CK EQ '1' AND ((Y.BR.CODE NE '' AND FIELD(SEL.LIST<II>,'.',1) EQ Y.BR.CODE) OR Y.BR.CODE EQ '' OR (Y.DT.OPD EQ 'EQ' AND FIELD(SEL.LIST<II>,'.',2) EQ Y.DT) OR (Y.DT.OPD EQ 'RG' AND FIELD(SEL.LIST<II>,'.',2) GE Y.DT1 AND FIELD(SEL.LIST<II>,'.',2) LE Y.DT2)) THEN
            IF FIELD(SEL.LIST<II>,'.',2) EQ Y.TODAY THEN
                EB.DataAccess.FRead(FN.TT, FIELD(SEL.LIST<II>,'.',3), R.TT, F.TT, ERR.CODE)
            END
            IF FIELD(SEL.LIST<II>,'.',2) LT Y.TODAY THEN
                EB.DataAccess.FRead(FN.TTH, FIELD(SEL.LIST<II>,'.',3):';1', R.TT1, F.TTH, ERR.CODE)
                EB.DataAccess.FRead(FN.TTH, FIELD(SEL.LIST<II>,'.',3):';2', R.TT2, F.TTH, ERR.CODE)
                
                IF R.TT2 EQ '' THEN R.TT = R.TT1 ELSE R.TT = R.TT2
            END
        
            Y.TE.OVERRIDE = R.TT<TT.Contract.Teller.TeOverride>
        
            IF COUNT(Y.TE.OVERRIDE,'Teller Limit Over for Curreny: ') GT 0 THEN
                Y.ID = FIELD(SEL.LIST<II>,'.',3)
                
                EB.DataAccess.FRead(FN.TL, SEL.LIST<II>, R.TL, F.TL, ERR.TL)
                Y.LIMIT = R.TL<EB.TT.57.TT.ID>
*                Y.DR.CR = R.TT<TT.TE.DR.CR.MARKER>
                Y.DR.CR = R.TT<TT.Contract.Teller.TeDrCrMarker>
*                Y.AC1 = R.TT<TT.TE.ACCOUNT.1>
                Y.AC1 = R.TT<TT.Contract.Teller.TeAccountOne>
*                Y.AC2 = R.TT<TT.TE.ACCOUNT.2>
                Y.AC2 = R.TT<TT.Contract.Teller.TeAccountTwo>
*                Y.CCY1 = R.TT<TT.TE.CURRENCY.1>
                Y.CCY1 = R.TT<TT.Contract.Teller.TeCurrencyOne>
*                Y.CCY2 = R.TT<TT.TE.CURRENCY.2>
                Y.CCY2 = R.TT<TT.Contract.Teller.TeCurrencyTwo>
*                Y.LAMT1 = R.TT<TT.TE.AMOUNT.LOCAL.1>
                Y.LAMT1 = R.TT<TT.Contract.Teller.TeAmountLocalOne>
*                Y.LAMT2 = R.TT<TT.TE.AMOUNT.LOCAL.2>
                Y.LAMT2 = R.TT<TT.Contract.Teller.TeAmountLocalTwo>
*                Y.FAMT1 = R.TT<TT.TE.AMOUNT.FCY.1>
                Y.FAMT1 = R.TT<TT.Contract.Teller.TeAmountFcyOne>
*                Y.FAMT2 = R.TT<TT.TE.AMOUNT.FCY.2>
                Y.FAMT2 = R.TT<TT.Contract.Teller.TeAmountFcyTwo>
*                Y.RATE1 = R.TT<TT.TE.RATE.1>
                Y.RATE1 = R.TT<TT.Contract.Teller.TeRateOne>
*                Y.RATE2 = R.TT<TT.TE.RATE.2>
                Y.RATE2 = R.TT<TT.Contract.Teller.TeRateTwo>

                IF Y.DR.CR = 'DEBIT' THEN Y.CCY = Y.CCY2 ELSE Y.CCY = Y.CCY1
                IF Y.DR.CR = 'DEBIT' THEN Y.AC = Y.AC2 ELSE Y.AC = Y.AC1
                IF Y.DR.CR = 'DEBIT' THEN Y.LAMT = Y.LAMT2 ELSE Y.LAMT = Y.LAMT1
                IF Y.DR.CR = 'DEBIT' THEN Y.FAMT = Y.FAMT2 ELSE Y.FAMT = Y.FAMT1
                IF Y.DR.CR = 'DEBIT' THEN Y.RATE = Y.RATE2 ELSE Y.RATE = Y.RATE1
                IF Y.CCY EQ 'BDT' THEN Y.AMT = Y.LAMT ELSE Y.AMT = Y.FAMT
                
                
                Y.DATE.TIME = R.TT<TT.Contract.Teller.TeDateTime>
                Y.TIME = Y.DATE.TIME[7,2]:':':Y.DATE.TIME[9,2]
*                Y.TRC = R.TT<TT.TE.TRANSACTION.CODE>
                Y.TRC = R.TT<TT.Contract.Teller.TeTransactionCode>
*                Y.CK = R.TT<TT.TE.CHEQUE.NUMBER>
                Y.CK = R.TT<TT.Contract.Teller.TeChequeNumber>
*                Y.NAMT = R.TT<TT.TE.NET.AMOUNT>
                Y.NAMT = R.TT<TT.Contract.Teller.TeNetAmount>
*                Y.STS = R.TT<TT.TE.RECORD.STATUS>
                Y.STS = R.TT<TT.Contract.Teller.TeRecordStatus>
*                Y.INP = FIELD(R.TT<TT.TE.INPUTTER>,'_',2)
                Y.INP = FIELD(R.TT<TT.Contract.Teller.TeInputter>,'_',2)
*                Y.AUTH = FIELD(R.TT<TT.TE.AUTHORISER>,'_',2)
                Y.AUTH = FIELD(R.TT<TT.Contract.Teller.TeAuthoriser>,'_',2)

                Y.RETURN<-1> = Y.ID:'*':Y.TRC:'*':Y.CK:'*':Y.CCY:'*':Y.AC:'*':Y.AMT:'*':Y.RATE:'*':Y.NAMT:'*':Y.STS:'*':Y.INP:'*':Y.AUTH:'*':Y.TIME:'*':'BD001':FIELD(SEL.LIST<II>,'.',1):'*':Y.LIMIT:'*':FIELD(SEL.LIST<II>,'.',2)
*                            1         2         3        4         5        6          7          8         9         10         11        12                      13                       14                 15
            END
        END
    NEXT II
RETURN
END
