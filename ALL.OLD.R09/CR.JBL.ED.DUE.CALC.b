* @ValidationCode : MjotNTU0NTQyOTQ6Q3AxMjUyOjE2MDg3MTc0MTEyMTc6REVMTDotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDE3MTAuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 Dec 2020 15:56:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE CR.JBL.ED.DUE.CALC(arrId,arrProp,arrCcy,arrRes,balanceAmount,perDat)
*-----------------------------------------------------------------------------
* Developed By- s.azam@fortress-global.com
* Condition  : This Routine will deduct the Excise Duty yearly as per Payment Schedule frequency
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Modification History :
* 1)
*    Date : 2021/08/08
*    Modification Description : Calculate for Lending
*    Modified By  : Md. Ebrahim Khalil Rian
*    Designation  : Software Engineer
*    Email        : erian@fortress-global.com
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.BD.CHG.INFORMATION
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_GTS.COMMON
    $INSERT I_F.BD.JBL.MSS.MATURE.VAL
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING AA.Framework
    $USING AA.TermAmount
    $USING AC.AccountOpening
    $USING EB.TransactionControl
    $USING AC.CashFlow
    $USING ST.ChargeConfig
    $USING AA.PaymentSchedule
    $USING AA.ActivityRestriction
    $USING ST.CurrencyConfig
    $USING AC.BalanceUpdates
*****************************************************
    IF EB.SystemTables.getVFunction() EQ 'I' THEN RETURN
    IF EB.SystemTables.getVFunction() EQ 'V' THEN RETURN
    IF EB.SystemTables.getVFunction() EQ 'A' THEN RETURN
**********************************************
    WRITE.FILE.VAR = "67 OFS$OPERATION: ":OFS$OPERATION
    GOSUB FILE.WRITE
*****************************************************
    IF (OFS$OPERATION EQ 'VALIDATE' OR OFS$OPERATION EQ 'PROCESS') AND c_aalocCurrActivity EQ 'LENDING-ISSUEBILL-SCHEDULE*DISBURSEMENT.%' THEN RETURN
       
    GOSUB INIT
    GOSUB OPENFILES
**********************************************
    WRITE.FILE.VAR = "75 c_aalocCurrActivity: ":c_aalocCurrActivity: "  arrId: ": arrId
    GOSUB FILE.WRITE
*****************************************************
* This if part is for Deposit Redeem, Close, Matured and Account Close
    IF c_aalocCurrActivity EQ 'ACCOUNTS-SETTLE-PAYOFF' OR c_aalocCurrActivity EQ 'ACCOUNTS-CLOSE-ARRANGEMENT' OR c_aalocCurrActivity EQ 'ACCOUNTS-CALCULATE-PAYOFF' OR c_aalocCurrActivity EQ 'LENDING-SETTLE-PAYOFF' OR c_aalocCurrActivity EQ 'LENDING-CLOSE-ARRANGEMENT' OR c_aalocCurrActivity EQ 'LENDING-MATURE-ARRANGEMENT' OR c_aalocCurrActivity EQ 'LENDING-CALCULATE-PAYOFF' THEN
        GOSUB CHRG.PROCESS
    END
* This if part is for Schedule wise Excise Duty Deduction
    IF c_aalocCurrActivity EQ 'ACCOUNTS-MAKEDUE-SCHEDULE' OR c_aalocCurrActivity EQ 'LENDING-MAKEDUE-SCHEDULE' THEN
        GOSUB PROCESS
    END
RETURN

*****
INIT:
*****
    FN.BD.CHG = 'F.BD.CHG.INFORMATION'
    F.BD.CHG = ''
    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    FN.FTCT = 'F.FT.COMMISSION.TYPE'
    F.FTCT = ''
    FN.AA.AC = 'F.AA.ACCOUNT.DETAILS'
    F.AA.AC = ''
    FN.AA.ACTIVITY = 'F.AA.ARRANGEMENT.ACTIVITY'
    F.AA.ACTIVITY = ''
    FN.CURR = 'F.CURRENCY'
    F.CURR = ''

    F.ACCOUNT= ''
    Y.MAX.AMT = 0
    Y.END.DATE = ''
    Y.START.DATE = ''
    ArrangementId = ''
    Y.PRODUCT.LINE = ''
    Y.BD.CHG.ID = ''
    RequestType = ''
    Y.WORKING.BALANCE = 0
    Y.MAX.AMT = ''
    Y.MIN.AMT = ''
    CHARGE.AMOUNT = 0
    Y.BD.CHG.ID = ''
    Y.REC.STATUS=''
    Y.MNEMONIC=''
    R.REC=''
    R.BD.CHG=''
    Y.TXN.DATE=''
    Yfamt=''
    Yfcy=''
    Yrate= 0
    Y.UPTO.AMT = 0
    Y.MIN.AMT= 0
    Y.CUR.AMT = 0
    Y.MAX.AMT = 0
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.BD.CHG,F.BD.CHG)
    EB.DataAccess.Opf(FN.AA,F.AA)
    EB.DataAccess.Opf(FN.FTCT,F.FTCT)
    EB.DataAccess.Opf(FN.AA.AC,F.AA.AC)
    EB.DataAccess.Opf(FN.AA.ACTIVITY,F.AA.ACTIVITY)
    EB.DataAccess.Opf(FN.CURR, F.CURR)
