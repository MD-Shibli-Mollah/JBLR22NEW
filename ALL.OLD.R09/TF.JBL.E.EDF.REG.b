SUBROUTINE TF.JBL.E.EDF.REG(Y.DATA)
    !PROGRAM TF.JBL.E.EDF.REG

*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*NOFILE.E.EDF.LIST
* JBL.ENQ.EDF.LIST     TF.JBL.E.EDF.REG
*-----------------------------------------------------------------------------
 
   
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_AA.LOCAL.COMMON
    $USING AA.Framework
    $USING RE.ConBalanceUpdates
*    $USING ST.AccountStatement
		$USING AC.AccountStatement
    $USING AC.EntryCreation
    $USING AC.AccountOpening
    $USING AA.Account
    $USING AA.Limit
    $USING AA.Interest
    $USING AA.TermAmount
    $USING LC.Contract
    
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Reports
    $USING ST.CompanyCreation
    $USING ST.Customer
    $USING EB.Updates

 
    !   ST.CompanyCreation.LoadCompany('BNK')

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

    FN.DRAWINGS = "F.DRAWINGS"
    F.DRAWINGS = ""
    Y.DR.ERR = ''
    
    
    FLD.POS = ''
    APPLICATION.NAMES = 'AA.ARR.ACCOUNT'

    LOCAL.FIELDS = 'LT.AC.BD.EXLCNO':VM:'LT.AC.BD.LNMADT' :VM: 'LT.ACCT.LN.AMT'
*                     1                   2                          3
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    BB.LC.NO.POS       =  FLD.POS<1,1>
    LN.MATURITY.DT.POS =  FLD.POS<1,2>
    LC.AMT.F.POS       =  FLD.POS<1,3>
    
    
    
    LOCATE "CUSTOMER" IN EB.Reports.getEnqSelection()<2,1> SETTING CUSTOMER.POS THEN
        Y.CUS.ID=EB.Reports.getEnqSelection()<4,CUSTOMER.POS>
    END
    
    LOCATE "MAT.DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING MAT.DATE.POS THEN
        Y.MAT.DATE=EB.Reports.getEnqSelection()<4,MAT.DATE.POS>
    END
    
    LOCATE "PRODUCT.GROUP" IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.GROUP.POS THEN
        Y.PRD.GRP.ID=EB.Reports.getEnqSelection()<4,PRODUCT.GROUP.POS>
    END
    LOCATE "PRODUCT" IN EB.Reports.getEnqSelection()<2,1> SETTING PRODUCT.POS THEN
        Y.PRD.ID=EB.Reports.getEnqSelection()<4,PRODUCT.POS>
    END
    
    Y.COMP = EB.SystemTables.getIdCompany()
    Y.TODATE = EB.SystemTables.getToday()
    

*  Y.COMP = 'BD0010133'
*   Y.FROM.DATE = '20200101'
*  Y.TO.DATE = '20211206'
* Y.PRD.GRP.ID = 'JBL.EDF.LN'
  
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
        Y.ARR.ID = SEL.LIST<I>
*        PRINT  'ARR:- ':Y.ARR.ID
        EB.DataAccess.FRead(FN.AA.ARRANGEMENT, Y.ARR.ID, ARR.REC, F.AA.ARRANGEMENT, ERR.ARR)
        Y.ACCT.ID = ARR.REC<AA.Framework.Arrangement.ArrLinkedApplId>       ;* LOAN ID
    
        Y.AA.NO =  Y.ARR.ID ;* ARRANGEMENT ID
*  PRINT 'ARR:- ': Y.AA.NO
        Y.CUST = ARR.REC<AA.Framework.Arrangement.ArrCustomer>   ;* CUSTOMER ID
*  PRINT 'CUS ID:- ':  Y.CUST
        CONVERT VM TO FM IN Y.CUST
        EB.DataAccess.FRead(FN.CUS, Y.CUST, R.AR, F.CUS, CUS.ERR)
        Y.CUS.TITTL=R.AR<ST.Customer.Customer.EbCusNameOne>   ;* CUSTOMER NAME
*   PRINT 'CUS ID:- ':  Y.CUS.TITTL
        Y.LOAN.START.DATE = ARR.REC<AA.Framework.Arrangement.ArrStartDate>  ;* LOAN START DATE
*   PRINT 'LN ST DT :- ': Y.LOAN.START.DATE
    
        !############################## READ FORM LIMIT PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.LIMIT = 'LIMIT'
        PROPERTY =  'LIMIT'

      
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.LIMIT,PROPERTY,'',RETURN.IDS.LIMIT,RETURN.VALUES.LIMIT,ERR.MSG.LIMIT)
        REC.LIMIT.DATA = RAISE(RETURN.VALUES.LIMIT)
        
        Y.LIMIT.REF = REC.LIMIT.DATA<AA.Limit.Limit.LimLimitReference>
        Y.LIMIT.SL  = REC.LIMIT.DATA<AA.Limit.Limit.LimLimitSerial>
        
        Y.LIMIT = Y.LIMIT.REF :'.':Y.LIMIT.SL
        
        !############################## READ FORM ACCOUNT PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.ACCT = 'ACCOUNT'
        PROPERTY =  'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.ACCT,PROPERTY,'',RETURN.IDS.ACCT,RETURN.VALUES.ACCT,ERR.MSG.ACCT)
        REC.ACC.DATA = RAISE(RETURN.VALUES.ACCT)
        Y.IMP.LC.NO      = REC.ACC.DATA<AA.Account.Account.AcLocalRef,BB.LC.NO.POS>
        
        Y.LC.AMT.F       = REC.ACC.DATA<AA.Account.Account.AcLocalRef,LC.AMT.F.POS>
        Y.LN.MATURITY.DT = REC.ACC.DATA<AA.Account.Account.AcLocalRef,LN.MATURITY.DT.POS>
        
        
        !############################## READ FORM INTEREST PROPERTY CLASS PROPERTIES#############################
        PROP.CLASS.INT = 'INTEREST'
        PROPERTY = 'DRINTEREST'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.INT,PROPERTY,'',RETURN.IDS.INT,RETURN.VALUES.INT,ERR.MSG.INT)
        REC.INT.DATA = RAISE(RETURN.VALUES.INT)
        Y.INT.RATE = REC.INT.DATA<AA.Interest.Interest.IntFixedRate> ;* Interest rate
        !################################
        
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
        Y.EOL.AMT.CAL =''
        Y.EOL.AMT.CAL =  Y.LC.AMT.F + Y.REG.AMT
        IF Y.EOL.AMT.CAL LT 0 THEN
            Y.EOL.AMT = Y.EOL.AMT.CAL
            Y.EOL.AMT = ABS(Y.EOL.AMT)
            !  PRINT 'Y.EOL.AMT' : Y.EOL.AMT
        END
        
        Y.OUTSTANDING.AMT = Y.LC.AMT.F + Y.EOL.AMT.CAL
        
        
        !################################ ARRAY ###############################################
        Y.DATA<-1> = Y.ACCT.ID :'*': Y.AA.NO :'*': Y.CUST :'*': Y.CUS.TITTL:'*': Y.LIMIT :'*': Y.IMP.LC.NO :'*': Y.INT.RATE :'*': Y.OUTSTANDING.AMT :'*': Y.LOAN.START.DATE  :'*': Y.LN.MATURITY.DT
        !                   1            2            3               4             5               6                  7                8                          9                   10
        
        PRINT Y.DATA
        
        
        
        Y.EOL.AMT = ''
        Y.EOL.AMT.CAL =''
        !END
        
    NEXT I
  
RETURN


END
