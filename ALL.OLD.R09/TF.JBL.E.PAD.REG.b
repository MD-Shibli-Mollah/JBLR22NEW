SUBROUTINE TF.JBL.E.PAD.REG(Y.DATA)
    !PROGRAM TF.JBL.E.PAD.REG
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $USING AA.Framework
    $USING RE.ConBalanceUpdates
    $USING ST.AccountStatement
    $USING AC.EntryCreation
    $USING AC.AccountOpening
    $USING AA.Account
    $USING AA.Interest
    $USING AA.TermAmount
    $USING LC.Contract
    
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Reports
    $USING ST.CompanyCreation
    $USING ST.Customer
    $USING EB.Updates

 
*  ST.CompanyCreation.LoadCompany('BNK')

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

    FN.LETTER.OF.CREDIT = "F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT = ""
    Y.LC.ERR = ''

    FN.DRAWINGS = 'F.DRAWINGS'
    F.DRAWINGS = ''
    Y.DR.ERR = ''
    
    
    FN.DRAWINGS.HIS = 'F.DRAWINGS$HIS'
    F.DRAWINGS.HIS = ''
 
 
 
 
    FLD.POS = ''
    APPLICATION.NAMES = 'AA.ARR.ACCOUNT'
    LOCAL.FIELDS = 'LT.LEGACY.ID':VM:'LT.AC.LINK.TFNO':VM:'LT.LN.PUR.PCT':VM:'LT.LN.PUR.FCAMT':VM:'LT.TF.EXCH.RATE':VM:'LT.AC.BD.EXLCNO':VM:'LT.AC.LINK.TFNO':VM:'LT.ACCT.LN.AMT':VM:'LT.AC.BD.LNMADT'
*                           1                   2                 3                    4                    5                   6                     7                      8                9                  10
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    BANK.REF.NO.POS   =  FLD.POS<1,1>
    EXPORT.DOC.VAL.POS = FLD.POS<1,2>
    PURCHASE.POS       = FLD.POS<1,3>
    PURCHASE.IN.FC.POS = FLD.POS<1,4>
    EXCHANGE.RATE.POS  = FLD.POS<1,5>
    BB.LC.NO.POS       = FLD.POS<1,6>
    TF.NUMBER.POS      = FLD.POS<1,7>
    LC.AMT.F.POS       = FLD.POS<1,8>
    LN.MATURITY.DT.POS    = FLD.POS<1,9>
    
    
    LOCATE "FROM.DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING FROM.DATE.POS THEN
        Y.FROM.DATE=EB.Reports.getEnqSelection()<4,FROM.DATE.POS>
    END
    LOCATE "TO.DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING TO.DATE.POS THEN
        Y.TO.DATE=EB.Reports.getEnqSelection()<4,TO.DATE.POS>
    END
    LOCATE "CUSTOMER" IN EB.Reports.getEnqSelection()<2,1> SETTING CUSTOMER.POS THEN
        Y.CUS.ID=EB.Reports.getEnqSelection()<4,CUSTOMER.POS>
    END
    LOCATE "PRODUCT.GROUP" IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.GROUP.POS THEN
        Y.PRD.GRP.ID=EB.Reports.getEnqSelection()<4,PRODUCT.GROUP.POS>
    END
    LOCATE "PRODUCT" IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.POS THEN
        Y.PRD.ID=EB.Reports.getEnqSelection()<4,PRODUCT.POS>
    END

* Y.CUS.ID =''
* Y.PRD.ID=''
  
    Y.COMP = EB.SystemTables.getIdCompany()
    Y.TODATE = EB.SystemTables.getToday()
    
* Y.COMP = 'BD0010133'
*  Y.FROM.DATE = '20200101'
*  Y.TO.DATE = '20211206'
*Y.PRD.GRP.ID = 'JBL.PAD.CASH.LN'
  
RETURN
  
 
OPENFILES:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    EB.DataAccess.Opf(FN.CUS,F.CUS)
    EB.DataAccess.Opf(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
    EB.DataAccess.Opf(FN.ECB,F.ECB)
    EB.DataAccess.Opf(FN.STMT.ENT,F.STMT.ENT)
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.DRAWINGS,F.DRAWINGS)
RETURN

