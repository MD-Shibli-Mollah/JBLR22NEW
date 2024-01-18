SUBROUTINE CR.E.LOAN.SETTLEMENT.REP(Y.DATA)
*PROGRAM CR.E.LOAN.SETTLEMENT.REP
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
 
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    
    $USING EB.Reports
    $USING EB.DatInterface
        
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING ST.CompanyCreation
    
     
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING RE.ConBalanceUpdates
    $USING AA.Account
    $USING AA.Interest
    *$USING AA.ProductManagement
    $USING AF.ClassFramework
      
         
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
    
RETURN

*****
INIT:
*****
 
    FN.COM = 'F.COMPANY'
    F.COM = ''
    
    FN.ARR = 'FBNK.AA.ARRANGEMENT'
    F.ARR = ''
    
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    
    FN.ECB='F.EB.CONTRACT.BALANCES'
    FP.ECB=''
    
    FN.ACRU = 'F.AA.INTEREST.ACCRUALS'
    F.ACRU = ''
    
    FN.PROD = 'F.AA.PRODUCT'
    F.PROD=''
    
    FN.ATA = 'F.ALTERNATE.ACCOUNT'
    F.ATA=''
     
    LOCATE "LOAN.ID" IN EB.Reports.getEnqSelection()<2,1> SETTING LOAN.ID.POS THEN
        Y.LOAN.ID = EB.Reports.getEnqSelection()<4,LOAN.ID.POS>
    END
     
RETURN

**********
OPENFILES:
**********
    ST.CompanyCreation.LoadCompany('BNK')

    EB.DataAccess.Opf(FN.COM,F.COM)
    EB.DataAccess.Opf(FN.ARR,F.ARR)
    EB.DataAccess.Opf(FN.ACRU,F.ACRU)
* EB.DataAccess.Opf(FN.ECB,FP.ECB)
    
RETURN

********
PROCESS:
********
     
