SUBROUTINE TF.JBL.A.DR.ADD.AMT.PMENT
*-----------------------------------------------------------------------------
*Subroutine Description: Add Payment OFS FT for Drawings of acceptance of Import LC
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPMAT)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 09/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $USING AC.AccountOpening
    $USING LC.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING FT.Contract

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
*****
INIT:
*****
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    Y.FT.OFS.VERSION = 'FUNDS.TRANSFER,BD.BTB.SETTLE'
    
    YR.NET.AMT = ''
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
RETURN

********
PROCESS:
********
* to get Document Amout
    YR.DOC.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)
    EB.Foundation.MapLocalFields('DRAWINGS', 'LT.ADD.CHG.AMT', LT.TF.PRF.AMT.POS)
    EB.Foundation.MapLocalFields('DRAWINGS', 'LT.DR.CHG.ACCT', LT.DR.CHG.ACCT.POS)
    EB.Foundation.MapLocalFields('FUNDS.TRANSFER', 'LT.FT.DR.REFNO', LT.FT.DR.REFNO.POS)
    

* to get total profit amount in FC
    Y.DR.LF = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    YR.NET.AMT = Y.DR.LF<1, LT.TF.PRF.AMT.POS>
    
    Y.CCY = SUBSTRINGS(YR.NET.AMT,1,3)
    YR.NET.AMT = SUBSTRINGS(YR.NET.AMT,4,LEN(YR.NET.AMT)-3)
    
    
    
* to get Dcument Currency, Drawing Type & Document Aceptance Date
*   Y.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
    Y.DR.TYPE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType)
    Y.VALUE.DATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrValueDate)
    
*-------------FOR CREDIT(PAYMENT A/C)----------
    YR.ACCT.CR = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrPaymentAccount)
    EB.DataAccess.FRead(FN.ACCOUNT, YR.ACCT.CR, R.CR.ACCOUNT, F.ACCOUNT, Y.ERROR)
    IF R.CR.ACCOUNT THEN
        YR.CR.CCY = R.CR.ACCOUNT<AC.AccountOpening.Account.Currency>
        YR.CR.CCY.MKT = R.CR.ACCOUNT<AC.AccountOpening.Account.CurrencyMarket>
    END
 
*-------------FOR DEBIT(DRAW DOWN A/C)----------
    YR.ACCT.DR = Y.DR.LF<1, LT.DR.CHG.ACCT.POS>
    
    EB.DataAccess.FRead(FN.ACCOUNT, YR.ACCT.DR, R.DR.ACCOUNT, F.ACCOUNT, Y.ERROR)
    IF R.DR.ACCOUNT THEN
        YR.DR.CCY = R.DR.ACCOUNT<AC.AccountOpening.Account.Currency>
        YR.DR.CCY.MKT = R.DR.ACCOUNT<AC.AccountOpening.Account.CurrencyMarket>
    END
    

    IF Y.CCY NE LCCY THEN
        YR.CR.RATE = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDebitCustRate)
    END ELSE
        YR.CR.RATE = ''
    END


    IF YR.NET.AMT THEN
        R.REC<FT.Contract.FundsTransfer.TransactionType> = 'AC'
        R.REC<FT.Contract.FundsTransfer.CreditAcctNo> = YR.ACCT.CR
        R.REC<FT.Contract.FundsTransfer.CurrencyMktCr> = YR.CR.CCY.MKT
        R.REC<FT.Contract.FundsTransfer.CreditAmount> = YR.NET.AMT
        R.REC<FT.Contract.FundsTransfer.CreditCurrency> = YR.CR.CCY
        R.REC<FT.Contract.FundsTransfer.TreasuryRate> = YR.CR.RATE
        R.REC<FT.Contract.FundsTransfer.DebitAcctNo> = YR.ACCT.DR     ;*Customer account
        R.REC<FT.Contract.FundsTransfer.DebitCurrency> = YR.DR.CCY
        R.REC<FT.Contract.FundsTransfer.LocalRef,LT.FT.DR.REFNO.POS> = EB.SystemTables.getIdNew()
        R.REC<FT.Contract.FundsTransfer.OrderingBank> = 'JBL'

        GOSUB OFS.PROCESS
    END
RETURN

************
OFS.PROCESS:
************
    EB.Foundation.OfsBuildRecord('FUNDS.TRANSFER','I','PROCESS',Y.FT.OFS.VERSION,'',0,TRANSACTION.ID,R.REC,Y.OFS.RECORD)
    CALL ofs.addLocalRequest(Y.OFS.RECORD,'APPEND',Y.ERR.OFS)
RETURN

END