PROCESS:
    
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID NE '' AND Y.CUS.ID NE '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ ACCOUNTS AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND ACTIVE.PRODUCT EQ ":Y.PRD.ID:" AND CUSTOMER EQ ":Y.CUS.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID EQ '' AND Y.CUS.ID NE '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ ACCOUNTS AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND CUSTOMER EQ ":Y.CUS.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID NE '' AND Y.CUS.ID EQ '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ ACCOUNTS AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND ACTIVE.PRODUCT EQ ":Y.PRD.ID:" AND CO.CODE EQ ":Y.COMP
    END
    IF Y.PRD.GRP.ID NE '' AND  Y.PRD.ID EQ '' AND Y.CUS.ID EQ '' THEN
        SEL.CMD.ARR = "SELECT ":FN.AA.ARRANGEMENT:" WITH PRODUCT.LINE EQ ACCOUNTS AND PRODUCT.GROUP EQ ":Y.PRD.GRP.ID:" AND CO.CODE EQ ":Y.COMP
    END
    
  
    EB.DataAccess.Readlist(SEL.CMD.ARR, SEL.LIST, "",NO.OF.RECORD,RET.CODE)
    FOR I=1 TO NO.OF.RECORD
        Y.TOTAL.ADJUST.AMT = ''
        Y.REG.AMT = ''
        Y.OD.AMT = ''
        Y.REG.INT.AMT = ''
        Y.OD.INT.AMT = ''
        Y.ARR.ID = SEL.LIST<I>
*        PRINT  'ARR:- ':Y.ARR.ID
        EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ARR.ID, ARR.REC, F.AA.ARRANGEMENT, ERR.ARR)
        Y.ACCT.ID = ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>       ;* LOAN ID
*       PRINT  'AC:- ': Y.ACCT.ID
        Y.AA.NO =  Y.ARR.ID ;* ARRANGEMENT ID
*  PRINT 'ARR:- ': Y.AA.NO
        Y.LOAN.START.DATE = ARR.REC<AA.Framework.Arrangement.ArrStartDate>  ;* LOAN START DATE
*   PRINT 'LN ST DT :- ': Y.LOAN.START.DATE
        Y.CUST = ARR.REC<AA.Framework.Arrangement.ArrCustomer>   ;* CUSTOMER ID
*  PRINT 'CUS ID:- ':  Y.CUST
        CONVERT VM TO FM IN Y.CUST
        EB.DataAccess.FRead(FN.CUS, Y.CUST, R.AR, F.CUS, CUS.ERR)
        Y.CUS.TITTL=R.AR<ST.Customer.Customer.EbCusNameOne>   ;* CUSTOMER NAME
*   PRINT 'CUS ID:- ':  Y.CUS.TITTL
              
        !  Y.ARR.ID = 'AA21202N15WD'
        !   DEBUG
        !############################## READ FORM ACCOUNT PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.ACCT = 'ACCOUNT'
        PROPERTY =  'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.ACCT,PROPERTY,'',RETURN.IDS.ACCT,RETURN.VALUES.ACCT,ERR.MSG.ACCT)
        REC.ACC.DATA = RAISE(RETURN.VALUES.ACCT)
        Y.BANK.REF.NO    = REC.ACC.DATA<AA.Account.Account.AcLocalRef,BANK.REF.NO.POS>
        !   Y.IMP.LC.NO   = REC.ACC.DATA<AA.Account.Account.AcLocalRef,EXPORT.LC.NO.POS>
        Y.IMP.LC.NO      = REC.ACC.DATA<AA.Account.Account.AcLocalRef,BB.LC.NO.POS>
        Y.TF.NO          = REC.ACC.DATA<AA.Account.Account.AcLocalRef,TF.NUMBER.POS>
        
        !############### Read from LC ############
        
        FLD.POS = ''
        APPLICATION.NAMES = 'DRAWINGS'
        LOCAL.FIELDS = 'LT.TF.EXPR.NAME':VM:'LT.TF.IMPR.NAME':VM:'LT.TF.COMMO.NM':VM:'LT.TF.MAT.DATE':VM:'LT.TF.DT.PAYMNT':VM:'LT.TF.BNK.REFNO'