*    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
*
*       AC.AccountOpening
*    Y.LOAN.ID ='1727000001121'
*Y.LOAN.ID ='AA21274RX6ST'
*    Y.LOAN.ID ='LD1907073687'
*Y.LOAN.ID ='AA2109106SMC'
*DEBUG
    IF Y.LOAN.ID[1,2] EQ 'LD' THEN
        Y.ID.FLG =1
    END
    IF Y.LOAN.ID[1,4] EQ 'PDPD' THEN
        Y.ID.FLG =1
    END
    IF Y.ID.FLG EQ 1 THEN
        EB.DataAccess.FRead(FN.ATA,Y.LOAN.ID,ATA.REC,F.ATA,ATA.ERR)
        Y.LOAN.ID=ATA.REC<AC.AccountOpening.AlternateAccount.AacGlobusAcctNumber>
    END
    
    IF Y.LOAN.ID[1,1] EQ '1' THEN
        EB.DataAccess.FRead(FN.ACC,Y.LOAN.ID,ACC.REC,F.ACC,ACC.ERR)
        Y.ARR.ID=ACC.REC<AC.AccountOpening.Account.ArrangementId>
    END
    ELSE
        Y.ARR.ID= Y.LOAN.ID
    END

    EB.DataAccess.FRead(FN.ARR,Y.ARR.ID,ARR.REC,F.ARR,ARR.ERR)
    Y.ARR.CUST= ARR.REC<AA.Framework.Arrangement.ArrCustomer>
    Y.PRODUCT.LINE=ARR.REC<AA.Framework.Arrangement.ArrProductLine>
    Y.PRODUCT=ARR.REC<AA.Framework.Arrangement.ArrProduct>
    Y.PRODUCT.AC=ARR.REC<AA.Framework.Arrangement.ArrLinkedAppl>
    Y.ACC.ID = ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>
    Y.ST.DATE =ARR.REC<AA.Framework.Arrangement.ArrStartDate>
    Y.ARR.STATUS= ARR.REC<AA.Framework.Arrangement.ArrArrStatus>
    Y.CO.CODE = ARR.REC<AA.Framework.Arrangement.ArrCoCode>
    
    EB.DataAccess.FRead(FN.PROD,Y.PRODUCT,PROD.REC,F.PROD,PROD.ERR)
    *Y.PROD.NAME=PROD.REC<AA.ProductManagement.DefinitionManager.Description>
    Y.PROD.NAME=PROD.REC<AF.ClassFramework.DefinitionManager.Description>
          
    PROP.CLASS = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, Idproperty, Effectivedate, Returnids, R.ACCOUNT.DATA, Returner)
    REC.ACCOUNT = RAISE(R.ACCOUNT.DATA)
    Y.AC.TITLE = REC.ACCOUNT<AA.Account.Account.AcShortTitle>

    PROP.CLASS = 'INTEREST'
    Idproperty = 'PRINCIPALINT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, Idproperty, Effectivedate, Returnids, R.ACCOUNT.DATA, Returner)
    REC.ACCOUNT = RAISE(R.ACCOUNT.DATA)
    Y.INT.RATE= REC.ACCOUNT<AA.Interest.Interest.IntFixedRate>
    Y.ACCRUAL.RULE= REC.ACCOUNT<AA.Interest.Interest.IntAccrualRule>
        
    Idproperty = 'INTONOD'
    AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, Idproperty, Effectivedate, Returnids, R.ACCOUNT.DATA, Returner)
    REC.ACCOUNT = RAISE(R.ACCOUNT.DATA)
    Y.OD.RATE= REC.ACCOUNT<AA.Interest.Interest.IntFixedRate>
    Y.ACCRUAL.RULE2= REC.ACCOUNT<AA.Interest.Interest.IntAccrualRule>
    
    Idproperty = 'PENALTYINT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID, PROP.CLASS, Idproperty, Effectivedate, Returnids, R.ACCOUNT.DATA, Returner)
    REC.ACCOUNT = RAISE(R.ACCOUNT.DATA)
    Y.PNL.RATE= REC.ACCOUNT<AA.Interest.Interest.IntFixedRate>
    Y.ACCRUAL.RULE3= REC.ACCOUNT<AA.Interest.Interest.IntAccrualRule>
    
    Y.ACRU.ID=Y.ARR.ID:'-':'PRINCIPALINT'
    EB.DataAccess.FRead(FN.ACRU,Y.ACRU.ID,ACRU.REC,F.ACRU,ACRU.ERR)
    Y.LST.INT.DT1=ACRU.REC<AA.Interest.InterestAccruals.IntAccToDate,1>
    Y.PRD.STDT1=ACRU.REC<AA.Interest.InterestAccruals.IntAccPeriodStart>
    IF Y.LST.INT.DT1 EQ '' THEN
        Y.LST.INT.DT1=Y.PRD.STDT1
        IF Y.LST.INT.DT1 NE '' THEN
            CALL CDT('C',Y.LST.INT.DT1,-1)
        END
    END
    Y.ACRU.ID=Y.ARR.ID:'-':'INTONOD'
    EB.DataAccess.FRead(FN.ACRU,Y.ACRU.ID,ACRU.REC,F.ACRU,ACRU.ERR)
    Y.LST.INT.DT2=ACRU.REC<AA.Interest.InterestAccruals.IntAccToDate,1>
    Y.PRD.STDT2=ACRU.REC<AA.Interest.InterestAccruals.IntAccPeriodStart>
    IF Y.LST.INT.DT2 EQ '' THEN
        Y.LST.INT.DT2=Y.PRD.STDT2
        IF Y.LST.INT.DT2 NE '' THEN
            CALL CDT('C',Y.LST.INT.DT2,-1)
        END
    END
    
    Y.ACRU.ID=Y.ARR.ID:'-':'PENALTYINT'
    EB.DataAccess.FRead(FN.ACRU,Y.ACRU.ID,ACRU.REC,F.ACRU,ACRU.ERR)
    Y.LST.INT.DT3=ACRU.REC<AA.Interest.InterestAccruals.IntAccToDate,1>
    Y.PRD.STDT3=ACRU.REC<AA.Interest.InterestAccruals.IntAccPeriodStart>
    IF Y.LST.INT.DT3 EQ '' THEN
        Y.LST.INT.DT3=Y.PRD.STDT3
        IF Y.LST.INT.DT3 NE '' THEN
            CALL CDT('C',Y.LST.INT.DT3,-1)
        END
    END
    
    GOSUB ECB.BALANCE
     
    Y.PRIN.INTT1 = 0
    Y.BILL.INTT1 = 0
    Y.BILL.INTT2 = 0
    
    Y.PRIN.INTT11 = 0
    Y.BILL.INTT11 = 0
    Y.BILL.INTT22 = 0

    Y.NO.DAYS = 'C'
    IF Y.LST.INT.DT1 NE '' THEN
        CALL CDD('C',Y.LST.INT.DT1,ReqdDate,Y.INT.DAYS)
        IF Y.ACCRUAL.RULE EQ 'FIRST' THEN
            Y.INT.DAYS = Y.INT.DAYS -1
        END
    END
    IF Y.LST.INT.DT2 NE '' THEN
        CALL CDD('C',Y.LST.INT.DT2,ReqdDate,Y.OD.DAYS)
        IF Y.ACCRUAL.RULE2 EQ 'FIRST' THEN
            Y.OD.DAYS = Y.OD.DAYS -1
        END
    END
    IF Y.LST.INT.DT3 NE '' THEN
        CALL CDD('C',Y.LST.INT.DT3,ReqdDate,Y.PNL.DAYS)
        IF Y.ACCRUAL.RULE3 EQ 'FIRST' THEN
            Y.PNL.DAYS = Y.PNL.DAYS -1
        END
    END

    IF Y.INT.DAYS GE 1 THEN
        Y.PRIN.INTT11 = (Y.PRIN.BAL * Y.INT.RATE * Y.INT.DAYS)
    END
    IF Y.PRIN.INTT11 LT 0 THEN
        Y.PRIN.INTT1 = Y.PRIN.INTT11 / 36000
    END
    Y.PRIN.INTT=Y.PRIN.INTT+Y.PRIN.INTT1
    
    IF Y.OD.DAYS GE 1 THEN
        Y.BILL.INTT11 = (Y.BILL.BAL * Y.OD.RATE * Y.OD.DAYS)
    END
    IF Y.PNL.DAYS GE 1 THEN
        Y.BILL.INTT22 = (Y.BILL.BAL * Y.PNL.RATE * Y.PNL.DAYS)
    END
    
    IF Y.BILL.INTT11 LT 0 THEN
        Y.BILL.INTT1 =Y.BILL.INTT11/36000
    END
    IF Y.BILL.INTT22 LT 0 THEN
        Y.BILL.INTT2 =Y.BILL.INTT22/36000
    END
      
    Y.BILL.INTT=Y.BILL.INTT+ Y.BILL.INTT1+Y.BILL.INTT2
