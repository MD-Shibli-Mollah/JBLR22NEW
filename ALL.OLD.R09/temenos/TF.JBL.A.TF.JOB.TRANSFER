SUBROUTINE TF.JBL.A.TF.JOB.TRANSFER

*-----------------------------------------------------------------------------
* VERSION : LETTER.OF.CREDIT,JBL.BTB.AMD.JOB
* create by: Mahmudur Rahman Udoy
* Description : Transfer LC records from one job register record to another.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.BTB.JOB.REGISTER
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING ST.CurrencyConfig
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.Interface
    $USING ST.CompanyCreation
    
    
    IF EB.SystemTables.getVFunction() EQ 'A' THEN
        GOSUB INIT
        GOSUB OPENFILES
        GOSUB PROCESS
    END

RETURN

*****
INIT:
*****
    FN.BTB.JOB = 'F.BD.BTB.JOB.REGISTER';   F.BTB.JOB = ''
    FN.CCY = 'F.CURRENCY';                  F.CCY = ''
    
    Y.IM.CHANGE.POS = 1
    Y.IMP.LC.CCY.AMT = ''
    Y.NULL = ''
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.CCY,F.CCY)
    EB.DataAccess.Opf(FN.BTB.JOB,F.BTB.JOB)

    APP.NAME = 'LETTER.OF.CREDIT'
    LOCAL.FIELDS = 'LT.TF.JOB.NUMBR'
    EB.Foundation.MapLocalFields(APP.NAME, LOCAL.FIELDS, FLD.POS)
    Y.TF.JOB.NUMBER.POS = FLD.POS<1,1>
    
RETURN

********
PROCESS:
********
    Y.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.LC.LOC.REF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TF.JOB.NEW.NUMBER =  Y.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    Y.OLD.LC.LOC.REF= EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TF.EXIST.JOB.NUMBER =  Y.OLD.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    Y.LC.NUM = EB.SystemTables.getIdNew()
*****************************OLD JOB RECORD AMENDMENT************************
    Y.IMP.LC.AMT = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.OLD.LC.AMT.CCY = Y.IMP.LC.AMT
    IF Y.CCY NE 'USD' THEN
        GOSUB LCAMT.CAL.JOB.CCY
        Y.OLD.LC.AMT.CCY = Y.IMP.LC.CCY.AMT
    END
    
    EB.DataAccess.FRead(FN.BTB.JOB,Y.TF.EXIST.JOB.NUMBER,R.EXIST.JOB.REC,F.BTB.JOB,JR.ERR)
    IF R.EXIST.JOB.REC THEN
        Y.IMP.TF.REF = R.EXIST.JOB.REC<BTB.JOB.IM.TF.REF>
        Y.IMP.TF.COUNT = DCOUNT(Y.IMP.TF.REF, @VM)

        FOR I = 1 TO Y.IMP.TF.COUNT
            Y.IMP.ID = Y.IMP.TF.REF<1,I>
            IF Y.IMP.ID EQ Y.LC.NUM THEN
                Y.IM.CHANGE.POS = I
                BREAK
            END
        NEXT I
        Y.IMP.ISSUE.DATE = R.EXIST.JOB.REC<BTB.JOB.IM.ISSUE.DATE, Y.IM.CHANGE.POS>
        Y.IMP.BB.LC.NO = R.EXIST.JOB.REC<BTB.JOB.IM.BB.LC.NO, Y.IM.CHANGE.POS>
        Y.IMP.LC.CURR = R.EXIST.JOB.REC<BTB.JOB.IM.LC.CURRENCY, Y.IM.CHANGE.POS>
        Y.EXIST.JOB.TOT.BTB.AVL.AMT = R.EXIST.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT>
        Y.EXIST.JOB.TOT.BTB.AMT = R.EXIST.JOB.REC<BTB.JOB.TOT.BTB.AMT>
        Y.EXIST.JOB.NEW.TOT.BTB.AVL.AMT = Y.EXIST.JOB.TOT.BTB.AVL.AMT + Y.OLD.LC.AMT.CCY
        Y.EXIST.JOB.NEW.TOT.BTB.AMT = Y.EXIST.JOB.TOT.BTB.AMT - Y.OLD.LC.AMT.CCY
     
        R.EXIST.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT> = Y.EXIST.JOB.NEW.TOT.BTB.AVL.AMT
        R.EXIST.JOB.REC<BTB.JOB.TOT.BTB.AMT> = Y.EXIST.JOB.NEW.TOT.BTB.AMT
        R.EXIST.JOB.REC<BTB.JOB.IM.TF.REF, Y.IM.CHANGE.POS> = Y.NULL
        R.EXIST.JOB.REC<BTB.JOB.IM.ISSUE.DATE, Y.IM.CHANGE.POS> = Y.NULL
        R.EXIST.JOB.REC<BTB.JOB.IM.BB.LC.NO, Y.IM.CHANGE.POS> = Y.NULL
        R.EXIST.JOB.REC<BTB.JOB.IM.LC.CURRENCY, Y.IM.CHANGE.POS> = Y.NULL
        R.EXIST.JOB.REC<BTB.JOB.IM.LC.AMOUNT, Y.IM.CHANGE.POS> = Y.NULL
        R.EXIST.JOB.REC<BTB.JOB.IM.EXPIRY.DATE, Y.IM.CHANGE.POS> = Y.NULL
        EB.DataAccess.FWrite(FN.BTB.JOB,Y.TF.EXIST.JOB.NUMBER,R.EXIST.JOB.REC)
    END
    
