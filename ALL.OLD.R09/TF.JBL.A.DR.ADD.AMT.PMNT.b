SUBROUTINE TF.JBL.A.DR.ADD.AMT.PMNT
*-----------------------------------------------------------------------------
*Subroutine Description: Add charge amount in payment of import acceptance payment
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPMAT)
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 09/12/2019 -                            CREATE   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Updates
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.Foundation
    
**-----------------------------------------------------------------------------
*    IF EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType) NE "MA" OR EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType) NE "MD" OR EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawingType) NE "SP" THEN RETURN
**-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    FN.DRAWINGS = "F.DRAWINGS"
    F.DRAWINGS = ""
    Y.FT.OFS.VERSION = 'FUNDS.TRANSFER,BD.BTB.SETTLE'
    
    Y.APPL = "DRAWINGS":FM:"FUNDS.TRANSFER"
    Y.FIELDS = "LT.DR.CHG.ACCT":VM:"LT.ADD.CHG.AMT":FM:"LT.FT.DR.REFNO"
    EB.Updates.MultiGetLocRef( Y.APPL,Y.FIELDS,Y.POS)
    LT.DR.CHG.ACCT.POS = Y.POS<1,1>
    LT.ADD.CHG.AMT.POS = Y.POS<1,2>
    LT.FT.DR.REFNO.POS = Y.POS<2,1>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.DRAWINGS, F.DRAWINGS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
*    TO GET DOCUMENT AMOUNT
    YR.DOC.AMT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDocumentAmount)

    
* to get total profit amount in FC
    Y.DR.LF = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.DR.CHG.ACCT = Y.DR.LF<1, LT.DR.CHG.ACCT.POS>
    Y.ADD.CHG.AMT = Y.DR.LF<1,LT.ADD.CHG.AMT.POS>
* to get Dcument Currency, Drawing Type & Document Aceptance Date
    Y.CCY = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawCurrency)
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
    YR.ACCT.DR = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawdownAccount)
    YR.AMT.DR = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrReimburseAmount)
    EB.DataAccess.FRead(FN.ACCOUNT, YR.ACCT.DR, R.DR.ACCOUNT, F.ACCOUNT, Y.ERROR)
    IF R.DR.ACCOUNT THEN
        YR.DR.CCY = R.DR.ACCOUNT<AC.AccountOpening.Account.Currency>
        YR.DR.CCY.MKT = R.DR.ACCOUNT<AC.AccountOpening.Account.CurrencyMarket>
    END
    

*------------CUSTOMER A/C TO NOSTRO A/C-----------------
    R.REC<FT.Contract.FundsTransfer.TransactionType> = 'AC'
    R.REC<FT.Contract.FundsTransfer.CreditAcctNo> = YR.ACCT.CR
    R.REC<FT.Contract.FundsTransfer.CurrencyMktCr> = YR.CR.CCY.MKT
    R.REC<FT.Contract.FundsTransfer.CreditCurrency> = YR.CR.CCY
    R.REC<FT.Contract.FundsTransfer.TreasuryRate> = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrTreasuryRate)
    R.REC<FT.Contract.FundsTransfer.DebitAcctNo> = YR.ACCT.DR     ;*Customer account
    R.REC<FT.Contract.FundsTransfer.DebitCurrency> = YR.DR.CCY
    R.REC<FT.Contract.FundsTransfer.CurrencyMktDr> = YR.DR.CCY.MKT
    R.REC<FT.Contract.FundsTransfer.LocalRef,LT.FT.DR.REFNO.POS> = EB.SystemTables.getIdNew()
    R.REC<FT.Contract.FundsTransfer.OrderingBank> = 'JBL'

    IF Y.DR.CHG.ACCT NE "" THEN
        R.REC<FT.Contract.FundsTransfer.DebitAmount> = Y.ADD.CHG.AMT
        GOSUB OFS.PROCESS
    END ELSE
        R.REC<FT.Contract.FundsTransfer.DebitAmount> = YR.AMT.DR
        GOSUB OFS.PROCESS
    END
RETURN
*** </region>


************
OFS.PROCESS:
************
*    EB.Foundation.OfsBuildRecord(AppName, Ofsfunct, Process, Ofsversion, Gtsmode, NoOfAuth, TransactionId, Record, Ofsrecord)
    EB.Foundation.OfsBuildRecord('FUNDS.TRANSFER','I','PROCESS',Y.FT.OFS.VERSION,'',0,TRANSACTION.ID,R.REC,Y.OFS.RECORD)
    CALL ofs.addLocalRequest(Y.OFS.RECORD,'APPEND',Y.ERR.OFS)
    
RETURN


END