*    DEBUG
    Y.DATA<-1> = Y.ARR.ID:'|':Y.CO.CODE:'|':Y.ACC.ID:'|':Y.AC.TITLE:'|':Y.ST.DATE:'|':Y.PRIN.BAL:'|':Y.PRIN.INTT:'|':Y.BILL.BAL.CHG:'|':Y.BILL.INTT:'|':Y.CHARGES:'|':Y.ARR.STATUS:'|':Y.PROD.NAME
RETURN

ECB.BALANCE:

    Y.CURACCOUNT = 0
    Y.DUEACCOUNT = 0
    Y.STDACCOUNT = 0
    Y.DUEINTONOD = 0
    Y.DUEPENALTYINT = 0
    Y.ACCPRINCIPALINT =0
    Y.ACCINTONOD = 0
    Y.ACCPENALTYINT = 0
    Y.DUEAMCFEE = 0
    Y.DUEEXCISEDUTYFEE = 0
    Y.STDEXCISEDUTYFEE = 0
    Y.STDAMCFEE = 0
        
    ReqdDate=EB.SystemTables.getToday()
    accountId= Y.ACC.ID
*ReqdDate=20211006
        
    BaseBalance = 'CURACCOUNT'
    RequestType<2> = 'ALL'
    RequestType<3> = 'ALL'
    RequestType<4> = 'ECB'
    RequestType<4,2> = 'END'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.CURACCOUNT = BalDetails<4>
        
*PRINT 'BalDetails<1> ':BalDetails<1>   DATE
*PRINT 'BalDetails<2> ':BalDetails<2>   CREDIT MOVEMENT
*PRINT 'BalDetails<3> ':BalDetails<3>   DEBIT MOVEMENT
*PRINT 'BalDetails<4> ':BalDetails<4>   CLOSING BALANCE MOVEMENT
    !BalanceFulMonth = BalDetails<4>
*    DEBUG
    BaseBalance = 'DUEACCOUNT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEACCOUNT = BalDetails<4>
        
    BaseBalance = 'STDACCOUNT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.STDACCOUNT = BalDetails<4>
        
    BaseBalance = 'DUEINTONOD'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEINTONOD = BalDetails<4>
        
    BaseBalance = 'DUEPENALTYINT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEPENALTYINT = BalDetails<4>
        
    BaseBalance = 'ACCPRINCIPALINT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.ACCPRINCIPALINT = BalDetails<4>
           
    BaseBalance = 'ACCINTONOD'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.ACCINTONOD = BalDetails<4>
           
    BaseBalance = 'ACCPENALTYINT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.ACCPENALTYINT = BalDetails<4>
            
    BaseBalance = 'DUEAMCFEE'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEAMCFEE = BalDetails<4>
        
    BaseBalance = 'DUEEXCISEDUTYFEE'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEEXCISEDUTYFEE = BalDetails<4>
        
    BaseBalance = 'STDEXCISEDUTYFEE'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.STDEXCISEDUTYFEE = BalDetails<4>
        
    BaseBalance = 'STDAMCFEE'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.STDAMCFEE = BalDetails<4>
    
    BaseBalance = 'DUEVAT'
    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, ReqdDate, EndDate, SystemDate, BalDetails, ErrorMessage)
    Y.DUEVAT = BalDetails<4>
        
    Y.PRIN.BAL = Y.CURACCOUNT+Y.DUEACCOUNT
    Y.BILL.BAL = Y.STDACCOUNT+Y.DUEINTONOD+Y.DUEPENALTYINT
    Y.PRIN.INTT = Y.ACCPRINCIPALINT
    Y.BILL.INTT = Y.ACCINTONOD+Y.ACCPENALTYINT
    Y.CHARGES = Y.DUEAMCFEE+Y.DUEEXCISEDUTYFEE+Y.STDEXCISEDUTYFEE+Y.STDAMCFEE+Y.DUEVAT
    Y.BILL.BAL.CHG =Y.BILL.BAL + Y.CHARGES
       
RETURN
END