RETURN

********
PROCESS:
********
    EB.DataAccess.FRead(FN.AA.ACTIVITY,c_aalocTxnReference,R.AA.ACTIVITY,F.AA.ACTIVITY,E.AA.ACTIVITY)
    Y.REC.STATUS = R.AA.ACTIVITY<AA.Framework.ArrangementActivity.ArrActRecordStatus>
   
    
    IF Y.REC.STATUS EQ 'REVE' OR Y.REC.STATUS EQ 'RNAU' THEN
        RETURN
    END
    
    Y.END.DATE = EB.SystemTables.getToday()
    Y.START.DATE = Y.END.DATE[1,4]:'0101'
    
    EB.DataAccess.FRead(FN.AA.AC,arrId,R.AA.AC,F.AA.AC,E.AA.AC)
    Y.MNEMONIC = FN.AA.AC[2,3]
    Y.RENEW.DATE =R.AA.AC<AA.PaymentSchedule.AccountDetails.AdRenewalDate>
    Y.activityrecord = AA.Framework.getC_aalocarractivityrec()
    Y.ACTIVITY.DATE = Y.activityrecord<AA.Framework.ArrangementActivity.ArrActEffectiveDate>
    
**************************************************
    IF Y.RENEW.DATE EQ Y.ACTIVITY.DATE THEN RETURN
