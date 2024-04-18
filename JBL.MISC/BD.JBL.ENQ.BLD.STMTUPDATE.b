* @ValidationCode : MjoyMzU1NDkwNDpDcDEyNTI6MTcxMTUzMjI0OTE0MzpUYWp1bDotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 27 Mar 2024 15:37:29
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Tajul
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
* Test Acc: JED FBNK.EB.BD.STATEMENT.COUNT 0101000007294-2022

SUBROUTINE BD.JBL.ENQ.BLD.STMTUPDATE(ENQ.DATA)
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*Developer Info:
*    Date         : 27/03/2024
*    Description  : This is a build routine that will check wather the customer exceeds the max number of statment or not if  so then it will deduct a charge.
*    Developed By : Md. Tajul Islam
*    Designation  : T24 Developer
*    Email        : tajul@nazihargroup.com
*
* </doc>
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.EB.BD.LOCAL.PARAMETER
    $INSERT I_F.EB.BD.STATEMENT.COUNT
    
    $USING EB.Reports
    $USING EB.DataAccess
*   $USING FT.Contract
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING AC.AccountOpening
    $USING FT.AdhocChargeRequests
    $USING EB.Interface
    $USING FT.Contract
*-----------------------------------------------------------------------------
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
INIT:
    FN.LOCAL.PARAM = "F.EB.BD.LOCAL.PARAMETER"
    F.LOCAL.PARAM = ''
    FN.STMT.COUNT = 'F.EB.BD.STATEMENT.COUNT'
    F.STMT.COUNT = ''
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    
    Y.TODAY = EB.SystemTables.getToday()
    
    Y.VERSION = 'AC.CHARGE.REQUEST,STATEMENTCHARGE'
* Y.ACC.NUMBER='0101000005992'
   
* Y.ACC.NUMBER = ENQ.DATA<4,1>
    Y.ACC.NUMBER = EB.Reports.getEnqSelection()<4,1>
*Y.ACC.NUMBER='0101000005992'
    Y.STMT.ID = Y.ACC.NUMBER:"-":Y.TODAY[1,4]
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.LOCAL.PARAM, F.LOCAL.PARAM)
    EB.DataAccess.Opf(FN.STMT.COUNT, F.STMT.COUNT)
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)

    EB.DataAccess.FRead(FN.LOCAL.PARAM, "SYSTEM", R.PARAM, F.LOCAL.PARAM, Err)
*    EB.DataAccess.FRead(FN.LOCAL.PARAM, "SYSTEM", R.PARAM, F.LOCAL.PARAM, Err)
RETURN

PROCESS:
    DEBUG
    EB.DataAccess.FRead(FN.STMT.COUNT, Y.STMT.ID, STMT.COUNT.REC, F.STMT.COUNT, Er)
*    IF STMT.COUNT.REC EQ "" THEN
*        STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT> ='1'
*        STMT.COUNT.REC<EB.BD.24.CO.CODE> =EB.SystemTables.getIdCompany()
*        STMT.COUNT.REC<EB.BD.24.INPUTTER>=OPERATOR
*        STMT.COUNT.REC<EB.BD.24.AUTHORISER>=OPERATOR
*        WRITE STMT.COUNT.REC ON F.STMT.COUNT, Y.STMT.ID
*        RETURN
*    END
   
    Y.ALLOWED.PER.YEAR=R.PARAM<EB.BD.87.GB.MAX.STATEMENTCOUNT>
    Y.ALREADY.TAKEN=STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT>
    IF Y.ALREADY.TAKEN LT Y.ALLOWED.PER.YEAR THEN
        GOSUB UPDATE.STMT.COUNT
       
        RETURN
    END
    EB.DataAccess.FRead(FN.ACCOUNT, Y.ACC.NUMBER, R.ACC, F.ACCOUNT, Er)
    Y.WORKING.BALANCE=R.ACC<AC.AccountOpening.Account.WorkingBalance>
    Y.CHARGE.AMOUNT = R.PARAM<EB.BD.87.GB.STATEMENT.CHARGE>
    IF Y.WORKING.BALANCE LT Y.CHARGE.AMOUNT THEN
        EB.SystemTables.setE('INSUFFICIENT FUNDS')
        RETURN
    END
* Y.ALREADY.TAKEN=Y.ALREADY.TAKEN+1

* GOSUB OFS.STRING
    GOSUB OFS.STRING1
   
       
* OFS.SOURCE = 'BUILD.CONTROL'
    OFS.SOURCE = 'STATEMENT'
    theResponse = ""
    txnCommitted = ""
    
*    CALL OFS.CALL.BULK.MANAGER(OFS.SOURCE, YOfsRecord, theResponse, txnCommitted)

