SUBROUTINE TF.JBL.E.FDBP.IDBP.REG(Y.DATA)

* Description: this routine calculate the Loan Outstanding, interest, Charge amounts &
*              fetch Other Arrangement data for a specific customer with selected product group.
* Create by: Mahmudur Rahman Udoy
* Attach Enq: JBL.ENQ.FDBP.IDBP.REG
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    
    $USING AA.Framework
    $USING AC.AccountOpening
    $USING AA.Account
    $USING AA.Interest
    $USING AA.TermAmount
    $USING ST.CompanyCreation
    $USING ST.Customer
    
    $USING RE.ConBalanceUpdates
*    $USING ST.AccountStatement
		$USING AC.AccountStatement
    $USING AC.EntryCreation
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Reports
    $USING EB.Updates
    
*    ST.CompanyCreation.LoadCompany('BNK')

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

INIT:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
      
    FN.ECB = 'F.EB.CONTRACT.BALANCES'
    F.ECB  = ''

    FN.STMT.ENT = 'F.STMT.ENTRY'
    F.STMT.ENT  = ''
    
    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    
    FLD.POS = ''
    APPLICATION.NAMES = 'AA.ARR.ACCOUNT'
    LOCAL.FIELDS = 'LT.LEGACY.ID':VM:'LT.TF.EXP.LC.NO':VM:'LT.TF.JOB.NUMBR':VM:'LT.AC.LINK.TFNO':VM:'LT.LN.BIL.DOCVL':VM:'LT.LN.PUR.PCT':VM:'LT.LN.PUR.FCAMT':VM:'LT.TF.EXCH.RATE'
*                           1                   2                 3                    4                    5                   6                     7                      8
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    BANK.REF.NO.POS   =  FLD.POS<1,1>
    EXPORT.LC.NO.POS =   FLD.POS<1,2>
    JOB.NUMBER.POS   =   FLD.POS<1,3>
    DRAWING.TF.NO.POS =  FLD.POS<1,4>
    EXPORT.DOC.VAL.POS = FLD.POS<1,5>
    PURCHASE.POS       = FLD.POS<1,6>
    PURCHASE.IN.FC.POS = FLD.POS<1,7>
    EXCHANGE.RATE.POS  = FLD.POS<1,8>

    
    LOCATE 'FROM.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.DATE.POS THEN
        Y.FROM.DATE=EB.Reports.getEnqSelection()<4,FROM.DATE.POS>
    END
    LOCATE 'TO.DATE' IN EB.Reports.getEnqSelection()<2,1> SETTING TO.DATE.POS THEN
        Y.TO.DATE=EB.Reports.getEnqSelection()<4,TO.DATE.POS>
    END
    LOCATE 'CUSTOMER' IN EB.Reports.getEnqSelection()<2,1> SETTING CUSTOMER.POS THEN
        Y.CUS.ID=EB.Reports.getEnqSelection()<4,CUSTOMER.POS>
    END
    LOCATE 'PRODUCT.GROUP' IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.GROUP.POS THEN
        Y.PRD.GRP.ID=EB.Reports.getEnqSelection()<4,PRODUCT.GROUP.POS>
    END
    LOCATE 'PRODUCT' IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.POS THEN
        Y.PRD.ID=EB.Reports.getEnqSelection()<4,PRODUCT.POS>
    END
    
    Y.COMP = EB.SystemTables.getIdCompany()
    Y.TODATE = EB.SystemTables.getToday()
    
*    Y.COMP = 'BD0010133'
*    Y.FROM.DATE = '20200101'
*    Y.TO.DATE = '20210306'
*    Y.PRD.GRP.ID = 'JBL.IDBP.LN'
    
RETURN

OPENFILES:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    EB.DataAccess.Opf(FN.CUS,F.CUS)
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    EB.DataAccess.Opf(FN.ECB,F.ECB)
    EB.DataAccess.Opf(FN.STMT.ENT,F.STMT.ENT)
RETURN