*                   1                       2                   3                   4                   5
        EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
        EXPOR.NAME.POS   =  FLD.POS<1,1>
        IMPR.NAME.POS    =  FLD.POS<1,2>
        COMMOD.NM.POS    =  FLD.POS<1,3>
        TF.MAT.DATE.POS  =  FLD.POS<1,4>
        TF.DT.PAYMNT.POS =  FLD.POS<1,5>
        TF.BNK.REFNO.POS =  FLD.POS<1,6>
        
        IF Y.TF.NO NE '' THEN
            ! EB.DataAccess.FRead(FN.DRAWINGS,Y.TF.NO,R.DR.AR,F.DRAWINGS,Y.DR.ERR)
            EB.DataAccess.FRead(FN.DRAWINGS,Y.TF.NO, R.DR.AR, F.DRAWINGS, Y.ERR)
            IF  R.DR.AR  THEN
                Y.EXPOR.NAME  = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,EXPOR.NAME.POS,1>
                Y.EXPOR.NAME = Y.EXPOR.NAME[1,35]
                !CHANGE VM TO ' ' IN Y.EXPOR.NAME
                CHANGE SM TO ' ' IN Y.EXPOR.NAME
                
                
                Y.IMPR.NAME   = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,IMPR.NAME.POS,1>
                Y.IMPR.NAME   = Y.IMPR.NAME[1,35]
                CHANGE SM TO ' ' IN Y.IMPR.NAME
                
                !IF ( Y.AA.NO EQ 'AA21202Z4KVG' ) THEN
                !   DEBUG
                ! END
                !PRINT COMMOD.NM.POS
                Y.COMMO.NM  = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,COMMOD.NM.POS>
                !PRINT 'COMMO': Y.COMMO.NM
                Y.TF.MAT.DATE = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,TF.MAT.DATE.POS>
                !PRINT  Y.TF.MAT.DATE
                Y.TF.DT.PAYMNT = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,TF.DT.PAYMNT.POS>
                Y.PRESENTOR.CUST  = R.DR.AR<LC.Contract.Drawings.TfDrPresentorCust>
                EB.DataAccess.FRead(FN.CUS, Y.PRESENTOR.CUST, R.AR, F.CUS, CUS.ERR)
                Y.PR.TITTL=R.AR<ST.Customer.Customer.EbCusNameOne>   ;* CUSTOMER NAME
                Y.DRAW.CURRENCY = R.DR.AR<LC.Contract.Drawings.TfDrDrawCurrency>
                Y.DOCUMENT.AMOUNT = R.DR.AR<LC.Contract.Drawings.TfDrDocumentAmount>
                Y.DEBIT.CUST.RATE = R.DR.AR<LC.Contract.Drawings.TfDrDebitCustRate>
                Y.DOC.AMT.LOCAL = R.DR.AR<LC.Contract.Drawings.TfDrDocAmtLocal>
                Y.PAYMENT.AMOUNT = R.DR.AR<LC.Contract.Drawings.TfDrPaymentAmount>
                Y.TF.BNK.REFNO = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,TF.BNK.REFNO.POS>
                
            END
            ELSE
                EB.DataAccess.FRead(FN.DRAWINGS.HIS,Y.TF.NO, R.DR.AR.HIS, F.DRAWINGS.HIS, Y.ERR)
                
                IF R.DR.AR.HIS THEN
                    Y.EXPOR.NAME  = R.DR.AR.HIS<LC.Contract.Drawings.TfDrLocalRef,EXPOR.NAME.POS,1>
                    Y.EXPOR.NAME = Y.EXPOR.NAME[1,35]
                    !CHANGE VM TO ' ' IN Y.EXPOR.NAME
                    CHANGE SM TO ' ' IN Y.EXPOR.NAME
                
                
                    Y.IMPR.NAME   = R.DR.AR.HIS<LC.Contract.Drawings.TfDrLocalRef,IMPR.NAME.POS,1>
                    Y.IMPR.NAME   = Y.IMPR.NAME[1,35]
                    CHANGE SM TO ' ' IN Y.IMPR.NAME
                
                    !IF ( Y.AA.NO EQ 'AA21202Z4KVG' ) THEN
                    !   DEBUG
                    ! END
                    !PRINT COMMOD.NM.POS
                    Y.COMMO.NM  = R.DR.AR.HIS<LC.Contract.Drawings.TfDrLocalRef,COMMOD.NM.POS>
                    !PRINT 'COMMO': Y.COMMO.NM
                    Y.TF.MAT.DATE = R.DR.AR.HIS<LC.Contract.Drawings.TfDrLocalRef,TF.MAT.DATE.POS>
                    !PRINT  Y.TF.MAT.DATE
                    Y.TF.DT.PAYMNT = R.DR.AR.HIS<LC.Contract.Drawings.TfDrLocalRef,TF.DT.PAYMNT.POS>
                    Y.PRESENTOR.CUST  = R.DR.AR.HIS<LC.Contract.Drawings.TfDrPresentorCust>
                    EB.DataAccess.FRead(FN.CUS, Y.PRESENTOR.CUST, R.AR, F.CUS, CUS.ERR)
                    Y.PR.TITTL=R.AR<ST.Customer.Customer.EbCusNameOne>   ;* CUSTOMER NAME
                    Y.DRAW.CURRENCY = R.DR.AR.HIS<LC.Contract.Drawings.TfDrDrawCurrency>
                    Y.DOCUMENT.AMOUNT = R.DR.AR.HIS<LC.Contract.Drawings.TfDrDocumentAmount>
                    Y.DEBIT.CUST.RATE = R.DR.AR.HIS<LC.Contract.Drawings.TfDrDebitCustRate>
                    Y.DOC.AMT.LOCAL = R.DR.AR.HIS<LC.Contract.Drawings.TfDrDocAmtLocal>
                    Y.PAYMENT.AMOUNT = R.DR.AR.HIS<LC.Contract.Drawings.TfDrPaymentAmount>
                    Y.TF.BNK.REFNO = R.DR.AR<LC.Contract.Drawings.TfDrLocalRef,TF.BNK.REFNO.POS>
                END
            END
        END
            
            
        !############### Read from LC ############
        