* CALL OFS.GLOBUS.MANAGER(OFS.SOURCE,YOfsRecord)
    KOfsSource1 = OFS.SOURCE
    Ofsrecord = YOfsRecord
    EB.Interface.OfsGlobusManager(KOfsSource1, Ofsrecord)
   
    Y.RESPONSE = FIELD(FIELD(theResponse,'/',3),',',1)
    IF Y.RESPONSE NE '1' THEN
* GOSUB WRITE.STMT.COUNT
        EB.SystemTables.setE('INSUFFICIENT BALANCE')
        RETURN
    END
    GOSUB UPDATE.STMT.COUNT
*Y.ALREADY.TAKEN=STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT> + 1
    SENSITIVITY = ''
**CHECK OFS IS SUCCESSFUL OR NOT
** IF SUCCESFULL THEN write
*    Y.ALREADY.TAKEN = Y.ALREADY.TAKEN+1
*    STMT.COUNT.REC<EB.BD.24.CO.CODE> =EB.SystemTables.getIdCompany()
*    STMT.COUNT.REC<EB.BD.24.INPUTTER>=OPERATOR
*    STMT.COUNT.REC<EB.BD.24.AUTHORISER>=OPERATOR
*    STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT>=Y.ALREADY.TAKEN
RETURN
OFS.STRING:
*   OFS.DATA<FT.Contract.FundsTransfer.TransactionType>='AC'
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgDebitAccount>=Y.ACC.NUMBER
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgChargeAmount>='12'
*  OFS.DATA<FT.AdhocChargeRequests.C>='BDT'
*OFS.DATA<FT.Contract.FundsTransfer.DebitTheirRef>="STATEMENT CHARGE"
*OFS.DATA<<FT.Contract.FundsTransfer.DebitValueDate>=Y.TODAY
*    OFS.DATA<FT.Contract.FundsTransfer.CreditAcctNo>=''
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgRequestType>='BOOK'
*Add ChgChargeCode on parameter table
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgChargeCode>="CORRBKCHG"
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgExtraDetails,1>="STATEMENT CHARGE"
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgChargeCcy>="BDT"
    OFS.DATA<FT.AdhocChargeRequests.AcChargeRequest.ChgStatus>='PAID'
*   OFS.DATA<FT.Contract.FundsTransfer.CreditValueDate>=Y.TODAY
*    OFS.DATA<FT.Contract.FundsTransfer.OrderingBank>='JBL'
    EB.Foundation.OfsBuildRecord('AC.CHARGE.REQUEST','I','PROCESS',Y.VERSION,'',0,'',OFS.DATA,YOfsRecord)
*  EB.Foundation.OfsBuildRecord(AppName, Ofsfunct, Process, Ofsversion, Gtsmode, NoOfAuth, TransactionId, Record, Ofsrecord)
  
RETURN

OFS.STRING1:
    
    KOfsSource1 = "CARD.OFS"
            
    OfsMessage<FT.Contract.FundsTransfer.TransactionType> = "AC"
    OfsMessage<FT.Contract.FundsTransfer.DebitAcctNo> = "0101000007294"
    OfsMessage<FT.Contract.FundsTransfer.DebitCurrency> = "BDT"
    OfsMessage<FT.Contract.FundsTransfer.DebitAmount> = "13"
    OfsMessage<FT.Contract.FundsTransfer.DebitValueDate> = Y.TODAY
    OfsMessage<FT.Contract.FundsTransfer.CreditAcctNo> = "0101000005992"
            
*---------------- OFS for S/D A/C: Fees for ATM Card Vendor --------*
    Ofsrecord = ""
    EB.Foundation.OfsBuildRecord("FUNDS.TRANSFER", "I", "PROCESS", "FUNDS.TRANSFER,JBL.ATM.OFS.AC", "", 1, "", OfsMessage, Ofsrecord)
    EB.Interface.OfsGlobusManager(KOfsSource1, Ofsrecord)
    T24TxnRef = FIELD(Ofsrecord, '/', 1)
RETURN

UPDATE.STMT.COUNT:
    Y.OPERATOR = EB.SystemTables.getOperator()
    Y.ALREADY.TAKEN=STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT> + 1
    STMT.COUNT.REC<EB.BD.24.STATEMENT.COUNT>=Y.ALREADY.TAKEN
    STMT.COUNT.REC<EB.BD.24.CO.CODE>=EB.SystemTables.getIdCompany()
    STMT.COUNT.REC<EB.BD.24.INPUTTER>=Y.OPERATOR
    STMT.COUNT.REC<EB.BD.24.AUTHORISER>=Y.OPERATOR
    WRITE STMT.COUNT.REC ON F.STMT.COUNT, Y.STMT.ID
RETURN

END