PROCESS:
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID NE '' AND Y.CUS.ID NE '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ LENDING AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND ACTIVE.PRODUCT EQ ":Y.PRD.ID:" AND CUSTOMER EQ ":Y.CUS.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID EQ '' AND Y.CUS.ID NE '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ LENDING AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND CUSTOMER EQ ":Y.CUS.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID NE '' AND Y.CUS.ID EQ '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ LENDING AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND ACTIVE.PRODUCT EQ ":Y.PRD.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID EQ '' AND Y.CUS.ID EQ '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ LENDING AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND CO.CODE EQ ":Y.COMP
    END
    
    EB.DataAccess.Readlist(SEL.CMD.ARR, SEL.LIST, "",NO.OF.RECORD,RET.CODE)
    FOR I=1 TO NO.OF.RECORD
        Y.TOTAL.ADJUST.AMT = ''
        Y.REG.AMT = ''
        Y.OD.AMT = ''
        Y.REG.INT.AMT = ''
        Y.OD.INT.AMT = ''
        Y.PAN.INT.AMT = ''
        Y.DUE.CRG.AMT = ''
        Y.DUE.ED.CRG.AMT = ''
        Y.ARR.ID = SEL.LIST<I>
*        PRINT  'ARR:- ':Y.ARR.ID
        EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ARR.ID, ARR.REC, F.AA.ARRANGEMENT, ERR.ARR)
        IF ARR.REC THEN
            Y.ACCT.ID = ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>       ;* LOAN ID