*    PRINT 'TF NO :- ':  Y.TF.NO
        Y.LC.AMT.F       = REC.ACC.DATA<AA.Account.Account.AcLocalRef,LC.AMT.F.POS>
    
        Y.LN.MATURITY.DT = REC.ACC.DATA<AA.Account.Account.AcLocalRef,LN.MATURITY.DT.POS>
                 
        
        !############################## READ FORM INTEREST PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'DRINTEREST'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        Y.INT.RATE = REC.INT.DATA<AA.Interest.Interest.IntFixedRate> ;* Interest rate
         
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'DRPENALTYINT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        Y.PNINT.INT = REC.INT.DATA<AA.Interest.Interest.IntFixedRate> ;* Panelty Interest rate
      
        !##############################READ FORM INTEREST PROPERTY CLASS PROPERTIES END#############################


        !##############################ALL CLACULATED BALANCE()#############################
        RequestType<2> = 'ALL' ;* Unauthorised Movements required.
        RequestType<3> = 'ALL' ;* Projected Movements requierd
        RequestType<4> = 'ECB' ;* Balance file to be used
        RequestType<4,2> = 'END'
        ST.DATE = Y.TODATE
        EN.DATE = Y.TODATE
        SYS.DATE = Y.TODATE
        
        Y.BAL.TYPE = 'CURACCOUNT':FM:'DUEACCOUNT':FM:'GRCACCOUNT':FM:'STDACCOUNT':FM:'ACCPRINCIPALINT':FM:'DUEPRINCIPALINT':FM:'GRCPRINCIPALINT':FM:'STDPRINCIPALINT':FM:'ACCEXCISEDUTYFEE':FM:'DUEEXCISEDUTYFEE':FM:'GRCEXCISEDUTYFEE':FM:'STDEXCISEDUTYFEE':FM:'LCADVISE':FM:'LCCOLLCOM':FM:'LCPOSTAGE':FM:'LCSTAXDMEXP':FM:'DUELCADVISE':FM:'DUELCCOLLCOM':FM:'DUELCPOSTAGE':FM:'DUELCSTAXDMEXP'
        Y.BAL.TYPE.COUNT = DCOUNT(Y.BAL.TYPE, @FM)
        FOR U = 1 TO Y.BAL.TYPE.COUNT
            Y.BAL.AMT.TOTAL = ''
            Y.INT.BAL.AMT.TOTAL = ''
            BASEBALANCE = Y.BAL.TYPE<U>
            AA.Framework.GetPeriodBalances(Y.ACCT.ID, BASEBALANCE, RequestType, ST.DATE, EN.DATE, SYS.DATE, BalDetails, ErrorMessage)
            IF BalDetails NE '' THEN
                Y.BAL.AMT = BalDetails<4>
                Y.BAL.AMT.TOTAL = SUM(Y.BAL.AMT)
                IF BASEBALANCE EQ 'CURACCOUNT' THEN
                    Y.REG.AMT = Y.BAL.AMT.TOTAL    ;* REGULAR BAL AMOUNT
                    
                    ! PRINT 'Y.ACCT.ID ' : Y.ACCT.ID
                    ! PRINT 'Y.BAKANCE  ' : Y.REG.AMT
                END
            END
        NEXT U
        