*****************************NEW JOB RECORD AMENDMENT************************
    Y.IMP.LC.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.IMP.EXPIRY.DATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcAdviceExpiryDate)
    Y.NEW.LC.AMT.CCY = Y.IMP.LC.AMT
    IF Y.CCY NE 'USD' THEN
        GOSUB LCAMT.CAL.JOB.CCY
        Y.NEW.LC.AMT.CCY = Y.IMP.LC.CCY.AMT
    END
    EB.DataAccess.FRead(FN.BTB.JOB,Y.TF.JOB.NEW.NUMBER,R.NEW.JOB.REC,F.BTB.JOB,JR.ERR)
    IF R.NEW.JOB.REC THEN
        Y.NEW.JOB.IMP.TF.REF = R.NEW.JOB.REC<BTB.JOB.IM.TF.REF>
        Y.NEW.JOB.IMP.TF.COUNT = DCOUNT(Y.NEW.JOB.IMP.TF.REF, @VM)
        Y.NEW.JOB.IMP.TF.POS = Y.NEW.JOB.IMP.TF.COUNT + 1

        Y.NEW.JOB.TOT.BTB.AVL.AMT = R.NEW.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT>
        Y.NEW.JOB.TOT.BTB.AMT = R.NEW.JOB.REC<BTB.JOB.TOT.BTB.AMT>
        Y.NEW.JOB.NEW.TOT.BTB.AVL.AMT = Y.NEW.JOB.TOT.BTB.AVL.AMT - Y.NEW.LC.AMT.CCY
        Y.NEW.JOB.NEW.TOT.BTB.AMT = Y.NEW.JOB.TOT.BTB.AMT + Y.NEW.LC.AMT.CCY
        R.NEW.JOB.REC<BTB.JOB.TOT.BTB.AVL.AMT> = Y.NEW.JOB.NEW.TOT.BTB.AVL.AMT
        R.NEW.JOB.REC<BTB.JOB.TOT.BTB.AMT> = Y.NEW.JOB.NEW.TOT.BTB.AMT
    
        R.NEW.JOB.REC<BTB.JOB.IM.TF.REF, Y.NEW.JOB.IMP.TF.POS> = Y.LC.NUM
        R.NEW.JOB.REC<BTB.JOB.IM.ISSUE.DATE, Y.NEW.JOB.IMP.TF.POS> = Y.IMP.ISSUE.DATE
        R.NEW.JOB.REC<BTB.JOB.IM.BB.LC.NO, Y.NEW.JOB.IMP.TF.POS> = Y.IMP.BB.LC.NO
        R.NEW.JOB.REC<BTB.JOB.IM.LC.CURRENCY, Y.NEW.JOB.IMP.TF.POS> = Y.IMP.LC.CURR
        R.NEW.JOB.REC<BTB.JOB.IM.LC.AMOUNT, Y.NEW.JOB.IMP.TF.POS> = Y.IMP.LC.AMT
        R.NEW.JOB.REC<BTB.JOB.IM.EXPIRY.DATE,Y.NEW.JOB.IMP.TF.POS> = Y.IMP.EXPIRY.DATE
    
        EB.DataAccess.FWrite(FN.BTB.JOB,Y.TF.JOB.NEW.NUMBER,R.NEW.JOB.REC)
    END
RETURN
 
LCAMT.CAL.JOB.CCY:
*if LC CCY is 'BDT'
    IF Y.CCY EQ 'BDT' THEN
        Y.CCY = 'USD'
        GOSUB GET.SELL.RATE
        Y.IMP.LC.CCY.AMT = Y.IMP.LC.AMT / Y.SELL.RATE
    END
*if LC CCY not 'BDT' and 'USD'
    IF Y.CCY NE 'BDT' AND Y.CCY NE 'USD' THEN
        GOSUB GET.SELL.RATE
        Y.LC.CCY.SELL.RATE = Y.SELL.RATE
        Y.CCY = 'USD'
        GOSUB GET.SELL.RATE
        Y.USD.CCY.SELL.RATE = Y.SELL.RATE
        Y.IMP.LC.CCY.AMT = (Y.LC.CCY.SELL.RATE / Y.USD.CCY.SELL.RATE) * Y.IMP.LC.AMT
    END
RETURN

GET.SELL.RATE:
    EB.DataAccess.FRead(FN.CCY,Y.CCY,R.CCY,F.CCY,CCY.ERR)
    IF R.CCY THEN
        Y.CCY.MKT = '3'
        Y.SELL.RATE = ''
        FIND Y.CCY.MKT IN R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
            Y.SELL.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurSellRate, Y.CCY.MKT.POS2>
        END
    END
RETURN
END