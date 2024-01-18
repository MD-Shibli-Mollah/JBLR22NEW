SUBROUTINE TF.JBL.I.ARV
*-----------------------------------------------------------------------------
*Subroutine Description: Advance receipt voucher's validation and TPPAY/TPREC set
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.F.EXPDOCREAL)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/01/2020 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.ARV
    $INSERT I_F.BD.LC.AD.CODE
*
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING ST.Customer
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.DRAWINGS = 'F.DRAWINGS'
    F.DRAWINGS = ''
    FN.JBL.ARV = 'F.JBL.ARV'
    F.JBL.ARV = ''
    FN.CCY = 'F.CURRENCY'
    F.CCY = ''

    Y.TOTAL.ARV.AMOUNT = '0'
    Y.DOC.CCY.RATE = '1'

    
    APPLICATION.NAMES = 'DRAWINGS'
    LOCAL.FIELDS = 'LT.ARV.NO':VM:"LT.BUYER.NAME":VM:"LT.ARV.AMT"
    EB.Foundation.MapLocalFields(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.ARV.NO.POS = FLD.POS<1,1>
    Y.LT.BUYER.NAME.POS = FLD.POS<1,2>
    Y.LT.ARV.AMT.POS = FLD.POS<1,3>

RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.DRAWINGS, F.DRAWINGS)
    EB.DataAccess.Opf(FN.JBL.ARV, F.JBL.ARV)
    EB.DataAccess.Opf(FN.CCY,F.CCY)
RETURN
********
PROCESS:
********
********* Doc CCY rate for market*************
    Y.DOC.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
    IF Y.DOC.CCY.RATE NE 'BDT' THEN
        EB.DataAccess.FRead(FN.CCY, Y.DOC.CCY, R.CCY, F.CCY, E.CCY)
        Y.CCY.MRK = R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
        Y.CCY.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
        Y.CCY.MRK.COUNT = DCOUNT(Y.CCY.MRK, @VM)
        FOR J=1 TO Y.CCY.MRK.COUNT
            IF Y.CCY.MRK<1,J> EQ '1' THEN
                Y.DOC.CCY.RATE = Y.CCY.RATE<1,J>
                BREAK
            END
        NEXT J
    END
*********************************
    Y.ARV.NO = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1, Y.LT.ARV.NO.POS>
    Y.COUNT.ARV.NO = DCOUNT(Y.ARV.NO, @SM)
    Y.ALL.LT.DATA = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)

    FOR I=1 TO Y.COUNT.ARV.NO
        Y.ARV.NO.TEMP = Y.ARV.NO<1,1,I>
        EB.DataAccess.FRead(FN.JBL.ARV, Y.ARV.NO.TEMP, R.JBL.ARV, F.JBL.ARV, JBL.ARV.ERR)
        IF R.JBL.ARV THEN
            Y.BUYER.NAME = R.JBL.ARV<ARV.BUYER.NAME>
            Y.ARV.AMT = R.JBL.ARV<ARV.RECEIVED.AMOUT>
            Y.ARV.CCY = R.JBL.ARV<ARV.RECEIVED.CCY>
*****************************************CHANGE IN 22 MAR 2021
            Y.ARV.DR.ID = R.JBL.ARV<ARV.DRAWINGS.ID>
            IF Y.ARV.DR.ID NE '' THEN
                EB.SystemTables.setEtext(Y.ARV.NO.TEMP:' ARV already realized by ':Y.ARV.DR.ID)
                EB.ErrorProcessing.StoreEndError()
            END
*****************************************END CHANGE  IN 22 MAR 2021
                
            Y.ARV.CCY.RATE = '1'
            Y.EX.CCY.RATE = ''
            
********* ARV CCY rate for market*************
            IF Y.ARV.CCY NE 'BDT' THEN
                EB.DataAccess.FRead(FN.CCY, Y.DOC.CCY, R.CCY, F.CCY, E.CCY)
                Y.CCY.MRK = R.CCY<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
                Y.CCY.RATE = R.CCY<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
                Y.CCY.MRK.COUNT = DCOUNT(Y.CCY.MRK, @VM)
                FOR J=1 TO Y.CCY.MRK.COUNT
                    IF Y.CCY.MRK<1,J> EQ '1' THEN
                        Y.ARV.CCY.RATE = Y.CCY.RATE<1,J>
                        BREAK
                    END
                NEXT J
            END
*********************************
            Y.EX.CCY.RATE = Y.ARV.CCY.RATE / Y.DOC.CCY.RATE
            Y.ARV.AMT.FOR.DOC = Y.ARV.AMT * Y.EX.CCY.RATE
            Y.TOTAL.ARV.AMOUNT += Y.ARV.AMT.FOR.DOC
            
            Y.ALL.LT.DATA<1, Y.LT.BUYER.NAME.POS,I> = Y.BUYER.NAME
            Y.ALL.LT.DATA<1, Y.LT.ARV.AMT.POS,I> = Y.ARV.AMT.FOR.DOC
        END
    NEXT I

    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.ALL.LT.DATA)
    Y.DOC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    Y.CREDIT.AMOUNT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrBenDrawAmt)
*****************************************CHANGE IN 22 MAR 2021
    Y.APP.DRAW.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAppDrawAmt)
    IF Y.DOC.AMOUNT EQ Y.CREDIT.AMOUNT AND Y.DOC.AMOUNT EQ Y.APP.DRAW.AMT THEN
        Y.NEW.DEBIT.CREDIT.AMOUNT = Y.DOC.AMOUNT - Y.TOTAL.ARV.AMOUNT
        IF Y.NEW.DEBIT.CREDIT.AMOUNT GE 0 THEN
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrBenDrawAmt, Y.NEW.DEBIT.CREDIT.AMOUNT)
            EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAppDrawAmt, Y.NEW.DEBIT.CREDIT.AMOUNT)
        END
    END
    Y.TfDrAssignmentRef = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssignmentRef)
    Y.TfDrAssnCrAcct = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssnCrAcct)
    Y.TfDrAssnAmount = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrAssnAmount)
    Y.DR.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
    
************************20210913************start*********************
    Y.TfTotAssnAmount = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrTotAssnAmt)
    IF Y.TfTotAssnAmount EQ '0' THEN RETURN
************************20210913************end*********************
    
    Y.ASIGNMENT.REF = 'TPRECV':VM:'TPPAY'
***************************20210921***************START************************
    Y.ASSN.CR.ACCT = Y.DR.CCY:'13504':VM:Y.DR.CCY:'13504'
***************************20210921***************END************************
    Y.ASSN.AMT = Y.TOTAL.ARV.AMOUNT:VM:Y.TOTAL.ARV.AMOUNT
    IF Y.TfDrAssignmentRef EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssignmentRef, Y.ASIGNMENT.REF)
    END
    IF Y.TfDrAssnCrAcct EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssnCrAcct, Y.ASSN.CR.ACCT)
    END
    IF Y.TfDrAssnAmount EQ '' THEN
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrAssnAmount, Y.ASSN.AMT)
    END
*****************************************END CHANGE IN 22 MAR 2021
    
    Y.AMT = Y.TOTAL.ARV.AMOUNT+ EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrBenDrawAmt)
    IF Y.AMT GT Y.DOC.AMOUNT THEN
        EB.SystemTables.setEtext('ARV amount and Credit amount more than Document amount')
        EB.ErrorProcessing.StoreEndError()
    END

          
RETURN

END