*        PRINT Y.ACCT.ID
            Y.LOAN.START.DATE = ARR.REC<AA.Framework.Arrangement.ArrStartDate>  ;* LOAN START DATE
            Y.CUST = ARR.REC<AA.Framework.Arrangement.ArrCustomer>   ;* CUSTOMER ID
            CONVERT VM TO FM IN Y.CUST
        END
        EB.DataAccess.FRead(FN.CUS, Y.CUST, R.AR, F.CUS, CUS.ERR)
        IF R.AR THEN
            Y.CUS.TITTL=R.AR<ST.Customer.Customer.EbCusNameOne>   ;* CUSTOMER NAME
        END
        !############################## READ FORM INTEREST PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'PRINCIPALINT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        IF REC.INT.DATA THEN
            Y.PRIN.INT = REC.INT.DATA<AA.Interest.Interest.IntFixedRate>
        END
    
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'INTONOD'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        IF REC.INT.DATA THEN
            Y.OD.INT = REC.INT.DATA<AA.Interest.Interest.IntFixedRate>
        END
    
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'PENALTYINT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        IF REC.INT.DATA THEN
            Y.PNINT.INT = REC.INT.DATA<AA.Interest.Interest.IntFixedRate> ;* Interest rate
        END
        !##############################READ FORM INTEREST PROPERTY CLASS PROPERTIES END#############################

        !############################## READ FORM TERM.AMOUNT PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.TERM = 'TERM.AMOUNT'
        PROPERTY = 'COMMITMENT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.TERM,PROPERTY,'',RETURN.IDS.TERM,RETURN.VALUES.TERM,ERR.MSG.TERM)
        REC.TERM.DATA = RAISE(RETURN.VALUES.TERM)
        IF REC.TERM.DATA THEN
            Y.COMMIT.AMT = REC.TERM.DATA<AA.TermAmount.TermAmount.AmtAmount>  ;* LOAN AMOUNT
            Y.MATUR.DATE = REC.TERM.DATA<AA.TermAmount.TermAmount.AmtMaturityDate> ;* MATRUTY DATE
        END
        !##############################READ FORM INTEREST PROPERTY CLASS PROPERTIES END#############################

        !############################## READ FORM ACCOUNT PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.ACCT = 'ACCOUNT'
        PROPERTY =  'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.ACCT,PROPERTY,'',RETURN.IDS.ACCT,RETURN.VALUES.ACCT,ERR.MSG.ACCT)
        REC.ACC.DATA = RAISE(RETURN.VALUES.ACCT)
        IF REC.ACC.DATA THEN
            Y.BANK.REF.NO    = REC.ACC.DATA<AA.Account.Account.AcLocalRef,BANK.REF.NO.POS>
            Y.EXPORT.LC.NO   = REC.ACC.DATA<AA.Account.Account.AcLocalRef,EXPORT.LC.NO.POS>
            Y.JOB.NUMBER     = REC.ACC.DATA<AA.Account.Account.AcLocalRef,JOB.NUMBER.POS>
            Y.DRAWING.TF.NO  = REC.ACC.DATA<AA.Account.Account.AcLocalRef,DRAWING.TF.NO.POS>
            Y.EXPORT.DOC.VAL = REC.ACC.DATA<AA.Account.Account.AcLocalRef,EXPORT.DOC.VAL.POS>
            Y.PURCHASE       = REC.ACC.DATA<AA.Account.Account.AcLocalRef,PURCHASE.POS>
            Y.PURCHASE.IN.FC = REC.ACC.DATA<AA.Account.Account.AcLocalRef,PURCHASE.IN.FC.POS>
            Y.EXCHANGE.RATE  = REC.ACC.DATA<AA.Account.Account.AcLocalRef,EXCHANGE.RATE.POS>
        END
        !##############################READ FORM ACCOUNT PROPERTY CLASS PROPERTIES END#############################
        
        !##############################ALL CLACULATED BALANCE()#############################
        RequestType<2> = 'ALL' ;* Unauthorised Movements required.
        RequestType<3> = 'ALL' ;* Projected Movements requierd
        RequestType<4> = 'ECB' ;* Balance file to be used
        RequestType<4,2> = 'END'
        ST.DATE = Y.TODATE
        EN.DATE = Y.TODATE
        SYS.DATE = Y.TODATE
        Y.BAL.TYPE = 'CURACCOUNT':FM:'DUEACCOUNT':FM:'GRCACCOUNT':FM:'STDACCOUNT':FM:'ACCPRINCIPALINT':FM:'ACCINTONOD':FM:'ACCPENALTYINT':FM:'DUELCADVISE':FM:'DUELCCOLLCOM':FM:'DUELCPOSTAGE':FM:'DUELCSTAXDMEXP':FM:'DUEEXCISEDUTYFEE'
        Y.BAL.TYPE.COUNT = DCOUNT(Y.BAL.TYPE, @FM)
        FOR U = 1 TO Y.BAL.TYPE.COUNT
            Y.BAL.AMT.TOTAL = ''
            Y.INT.BAL.AMT.TOTAL = ''
            BASEBALANCE = Y.BAL.TYPE<U>
            IF BASEBALANCE EQ 'CURACCOUNT' OR BASEBALANCE EQ 'DUEACCOUNT' OR BASEBALANCE EQ 'GRCACCOUNT' OR BASEBALANCE EQ 'STDACCOUNT' THEN
                AA.Framework.GetPeriodBalances(Y.ACCT.ID, BASEBALANCE, RequestType, ST.DATE, EN.DATE, SYS.DATE, BalDetails, ErrorMessage)
            END
            ELSE
                ST.DATE = Y.LOAN.START.DATE ;*We change the variable because for Interset & charge we need day amount status from the loan stating.
                AA.Framework.GetPeriodBalances(Y.ACCT.ID, BASEBALANCE, RequestType, ST.DATE, EN.DATE, SYS.DATE, BalDetails, ErrorMessage)
            END
            IF BalDetails NE '' THEN
                Y.BAL.AMT = BalDetails<4>
                Y.BAL.AMT.TOTAL = ABS(SUM(Y.BAL.AMT))
                IF BASEBALANCE EQ 'CURACCOUNT' THEN
                    Y.REG.AMT = Y.BAL.AMT.TOTAL    ;* REGULAR BAL AMOUNT
                    Y.CR.BAL.AMT =  BalDetails<2>
                    Y.TOTAL.ADJUST.AMT = ABS(SUM(Y.CR.BAL.AMT)) ;* ADJUEST AMOUNT
                    Y.BAL.DATE = BalDetails<1>
                    Y.BAL.DATE.COUNT = DCOUNT(Y.BAL.DATE, @VM)
                    Y.BAL.DATE.LAST = Y.BAL.DATE<1,Y.BAL.DATE.COUNT> ;* LAST ADJUESTED DATE
                END
                IF BASEBALANCE EQ 'DUEACCOUNT' OR BASEBALANCE EQ 'GRCACCOUNT' OR BASEBALANCE EQ 'STDACCOUNT' THEN
                    Y.OD.AMT = Y.BAL.AMT.TOTAL   ;* OD BAL AMOUNT
                END
            
                ! GET ALL INTEREST AMOUNT SEPERATLY
                Y.INT.BAL.AMT = BalDetails<3>
                Y.INT.BAL.AMT.TOTAL = ABS(SUM(Y.INT.BAL.AMT))
                IF BASEBALANCE EQ 'ACCPRINCIPALINT' THEN
                    Y.REG.INT.AMT = Y.INT.BAL.AMT.TOTAL ;* REGULAR INT AMOUNT
                END
                IF BASEBALANCE EQ 'ACCINTONOD' THEN
                    Y.OD.INT.AMT = Y.INT.BAL.AMT.TOTAL ;* OD INT AMOUNT
                END
                IF BASEBALANCE EQ 'ACCPENALTYINT' THEN
                    Y.PAN.INT.AMT = Y.INT.BAL.AMT.TOTAL ;* OD INT AMOUNT
                END
            
                ! GET ALL CHARGE AMOUNT SEPERATLY
                Y.CRG.BAL.AMT = BalDetails<2>
                Y.CRG.BAL.AMT.TOTAL = ABS(SUM(Y.CRG.BAL.AMT))
                IF BASEBALANCE EQ 'DUELCADVISE' OR BASEBALANCE EQ 'DUELCCOLLCOM' OR BASEBALANCE EQ 'DUELCPOSTAGE' OR BASEBALANCE EQ 'DUELCSTAXDMEXP' OR BASEBALANCE EQ 'DUEEXCISEDUTYFEE' THEN
                    Y.DUE.CRG.AMT += Y.CRG.BAL.AMT.TOTAL ;* CHARGE AMT
                END
  
            END
        NEXT U
        Y.OUTSTANDING.AMT = Y.REG.AMT + Y.OD.AMT   ;* OUTSTANDING AMOUNT
        Y.TOTAL.INT = Y.REG.INT.AMT + Y.OD.INT.AMT + Y.PAN.INT.AMT ;* TOTAL INT AMOUNT
    
        !##############################ALL CLACULATED BALANCE END#############################
        Y.DATA<-1> = Y.ACCT.ID :'*': Y.LOAN.START.DATE :'*': Y.BANK.REF.NO :'*': Y.CUST:'*':Y.CUS.TITTL:'*': Y.EXPORT.LC.NO :'*': Y.JOB.NUMBER :'*': Y.DRAWING.TF.NO :'*': Y.EXPORT.DOC.VAL :'*': Y.PURCHASE :'*': Y.PURCHASE.IN.FC :'*': Y.EXCHANGE.RATE :'*': Y.COMMIT.AMT:'*': Y.PRIN.INT:'*':Y.TOTAL.ADJUST.AMT:'*': Y.BAL.DATE.LAST :'*': Y.REG.AMT :'*': Y.OD.AMT:'*': Y.OUTSTANDING.AMT:'*': Y.OD.INT:'*': Y.PNINT.INT:'*': Y.REG.INT.AMT:'*': Y.OD.INT.AMT:'*': Y.PAN.INT.AMT:'*':Y.TOTAL.INT:'*': Y.DUE.CRG.AMT:'*': Y.MATUR.DATE
        !                1                   2                    3                 4           5                   6                   7                    8                   9                   10                  11                     12                  13                14                 15                     16                 17             18                 19                20             21                  22                23               24                25                26                 27

*       PRINT Y.DATA
    NEXT I
   
RETURN

END