* PRINT 'LOAM AMOUNT ' :Y.LC.AMT.F
        Y.EOL.AMT.CAL =  Y.LC.AMT.F + Y.REG.AMT
        IF Y.EOL.AMT.CAL LT 0 THEN
            Y.EOL.AMT = Y.EOL.AMT.CAL
            Y.EOL.AMT = ABS(Y.EOL.AMT)
            !  PRINT 'Y.EOL.AMT' : Y.EOL.AMT
        END
        
        Y.OUTSTANDING.AMT = Y.LC.AMT.F + Y.EOL.AMT.CAL
        
        !################################ ARRAY ###############################################
        !   Y.DATA<-1> = Y.LOAN.START.DATE :'*':Y.ACCT.ID :'*': Y.AA.NO :'*': Y.CUST:'*':Y.CUS.TITTL :'*': Y.BANK.REF.NO :'*': Y.IMP.LC.NO  :'*': Y.TF.NO  :'*': Y.LC.AMT.F :'*': Y.INT.RATE :'*': Y.PNINT.INT :'*': Y.LN.MATURITY.DT
        !                1                   2                3         4           5                    6                   7                    8              9              10                  11                     12
      
*  PRINT Y.DATA
        ! IF Y.IMP.LC.NO EQ '17602002A' THEN
        !     Y.DATA<-1> = Y.ACCT.ID :'*': Y.LOAN.START.DATE  :'*': Y.AA.NO :'*': Y.CUST :'*': Y.BANK.REF.NO :'*': Y.IMP.LC.NO :'*': Y.EXPOR.NAME :'*': Y.IMPR.NAME :'*':Y.PRESENTOR.CUST :'*': Y.DRAW.CURRENCY :'*': Y.DOCUMENT.AMOUNT :'*': Y.DEBIT.CUST.RATE :'*': Y.DOC.AMT.LOCAL :'*': Y.LC.AMT.F :'*': Y.EOL.AMT :'*': Y.OUTSTANDING.AMT :'*':Y.INT.RATE:'*':Y.PNINT.INT :'*':  Y.LN.MATURITY.DT :'*': Y.COMMO.NM :'*': Y.TF.MAT.DATE :'*':Y.PAYMENT.AMOUNT :'*':Y.TF.DT.PAYMNT
        Y.DATA<-1> = Y.ACCT.ID :'*': Y.LOAN.START.DATE  :'*': Y.AA.NO :'*': Y.CUST :'*': Y.TF.BNK.REFNO :'*': Y.IMP.LC.NO :'*': Y.EXPOR.NAME :'*': Y.IMPR.NAME :'*': Y.PR.TITTL :'*': Y.DRAW.CURRENCY :'*': Y.DOCUMENT.AMOUNT :'*': Y.DEBIT.CUST.RATE :'*': Y.DOC.AMT.LOCAL :'*': Y.LC.AMT.F :'*': Y.EOL.AMT :'*': Y.OUTSTANDING.AMT :'*':Y.INT.RATE:'*':Y.PNINT.INT :'*':  Y.LN.MATURITY.DT :'*': Y.COMMO.NM :'*': Y.TF.MAT.DATE :'*':Y.PAYMENT.AMOUNT :'*':Y.TF.DT.PAYMNT
        !                   1
        !PRINT Y.DATA
        ! PRINT  Y.EXPOR.NAME
        ! PRINT  Y.IMPR.NAME
        Y.EOL.AMT = ''
        Y.EOL.AMT.CAL =''
        !END
        
    NEXT I
  
RETURN


END