**************************************************
    Y.MAT.DATE =R.AA.AC<AA.PaymentSchedule.AccountDetails.AdMaturityDate>
    Y.PROP.CLASS = 'PAYMENT.SCHEDULE'
    AA.Framework.GetArrangementConditions(arrId,Y.PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    R.REC = RAISE(RETURN.VALUES)
    Y.PROPERTY.LIST = R.REC<AA.PaymentSchedule.PaymentSchedule.PsProperty>
    Y.DUE.FREQ.LIST = R.REC<AA.PaymentSchedule.PaymentSchedule.PsDueFreq>
    LOCATE arrProp IN Y.PROPERTY.LIST<1,1> SETTING Y.PROP.POS THEN
        Y.DUE.FREQ = Y.DUE.FREQ.LIST<1,Y.PROP.POS>
    END
    Y.MN = FIELD(Y.DUE.FREQ,' ',2)[2,2]
    Y.DAY = FIELD(Y.DUE.FREQ,' ',4)[2,2]
    Y.M.CHECK = ISDIGIT(Y.MN)
    Y.D.CHECK = ISDIGIT(Y.DAY)
    IF Y.M.CHECK EQ 0 THEN
        Y.MN = '0':FIELD(Y.DUE.FREQ,' ',2)[2,1]
    END
    IF Y.D.CHECK EQ 0 THEN
        Y.DAY = '0':FIELD(Y.DUE.FREQ,' ',4)[2,1]
    END
    Y.MNDD =  Y.MN:Y.DAY
    
     
*  IF Y.MAT.DATE EQ perDat AND Y.MNDD NE Y.MAT.DATE[5,4] THEN RETURN
**********************************************************************************************
    ArrangementId = arrId
    AA.Framework.GetArrangementAccountId(ArrangementId, accountId, Currency, ReturnError)   ;*To get Arrangement Account
    AA.Framework.GetArrangementProduct(ArrangementId, EffDate, ArrRecord, ProductId, PropertyList)  ;*Arrangement record
    Y.PRODUCT.LINE = ArrRecord<AA.Framework.Arrangement.ArrProductLine>
    Y.PRODUCT.GROUP = ArrRecord<AA.Framework.Arrangement.ArrProductGroup>
    Y.ARR.STRT.DT = ArrRecord<AA.Framework.Arrangement.ArrStartDate>
    Y.PRODUCT.NAME = ArrRecord<AA.Framework.Arrangement.ArrActiveProduct>
    Y.PRD.CURRENCY = ArrRecord<AA.Framework.Arrangement.ArrCurrency>
    IF Y.PRODUCT.NAME EQ 'JBL.PFS.DP' OR Y.PRODUCT.NAME EQ 'JBL.EPD.DP' OR Y.PRODUCT.NAME EQ 'JBL.SSS.DP' OR Y.PRODUCT.NAME EQ 'JBL.PMSP.DP' THEN
        RETURN
    END
    AA.Framework.GetBaseBalanceList(ArrangementId, arrProp, ReqdDate, ProductId, BaseBalance)
    
    Y.AC.REC = AC.AccountOpening.Account.Read(accountId, Error)

    REQUEST.TYPE<2> = "ALL"
    EFFECTIVE.DATE = c_aalocActivityEffDate
    BALANCE.TYPE = 'CURACCOUNT'
    IF Y.PRODUCT.LINE = 'ACCOUNTS' THEN
        BALANCE.TYPE = 'CURBALANCE'
    END
    AA.Framework.GetPeriodBalances(accountId, BALANCE.TYPE, REQUEST.TYPE, EFFECTIVE.DATE, "", "", BAL.DETAILS, "")
    Y.BALANCE = BAL.DETAILS<AC.BalanceUpdates.AcctActivity.IcActBalance,1>

    Y.CATEGORY = Y.AC.REC<AC.AccountOpening.Account.Category>
    Y.CUSTOMER = Y.AC.REC<AC.AccountOpening.Account.Customer>
    Y.LIMIT = Y.AC.REC<AC.AccountOpening.Account.LimitRef>
    
    RequestType<2> = 'ALL'      ;* Unauthorised Movements required.
    RequestType<3> = 'ALL'      ;* Projected Movements requierd
    RequestType<4> = 'ECB'      ;* Balance file to be used
    RequestType<4,2> = 'END'    ;* Balance required as on TODAY - though Activity date can be less than today
    AA.Framework.GetPeriodBalances(accountId,BaseBalance,RequestType,Y.START.DATE,Y.END.DATE,SystemDate,BalDetails,ErrorMessage)
    Y.BALANC.GET = BalDetails<4>
    
**********************************************************************************************
    Y.PROP.CLASS.IN = 'ACTIVITY.RESTRICTION'
    AA.Framework.GetArrangementConditions(ArrangementId,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
    Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
    Y.PERIODIC.ATTRIBUTE = Y.R.REC.IN<AA.ActivityRestriction.ActivityRestriction.AcrPeriodicAttribute>
    Y.PRIODIC.VALUE = Y.R.REC.IN<AA.ActivityRestriction.ActivityRestriction.AcrPeriodicValue>

    Y.PR.ATTRIBUTE = 'MINIMUM.BAL'
    LOCATE Y.PR.ATTRIBUTE IN Y.PERIODIC.ATTRIBUTE<1,1> SETTING POS THEN
        Y.MIN.BAL=Y.R.REC.IN<AA.ActivityRestriction.ActivityRestriction.AcrPeriodicValue,POS>
    END ELSE
        Y.MIN.BAL=0
    END
    IF Y.BALANCE GE Y.MIN.BAL THEN
        Y.WORKING.BALANCE = ABS(Y.BALANCE - Y.MIN.BAL)
    END
    IF Y.LIMIT NE '' THEN
        IF LEN(Y.LIMIT) LE 7 THEN
            Y.LIMIT = Y.LIMIT 'R%10'
        END ELSE
            Y.LEN = LEN(Y.LIMIT)+3
            Y.LIMIT = Y.LIMIT 'R%Y.LEN'
        END
    END
* This part is for Product wise lending Product Excise Duty Calculation

    AA.Framework.GetPeriodBalances(accountId, BaseBalance, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails, ErrorMessage)    ;*Balance left in the balance Type
**********************************************
**********************************************
    Y.MAX.AMT = ABS(MAXIMUM(BalDetails<4>))
**********************************************
    
    AC.CashFlow.AccountserviceGetworkingbalance(accountId, REC.WRK.BAL, response.Details)
    Y.MAX.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>
    
* This part is for Product wise lending Product Excise Duty Calculation
    IF Y.PRODUCT.LINE EQ 'LENDING' THEN
        PROP.CLASS = 'TERM.AMOUNT'
        PROPERTY = ""
        CALL AA.GET.ARRANGEMENT.CONDITIONS(arrId,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
        AC.R.REC = RAISE(RETURN.VALUES)
        Y.MAT.DATE = AC.R.REC<AA.TermAmount.TermAmount.AmtMaturityDate>
**********************************************
        WRITE.FILE.VAR = "Y.MAT.DATE: ":Y.MAT.DATE:" AND  TODAY:":Y.END.DATE: "  perDat:":perDat
        GOSUB FILE.WRITE
*****************************************************
        IF perDat[1,4] EQ Y.MAT.DATE[1,4] AND perDat GT Y.MAT.DATE THEN RETURN
        
        BaseBalance1 = BaseBalance
        BaseBalance2 = 'DUEACCOUNT'
        BaseBalance3 = 'UNDACCOUNT'
        BaseBalance4 = 'SUBACCOUNT'
        BaseBalance5 = 'STDACCOUNT'
        BaseBalance6 = 'SMAACCOUNT'
        BaseBalance7 = 'DOFACCOUNT'
*BaseBalance8 = 'DUEACCOUNT'
        BaseBalance9 = 'GRCACCOUNT'
        BaseBalance10 = 'DELACCOUNT'
        BaseBalance11 = 'NABACCOUNT'
        BaseBalance12 = 'PAYACCOUNT'
        BaseBalance13 = 'ACCPRINCIPALINT'
        BaseBalance14 = 'DUEPRINCIPALINT'
        BaseBalance15 = 'GRCPRINCIPALINT'
        BaseBalance16 = 'NABPRINCIPALINT'
            
        AA.Framework.GetPeriodBalances(accountId, BaseBalance1, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails1, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance2, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails2, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance3, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails3, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance4, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails4, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance5, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails5, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance6, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails6, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance7, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails7, ErrorMessage);
*AA.Framework.GetPeriodBalances(accountId, BaseBalance8, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails8, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance9, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails9, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance10, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails10, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance11, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails11, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance12, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails12, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance13, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails13, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance14, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails14, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance15, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails15, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance16, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails16, ErrorMessage);
        
            
        IF Y.PRODUCT.GROUP EQ "JBL.LTR.LN" OR Y.PRODUCT.GROUP EQ "JBL.PACK.CR.LN" OR Y.PRODUCT.GROUP EQ "JBL.IDBP.LN" OR Y.PRODUCT.GROUP EQ "JBL.FDBP.LN" THEN
            balanceAmount1 =   ABS(FIELD(BalDetails1<4>,@VM,DCOUNT(BalDetails1<4>,@VM)))
            balanceAmount2 =   ABS(FIELD(BalDetails2<4>,@VM,DCOUNT(BalDetails2<4>,@VM)))
            balanceAmount3 =   ABS(FIELD(BalDetails3<4>,@VM,DCOUNT(BalDetails3<4>,@VM)))
            balanceAmount4 =   ABS(FIELD(BalDetails4<4>,@VM,DCOUNT(BalDetails4<4>,@VM)))
            balanceAmount5 =   ABS(FIELD(BalDetails5<4>,@VM,DCOUNT(BalDetails5<4>,@VM)))
            balanceAmount6 =   ABS(FIELD(BalDetails6<4>,@VM,DCOUNT(BalDetails6<4>,@VM)))
            balanceAmount7 =   ABS(FIELD(BalDetails7<4>,@VM,DCOUNT(BalDetails7<4>,@VM)))
*balanceAmount8 =   ABS(FIELD(BalDetails8<4>,@VM,DCOUNT(BalDetails8<4>,@VM)))
            balanceAmount9 =   ABS(FIELD(BalDetails9<4>,@VM,DCOUNT(BalDetails9<4>,@VM)))
            balanceAmount10 =   ABS(FIELD(BalDetails10<4>,@VM,DCOUNT(BalDetails10<4>,@VM)))
            balanceAmount11 =   ABS(FIELD(BalDetails11<4>,@VM,DCOUNT(BalDetails11<4>,@VM)))
            balanceAmount12 =   ABS(FIELD(BalDetails12<4>,@VM,DCOUNT(BalDetails12<4>,@VM)))
            balanceAmount13 =   ABS(FIELD(BalDetails13<4>,@VM,DCOUNT(BalDetails13<4>,@VM)))
            balanceAmount14 =   ABS(FIELD(BalDetails14<4>,@VM,DCOUNT(BalDetails14<4>,@VM)))
            balanceAmount15 =   ABS(FIELD(BalDetails15<4>,@VM,DCOUNT(BalDetails15<4>,@VM)))
            balanceAmount16 =   ABS(FIELD(BalDetails16<4>,@VM,DCOUNT(BalDetails16<4>,@VM)))
*****************************************************
        END
        ELSE
            balanceAmount1 =   ABS(MINIMUM(BalDetails1<4>))
            balanceAmount2 =   ABS(MINIMUM(BalDetails2<4>))
            balanceAmount3 =   ABS(MINIMUM(BalDetails3<4>))
            balanceAmount4 =   ABS(MINIMUM(BalDetails4<4>))
            balanceAmount5 =   ABS(MINIMUM(BalDetails5<4>))
            balanceAmount6 =   ABS(MINIMUM(BalDetails6<4>))
            balanceAmount7 =   ABS(MINIMUM(BalDetails7<4>))
*balanceAmount8 =   ABS(MINIMUM(BalDetails8<4>))
            balanceAmount9 =   ABS(MINIMUM(BalDetails9<4>))
            balanceAmount10 =   ABS(MINIMUM(BalDetails10<4>))
            balanceAmount11 =   ABS(MINIMUM(BalDetails11<4>))
            balanceAmount12 =   ABS(MINIMUM(BalDetails12<4>))
            balanceAmount13 =   ABS(MINIMUM(BalDetails13<4>))
            balanceAmount14 =   ABS(MINIMUM(BalDetails14<4>))
            balanceAmount15 =   ABS(MINIMUM(BalDetails15<4>))
            balanceAmount16 =   ABS(MINIMUM(BalDetails16<4>))
        END
**********************************************
            
        Y.MAX.AMT  = balanceAmount1 + balanceAmount2 + balanceAmount3 + balanceAmount4 + balanceAmount5 + balanceAmount6 + balanceAmount7  + balanceAmount9 + balanceAmount10 + balanceAmount11 + balanceAmount12 + balanceAmount13 + balanceAmount14 + balanceAmount15 + balanceAmount16
**********************************************
        WRITE.FILE.VAR = "201 Y.MAX.AMT: ":Y.MAX.AMT: " balanceAmount1 : " : balanceAmount1  : " balanceAmount2 : " : balanceAmount2     : " balanceAmount3 : " : balanceAmount3     : " balanceAmount4 : " : balanceAmount4     : " balanceAmount5 : " : balanceAmount5     : " balanceAmount6 : " : balanceAmount6     : " balanceAmount7 : " : balanceAmount7     : " balanceAmount8 :  balanceAmount9 : " : balanceAmount9     : " balanceAmount10 : " : balanceAmount10   : " balanceAmount11 : " : balanceAmount11   : " balanceAmount12 : " : balanceAmount12   : " balanceAmount13 : " : balanceAmount13   : " balanceAmount14 : " : balanceAmount14   : " balanceAmount15 : " : balanceAmount15   : " balanceAmount16 : " : balanceAmount16
        GOSUB FILE.WRITE
*****************************************************
    END
    GOSUB EDPROCESS
RETURN

**********
EDPROCESS:
**********
    IF Y.MAX.AMT LE 0 THEN
        RETURN
    END
    IF Y.PRD.CURRENCY NE 'BDT' THEN
        GOSUB CURRENCY.CONVRT.AMT
        Y.MAX.AMT = Ylamt
    END
    Y.FTCT.ID = 'EDCHG'
    EB.DataAccess.FRead(FN.FTCT,Y.FTCT.ID,R.FTCT,F.FTCT,FT.CT.ERR)
    Y.UPTO.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouUptoAmt>
    Y.MIN.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouMinimumAmt>
    CONVERT SM TO VM IN Y.UPTO.AMT
    CONVERT SM TO VM IN Y.MIN.AMT
    Y.DCOUNT = DCOUNT(Y.UPTO.AMT,VM)
    FOR I = 1 TO Y.DCOUNT
        Y.AMT = Y.UPTO.AMT<1,I>
        IF Y.MAX.AMT LE Y.AMT THEN
            BREAK
        END
    NEXT I
    CHARGE.AMOUNT = Y.MIN.AMT<1,I>
    Y.BD.CHG.BEFORE.CHARGE = CHARGE.AMOUNT
    IF Y.PRD.CURRENCY NE 'BDT' THEN
        CHARGE.AMOUNT = CHARGE.AMOUNT/Yrate
    END
********Update the Local Template********************************
    Y.BD.CHG.ID = accountId:'-':arrProp
    EB.DataAccess.FRead(FN.BD.CHG,Y.BD.CHG.ID,R.BD.CHG,F.BD.CHG,BD.CHG.ER)
*******************************************************
    IF R.BD.CHG NE '' THEN
        Y.TXN.DATE = R.BD.CHG<BD.CHG.TXN.DATE>
        LOCATE perDat IN Y.TXN.DATE<1,1> SETTING Y.TXN.DATE.POS THEN
            RETURN
        END
    END
*******************************************************
    IF Y.PRODUCT.LINE EQ 'ACCOUNTS' THEN
        IF R.BD.CHG EQ '' THEN
            R.BD.CHG<BD.CHG.BASE.AMT> = Y.MAX.AMT
            R.BD.CHG<BD.TOTAL.CHG.AMT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DATE > = perDat
            IF Y.WORKING.BALANCE GE CHARGE.AMOUNT THEN
                R.BD.CHG<BD.CHG.TXN.REFNO> = c_aalocTxnReference
                R.BD.CHG<BD.CHG.SLAB.AMT> = CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.AMT> =  CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.DUE.AMT> = 0
                R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + CHARGE.AMOUNT
                R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + 0
                R.BD.CHG<BD.CHG.TXN.FLAG> = 'Schedule'
            END ELSE
                R.BD.CHG<BD.CHG.TXN.REFNO> = c_aalocTxnReference
                R.BD.CHG<BD.CHG.SLAB.AMT> = CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.AMT> =  0
                R.BD.CHG<BD.CHG.TXN.DUE.AMT> = CHARGE.AMOUNT
                R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + 0
                R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + CHARGE.AMOUNT
                CHARGE.AMOUNT = 0
            END
        END ELSE
            Y.DCOUNT =DCOUNT(R.BD.CHG<BD.CHG.TXN.DATE>,VM) + 1
            R.BD.CHG<BD.CHG.BASE.AMT,Y.DCOUNT> = Y.MAX.AMT
            R.BD.CHG<BD.TOTAL.CHG.AMT> = R.BD.CHG<BD.TOTAL.CHG.AMT> + CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DATE,Y.DCOUNT> = perDat
            IF Y.WORKING.BALANCE GE CHARGE.AMOUNT THEN
                R.BD.CHG<BD.CHG.TXN.REFNO,Y.DCOUNT> = c_aalocTxnReference
                R.BD.CHG<BD.CHG.SLAB.AMT,Y.DCOUNT> = CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.AMT,Y.DCOUNT> = CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.DUE.AMT,Y.DCOUNT> = 0
                R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + CHARGE.AMOUNT
                R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + 0
                R.BD.CHG<BD.CHG.TXN.FLAG,Y.DCOUNT> = 'Schedule'
            END ELSE
                R.BD.CHG<BD.CHG.TXN.REFNO,Y.DCOUNT> = c_aalocTxnReference
                R.BD.CHG<BD.CHG.SLAB.AMT,Y.DCOUNT> = CHARGE.AMOUNT
                R.BD.CHG<BD.CHG.TXN.AMT,Y.DCOUNT> = 0
                R.BD.CHG<BD.CHG.TXN.DUE.AMT,Y.DCOUNT> = CHARGE.AMOUNT
                R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + 0
                R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + CHARGE.AMOUNT
                CHARGE.AMOUNT = 0
            END
        END
    END
    
    IF Y.PRODUCT.LINE EQ 'LENDING' THEN
        IF R.BD.CHG EQ '' THEN
            R.BD.CHG<BD.CHG.BASE.AMT> = Y.MAX.AMT
            R.BD.CHG<BD.TOTAL.CHG.AMT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DATE > = perDat
            R.BD.CHG<BD.CHG.TXN.REFNO> = c_aalocTxnReference
            R.BD.CHG<BD.CHG.SLAB.AMT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.AMT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DUE.AMT> = 0
            R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + CHARGE.AMOUNT
            R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + 0
            R.BD.CHG<BD.CHG.TXN.FLAG> = 'Schedule'
        END ELSE
            Y.DCOUNT =DCOUNT(R.BD.CHG<BD.CHG.TXN.DATE>,@VM) + 1
            R.BD.CHG<BD.CHG.BASE.AMT,Y.DCOUNT> = Y.MAX.AMT
            R.BD.CHG<BD.TOTAL.CHG.AMT> = R.BD.CHG<BD.TOTAL.CHG.AMT> + CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DATE,Y.DCOUNT> = perDat
            R.BD.CHG<BD.CHG.TXN.REFNO,Y.DCOUNT> = c_aalocTxnReference
            R.BD.CHG<BD.CHG.SLAB.AMT,Y.DCOUNT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.AMT,Y.DCOUNT> = CHARGE.AMOUNT
            R.BD.CHG<BD.CHG.TXN.DUE.AMT,Y.DCOUNT> = 0
            R.BD.CHG<BD.TOTAL.REALIZE.AMT> = R.BD.CHG<BD.TOTAL.REALIZE.AMT> + CHARGE.AMOUNT
            R.BD.CHG<BD.OS.DUE.AMT> = R.BD.CHG<BD.OS.DUE.AMT> + 0
            R.BD.CHG<BD.CHG.TXN.FLAG,Y.DCOUNT> = 'Schedule'
        END
*****************************************************
    END

    R.BD.CHG<BD.INPUTTER> = EB.SystemTables.getOperator()
    R.BD.CHG<BD.AUTHORISER> = EB.SystemTables.getOperator()
    R.BD.CHG<BD.CO.CODE> = EB.SystemTables.getIdCompany()
    EB.DataAccess.FWrite(FN.BD.CHG,Y.BD.CHG.ID,R.BD.CHG)
    EB.TransactionControl.JournalUpdate(Y.BD.CHG.ID)
*****************************************************
**********************************************
    WRITE.FILE.VAR = "535 c_aalocCurrActivity: ":c_aalocCurrActivity :"       CHARGE.AMOUNT:":CHARGE.AMOUNT
    GOSUB FILE.WRITE
*****************************************************
    balanceAmount = CHARGE.AMOUNT
RETURN


*************
CHRG.PROCESS:
*************
    EB.DataAccess.FRead(FN.AA.ACC.DETAILS, Y.ARR.ID, R.AA.AC.REC, F.AA.ACC.DETAILS, Y.ERR)
    EB.DataAccess.FRead(FN.AA, arrId, R.AA.ARR, F.AA, Y.ARR.ERR)
    Y.PRODUCT.GROUP = R.AA.ARR<AA.Framework.Arrangement.ArrProductGroup>
    Y.PRODUCT.LINE = R.AA.ARR<AA.Framework.Arrangement.ArrProductLine>
    Y.PRD.NAME = R.AA.ARR<AA.Framework.Arrangement.ArrActiveProduct>
    Y.PRD.CURRENCY = R.AA.ARR<AA.Framework.Arrangement.ArrCurrency>

    Y.END.DATE = EB.SystemTables.getToday()
    Y.START.DATE = Y.END.DATE[1,4]:'0101'
    
    ArrangementId = arrId
*AA.Framework.GetBaseBalanceList(arrId, arrProp, ReqdDate, ProductId, BaseBalance)
    AA.Framework.GetBaseBalanceList(ArrangementId, arrProp, ReqdDate, ProductId, BaseBalance)
    
    AA.Framework.GetArrangementAccountId(ArrangementId, accountId, Currency, ReturnError)

    AC.CashFlow.AccountserviceGetworkingbalance(accountId, REC.WRK.BAL, response.Details)
    Y.CUR.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>
**********************************************
    WRITE.FILE.VAR = "493 Y.CUR.AMT: ":Y.CUR.AMT
    GOSUB FILE.WRITE
*****************************************************

    IF Y.PRODUCT.LINE EQ 'LENDING' THEN
        PROP.CLASS = 'TERM.AMOUNT'
        PROPERTY = ""
        CALL AA.GET.ARRANGEMENT.CONDITIONS(arrId, PROP.CLASS, PROPERTY,'', RETURN.IDS, RETURN.VALUES, ERR.MSG)
        AC.R.REC = RAISE(RETURN.VALUES)
        Y.MAT.DATE = AC.R.REC<AA.TermAmount.TermAmount.AmtMaturityDate>
**********************************************
        WRITE.FILE.VAR = "Y.MAT.DATE: ":Y.MAT.DATE:" AND  TODAY:":Y.END.DATE
        GOSUB FILE.WRITE
*****************************************************
        IF perDat[1,4] EQ Y.MAT.DATE[1,4] AND perDat GT Y.MAT.DATE THEN RETURN
        
        BaseBalance1 = BaseBalance
        BaseBalance2 = 'DUEACCOUNT'
        BaseBalance3 = 'UNDACCOUNT'
        BaseBalance4 = 'SUBACCOUNT'
        BaseBalance5 = 'STDACCOUNT'
        BaseBalance6 = 'SMAACCOUNT'
        BaseBalance7 = 'DOFACCOUNT'
*BaseBalance8 = 'DUEACCOUNT'
        BaseBalance9 = 'GRCACCOUNT'
        BaseBalance10 = 'DELACCOUNT'
        BaseBalance11 = 'NABACCOUNT'
        BaseBalance12 = 'PAYACCOUNT'
        BaseBalance13 = 'ACCPRINCIPALINT'
        BaseBalance14 = 'DUEPRINCIPALINT'
        BaseBalance15 = 'GRCPRINCIPALINT'
        BaseBalance16 = 'NABPRINCIPALINT'
        
        AA.Framework.GetPeriodBalances(accountId, BaseBalance1, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails1, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance2, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails2, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance3, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails3, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance4, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails4, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance5, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails5, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance6, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails6, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance7, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails7, ErrorMessage);
*AA.Framework.GetPeriodBalances(accountId, BaseBalance8, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails8, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance9, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails9, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance10, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails10, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance11, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails11, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance12, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails12, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance13, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails13, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance14, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails14, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance15, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails15, ErrorMessage);
        AA.Framework.GetPeriodBalances(accountId, BaseBalance16, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails16, ErrorMessage);
        
        
*****************************************************
        IF Y.PRODUCT.GROUP EQ "JBL.LTR.LN" OR Y.PRODUCT.GROUP EQ "JBL.PACK.CR.LN" OR Y.PRODUCT.GROUP EQ "JBL.IDBP.LN" OR Y.PRODUCT.GROUP EQ "JBL.FDBP.LN" THEN
            balanceAmount1 =   ABS(FIELD(BalDetails1<4>,@VM,DCOUNT(BalDetails1<4>,@VM)))
            balanceAmount2 =   ABS(FIELD(BalDetails2<4>,@VM,DCOUNT(BalDetails2<4>,@VM)))
            balanceAmount3 =   ABS(FIELD(BalDetails3<4>,@VM,DCOUNT(BalDetails3<4>,@VM)))
            balanceAmount4 =   ABS(FIELD(BalDetails4<4>,@VM,DCOUNT(BalDetails4<4>,@VM)))
            balanceAmount5 =   ABS(FIELD(BalDetails5<4>,@VM,DCOUNT(BalDetails5<4>,@VM)))
            balanceAmount6 =   ABS(FIELD(BalDetails6<4>,@VM,DCOUNT(BalDetails6<4>,@VM)))
            balanceAmount7 =   ABS(FIELD(BalDetails7<4>,@VM,DCOUNT(BalDetails7<4>,@VM)))
*balanceAmount8 =   ABS(FIELD(BalDetails8<4>,@VM,DCOUNT(BalDetails8<4>,@VM)))
            balanceAmount9 =   ABS(FIELD(BalDetails9<4>,@VM,DCOUNT(BalDetails9<4>,@VM)))
            balanceAmount10 =   ABS(FIELD(BalDetails10<4>,@VM,DCOUNT(BalDetails10<4>,@VM)))
            balanceAmount11 =   ABS(FIELD(BalDetails11<4>,@VM,DCOUNT(BalDetails11<4>,@VM)))
            balanceAmount12 =   ABS(FIELD(BalDetails12<4>,@VM,DCOUNT(BalDetails12<4>,@VM)))
            balanceAmount13 =   ABS(FIELD(BalDetails13<4>,@VM,DCOUNT(BalDetails13<4>,@VM)))
            balanceAmount14 =   ABS(FIELD(BalDetails14<4>,@VM,DCOUNT(BalDetails14<4>,@VM)))
            balanceAmount15 =   ABS(FIELD(BalDetails15<4>,@VM,DCOUNT(BalDetails15<4>,@VM)))
            balanceAmount16 =   ABS(FIELD(BalDetails16<4>,@VM,DCOUNT(BalDetails16<4>,@VM)))
*****************************************************
        END
        ELSE
            balanceAmount1 =   ABS(MINIMUM(BalDetails1<4>))
            balanceAmount2 =   ABS(MINIMUM(BalDetails2<4>))
            balanceAmount3 =   ABS(MINIMUM(BalDetails3<4>))
            balanceAmount4 =   ABS(MINIMUM(BalDetails4<4>))
            balanceAmount5 =   ABS(MINIMUM(BalDetails5<4>))
            balanceAmount6 =   ABS(MINIMUM(BalDetails6<4>))
            balanceAmount7 =   ABS(MINIMUM(BalDetails7<4>))
*balanceAmount8 =   ABS(MINIMUM(BalDetails8<4>))
            balanceAmount9 =   ABS(MINIMUM(BalDetails9<4>))
            balanceAmount10 =   ABS(MINIMUM(BalDetails10<4>))
            balanceAmount11 =   ABS(MINIMUM(BalDetails11<4>))
            balanceAmount12 =   ABS(MINIMUM(BalDetails12<4>))
            balanceAmount13 =   ABS(MINIMUM(BalDetails13<4>))
            balanceAmount14 =   ABS(MINIMUM(BalDetails14<4>))
            balanceAmount15 =   ABS(MINIMUM(BalDetails15<4>))
            balanceAmount16 =   ABS(MINIMUM(BalDetails16<4>))
        END
**********************************************
            
        Y.CUR.AMT  = balanceAmount1 + balanceAmount2 + balanceAmount3 + balanceAmount4 + balanceAmount5 + balanceAmount6 + balanceAmount7 + balanceAmount9 + balanceAmount10 + balanceAmount11 + balanceAmount12 + balanceAmount13 + balanceAmount14 + balanceAmount15 + balanceAmount16
**********************************************
        WRITE.FILE.VAR = "441 Y.CUR.AMT: ":Y.CUR.AMT: " balanceAmount1 : " : balanceAmount1  : " balanceAmount2 : " : balanceAmount2     : " balanceAmount3 : " : balanceAmount3     : " balanceAmount4 : " : balanceAmount4     : " balanceAmount5 : " : balanceAmount5     : " balanceAmount6 : " : balanceAmount6     : " balanceAmount7 : " : balanceAmount7     : " balanceAmount9 : " : balanceAmount9     : " balanceAmount10 : " : balanceAmount10   : " balanceAmount11 : " : balanceAmount11   : " balanceAmount12 : " : balanceAmount12   : " balanceAmount13 : " : balanceAmount13   : " balanceAmount14 : " : balanceAmount14   : " balanceAmount15 : " : balanceAmount15   : " balanceAmount16 : " : balanceAmount16
        GOSUB FILE.WRITE
*****************************************************
    END
****************************************************************
    Y.BD.CHG.ID = accountId:'-':arrProp
    EB.DataAccess.FRead(FN.BD.CHG,Y.BD.CHG.ID,R.BD.CHG,F.BD.CHG,BD.CHG.ER)

    Y.MAX.AMT = ABS(Y.CUR.AMT)
**********************************************

    IF Y.PRD.CURRENCY NE 'BDT' THEN
        GOSUB CURRENCY.CONVRT.AMT
        Y.MAX.AMT = Ylamt
    END
*******************************************************************
    Y.FTCT.ID = 'EDCHG'
    EB.DataAccess.FRead(FN.FTCT,Y.FTCT.ID,R.FTCT,F.FTCT,FT.CT.ERR)
    Y.UPTO.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouUptoAmt>
    Y.MIN.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouMinimumAmt>
    CONVERT SM TO VM IN Y.UPTO.AMT
    CONVERT SM TO VM IN Y.MIN.AMT
    Y.DCOUNT = DCOUNT(Y.UPTO.AMT,VM)
    FOR I = 1 TO Y.DCOUNT
        Y.AMT = Y.UPTO.AMT<1,I>
        IF Y.MAX.AMT LE Y.AMT THEN
            BREAK
        END
    NEXT I
    CHARGE.AMOUNT = Y.MIN.AMT<1,I>
**********************************************
*****************************************************
    IF Y.PRD.CURRENCY NE 'BDT' THEN
        CHARGE.AMOUNT = CHARGE.AMOUNT/Yrate
    END

    IF Y.MAX.AMT EQ 0 THEN
**********************************************
        WRITE.FILE.VAR = "671 0 c_aalocCurrActivity: ":c_aalocCurrActivity :"       CHARGE.AMOUNT:":CHARGE.AMOUNT
        GOSUB FILE.WRITE
*****************************************************
        balanceAmount = 0
    END ELSE
**********************************************
        WRITE.FILE.VAR = "677 c_aalocCurrActivity: ":c_aalocCurrActivity :"       CHARGE.AMOUNT:":CHARGE.AMOUNT:"   R.BD.CHG<BD.OS.DUE.AMT>: ":R.BD.CHG<BD.OS.DUE.AMT>
        GOSUB FILE.WRITE
*****************************************************
        balanceAmount = R.BD.CHG<BD.OS.DUE.AMT> + CHARGE.AMOUNT
    END
RETURN
 

CURRENCY.CONVRT.AMT:
    Yfamt = Y.MAX.AMT
    Yfcy = Y.PRD.CURRENCY
* Ymarket = 1
*ST.ExchangeRate.MiddleRateConvCheck(Yfamt, Yfcy, Yrate, Ymarket, Ylamt, YdifAmt, YdifPct)
    EB.DataAccess.FRead(FN.CURR,Yfcy,REC.CCY.REC,F.CURR,ERR.REC.CCY)
    Y.CCY.MARKET = REC.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket>
    Y.MID.REVAL.RATE = REC.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate>
    IF REC.CCY.REC THEN
        Y.MARKET.VAL = 1
        LOCATE Y.MARKET.VAL IN Y.CCY.MARKET<1,1> SETTING Y.CCY.POS THEN
            Yrate = Y.MID.REVAL.RATE<1,Y.CCY.POS>
        END
    END
    Ylamt = Yfamt * Yrate
RETURN

*****************************************************
FILE.WRITE:
*    Y.LOG.FILE= arrId:' ED COB.txt'
*    Y.FILE.DIR ='./DFE.TEST'
*    OPENSEQ Y.FILE.DIR,Y.LOG.FILE TO F.FILE.DIR ELSE NULL
*    WRITESEQ WRITE.FILE.VAR APPEND TO F.FILE.DIR ELSE NULL
*    CLOSESEQ F.FILE.DIR
RETURN
********************************************************

 
