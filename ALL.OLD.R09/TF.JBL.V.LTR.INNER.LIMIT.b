SUBROUTINE TF.JBL.V.LTR.INNER.LIMIT
*-----------------------------------------------------------------------------
* Attach Activity.Api: JBL.TF.LTR.API    Property: Settlement(use it only settlement property)
*-----------------------------------------------------------------------------
* Create by : Mahmudur Rahman udoy.                  Date: 7/6/2021
*----------------------------------------------------------------------------
* Description : This routine only trigger when limit Excess over.
* When System shows Excess override Message it check multiple things for amount not to cross preant Inner Limit.
* Check 1: Settlement Payout Account must be null & PAD account mandatory.
* Check 2: PAD Customer & LTR Customer must be the same.
* Check 3: PAD Account Preant Limit & Serial number does match with LTR current limit.
* Check 4: Commitment amount not greater than parent Permitted amount(outsting + parent exact avail amount).
*          Exact parent available limit: Internal amount - Total limit used amount(sum of all limit accounts outstanding + limit used amount)
* Check 5: LTR amount not greater than LTR exact limit available amount.
*          Exact child available limit: Internal amount - Sum of all limit relates account(Auth, Unauth, disburse) amount.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_SOA.COMMON
    
    $USING AA.Framework
    $USING AA.Account
    $USING AA.Customer
    $USING AA.Limit
    $USING AA.Settlement
    $USING AA.TermAmount
    $USING LI.Config
    $USING AC.AccountOpening
    $USING AC.CashFlow
    
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences

*-----------------------------------------------------------------------------

    Y.AA.REC.STATUS = EB.SystemTables.getRNew(AA.Framework.Arrangement.ArrArrStatus)

    IF Y.AA.REC.STATUS NE 'UNAUTH' OR Y.AA.REC.STATUS NE 'AUTH'  THEN
        GOSUB INITIALISE ; *INITIALISATION
        GOSUB OPENFILE ; *FILE OPEN
        GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    END
RETURN
    
INITIALISE:
*** <desc>INITIALISATION </desc>

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''

    FN.LIMIT = "F.LIMIT"
    F.LIMIT = ""
    
    Y.PAD.CATEGROY = '1801':VM:'1802':VM:'1803':VM:'1804':VM:'1805':VM:'1811':VM:'1812':VM:'1813':VM:'1814':VM:'1815':VM:'1821':VM:'1822':VM:'1823':VM:'1824':VM:'1825'
    Y.OVERRIDE.ID = ""
    Y.PAYOUT.ACCT = ''
    Y.ACCOUNT.PROPERTY = ''
    Y.PROP.CLASS.IN = ''
    Y.AA.PAD.AC = ''
    Y.PAD.AC.LIMIT.REF = ''
    Y.PAD.CUS.ID = ''
    Y.ARR.CUS = ''
    Y.PAD.OUT.AMT = 0
    Y.ACCT.NUM = ''
    

    Y.TODATE =EB.SystemTables.getToday()
    EB.Updates.MultiGetLocRef("AA.ARR.ACCOUNT","LT.TF.IMP.PADID",Y.POS)
    Y.PAD.AC.POS =Y.POS<1,1>
  
RETURN

OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.ARR,F.ARR)
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.DataAccess.Opf(FN.LIMIT, F.LIMIT)
RETURN

PROCESS:
*    Y.ARR.ID = c_aalocArrId
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    
    Y.SOA.OVERRIDES.COUNT = DCOUNT(SOA$OVERRIDES,'"')
    IF Y.SOA.OVERRIDES.COUNT THEN
        FOR I = 2 TO Y.SOA.OVERRIDES.COUNT STEP 2
            Y.OVERRIDE.ID = FIELD(SOA$OVERRIDES,'"',I)
            IF Y.OVERRIDE.ID EQ 'NO.LINE' THEN BREAK
            IF Y.OVERRIDE.ID EQ 'EXCESS.ID' THEN BREAK
        NEXT I
    END ELSE
        Y.VM.COUNT = DCOUNT(OFS$OVERRIDES, @VM)
        FOR I = 1 TO Y.VM.COUNT
            IF OFS$OVERRIDES<1,I> EQ "NO LINE ALLOCATED" THEN
                Y.OVERRIDE.ID = 'NO.LINE'
                BREAK
            END
            Y.FMT.4 = FIELD(OFS$OVERRIDES<1,I>," ",4)
            Y.FMT.9 = FIELD(OFS$OVERRIDES<1,I>," ",9)
            IF Y.FMT.4 EQ "Excess" AND Y.FMT.9 EQ "Limit" THEN
                Y.OVERRIDE.ID = 'EXCESS.ID'
                BREAK
            END
        NEXT I
    END
    IF Y.OVERRIDE.ID EQ 'NO.LINE' THEN
        EB.SystemTables.setEtext("LI-LIMIT.KEY.NOT.FOUND")
        EB.ErrorProcessing.StoreEndError()
    END
*****************THE MAIN GAME START NOW WHEN OVERRIDE SHOWS "Excess Limit"****************
**********************************************
*-------------Exced limit 1st if start----------
**********************************************
    IF Y.OVERRIDE.ID EQ 'EXCESS.ID' THEN
        Y.PAYOUT.ACCT =  EB.SystemTables.getRNew(AA.Settlement.Settlement.SetPayoutAccount)
        IF Y.PAYOUT.ACCT NE '' THEN
            EB.SystemTables.setEtext("Settlement Payout Account must be null when limit is exced!")
            EB.ErrorProcessing.StoreEndError()
        END
      
        Y.PROP.CLASS.IN = 'CUSTOMER'
        Y.PROPERTY = 'CUSTOMER'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS.IN,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES.CUSTOMER,ERR.MSG)
        Y.CUSTOMER.PROPERTY = RAISE(RETURN.VALUES.CUSTOMER)
        Y.ARR.CUS = Y.CUSTOMER.PROPERTY<AA.Customer.Customer.CusCustomer>

        !***************PAD Account & Customer Check start************************
        Y.PROP.CLASS.IN = 'ACCOUNT'
        Y.PROPERTY = 'ACCOUNT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS.IN,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES.ACCOUNT,ERR.MSG)
        Y.ACCOUNT.PROPERTY = RAISE(RETURN.VALUES.ACCOUNT)
        Y.AA.AC.LOC.REF = Y.ACCOUNT.PROPERTY<AA.Account.Account.AcLocalRef>
        Y.AA.PAD.AC = Y.AA.AC.LOC.REF<1, Y.PAD.AC.POS>
        IF Y.AA.PAD.AC EQ '' THEN
            EB.SystemTables.setEtext("PAD ID Account mendatory!")
            EB.ErrorProcessing.StoreEndError()
        END
        EB.DataAccess.FRead(FN.ACCOUNT, Y.AA.PAD.AC, REC.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
        Y.PAD.CUS.ID = REC.ACCOUNT<AC.AccountOpening.Account.Customer>
        Y.PAD.AC.CATEGORY = REC.ACCOUNT<AC.AccountOpening.Account.Category>
        Y.PAD.AC.LIMIT.REF = REC.ACCOUNT<AC.AccountOpening.Account.LimitRef>
*        Y.PAD.ARR.ID = REC.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
        IF Y.PAD.CUS.ID NE Y.ARR.CUS THEN
            EB.SystemTables.setEtext("PAD Customer & LTR Customer must be same!")
            EB.ErrorProcessing.StoreEndError()
        END
        LOCATE Y.PAD.AC.CATEGORY IN Y.PAD.CATEGROY<1,1> SETTING Y.POS THEN
            !-----Just check is it PAD account with matching category------*
        END ELSE
            EB.SystemTables.setEtext("PAD ID must be a PAD Account!")
            EB.ErrorProcessing.StoreEndError()
        END

        !***************PAD Account & Customer Check end*****************************************

        Y.PROP.CLASS.IN = 'LIMIT'
        Y.PROPERTY = 'LIMIT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,Y.PROP.CLASS.IN,Y.PROPERTY,'',RETURN.IDS,RETURN.VALUES.LIMIT,ERR.MSG)
        Y.LIMIT.PROPERTY = RAISE(RETURN.VALUES.LIMIT)
        Y.AA.LIM.REF = Y.LIMIT.PROPERTY<AA.Limit.Limit.LimLimitReference>
        Y.AA.LIM.SERI = Y.LIMIT.PROPERTY<AA.Limit.Limit.LimLimitSerial>
 
        !**************LTR currently used limit preant & serial check start*********************
        IF Y.PAD.AC.LIMIT.REF[1,2] NE '75' AND Y.PAD.AC.LIMIT.REF[6,2] NE Y.AA.LIM.SERI THEN
            EB.SystemTables.setEtext("PAD Account Preant Limit & Serial number does not match with current limit !")
            EB.ErrorProcessing.StoreEndError()
        END
        !**************LTR currently used limit preant & serial check end************************
        
        
        Y.COMMIT.AMT = 0
        PROP.CLASS.TERM = 'TERM.AMOUNT'
        PROPERTY = 'COMMITMENT'
        AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS.TERM,PROPERTY,'',RETURN.IDS.TERM,RETURN.VALUES.TERM,ERR.MSG.TERM)
        Y.COMMITMENT.PROPERTY = RAISE(RETURN.VALUES.TERM)
        Y.COMMIT.AMT = Y.COMMITMENT.PROPERTY<AA.TermAmount.TermAmount.AmtAmount>  ;* LOAN AMOUNT

        !******************Parent Limit Available amount calculate start*********************
        
        Y.PR.LIMIT.USED.AMT = 0
        Y.PR.LIMIT.AVAIL.AMT = 0
        Y.PR.EXACT.LIMIT.AVAIL.AMT = 0
        Y.PR.LIMIT.ID = Y.ARR.CUS:".000":Y.AA.LIM.REF[1,2]:"00.":Y.AA.LIM.SERI
        EB.DataAccess.FRead(FN.LIMIT, Y.PR.LIMIT.ID, REC.PR.LIMIT, F.LIMIT, ER.LIMIT)
        Y.PR.LIMIT.ACCT.LIST =  REC.PR.LIMIT<LI.Config.Limit.Account>
        Y.PR.LIMIT.AVAIL.AMT  = REC.PR.LIMIT<LI.Config.Limit.AvailAmt>
        Y.PR.LIMIT.TOT.OUT = REC.PR.LIMIT<LI.Config.Limit.TotalOs>
        Y.PR.LIMIT.INERNAL = REC.PR.LIMIT<LI.Config.Limit.InternalAmount>
        Y.PR.LIMIT.ACCT.COUNT = DCOUNT(Y.PR.LIMIT.ACCT.LIST,@VM)
        FOR J = 1 TO Y.PR.LIMIT.ACCT.COUNT
            Y.PR.LIMIT.ACCT = Y.PR.LIMIT.ACCT.LIST<1,J>
            Y.ACCT.NUM = Y.PR.LIMIT.ACCT
            GOSUB ACCT.OUTSTANDING.AMT
            IF Y.ACCT.OUT.AMT NE '' THEN
                Y.PR.LIMIT.USED.AMT += Y.ACCT.OUT.AMT
            END
        NEXT J
        Y.PR.LIMIT.USED.AMT += ABS(Y.PR.LIMIT.TOT.OUT) ;*** Y.PR.LIMIT.USED.AMT = ACCT LIMIT USED + OTHER LIMIT USED
        Y.PR.EXACT.LIMIT.AVAIL.AMT = Y.PR.LIMIT.INERNAL - Y.PR.LIMIT.USED.AMT
        
        !******************Parent Limit Available amount calculate end **********************

        !**** LTR Amount not greter to parent Permitted amount check start******************
        Y.PRMITED.AMT = 0
        Y.ACCT.NUM = Y.AA.PAD.AC
        GOSUB ACCT.OUTSTANDING.AMT
        Y.PAD.OUT.AMT = Y.ACCT.OUT.AMT
        Y.PARENT.PRMITED.AMT = Y.ACCT.OUT.AMT + Y.PR.EXACT.LIMIT.AVAIL.AMT
        IF Y.COMMIT.AMT GT Y.PARENT.PRMITED.AMT THEN
            EB.SystemTables.setEtext("LIMIT EXCED because after disburse Parent avail amount will be nagetived!")
            EB.ErrorProcessing.StoreEndError()
        END
    
        !**** LTR Amount not greter to parent Permitted amount check end******************
        !***********LTR Limit available amount check start*****************************
        Y.LTR.LIMIT.AVAL.AMT = 0
        Y.LTR.LIMIT.USED.AMT = 0
        Y.LTR.LIMIT.ID = Y.ARR.CUS:".000":Y.AA.LIM.REF:".":Y.AA.LIM.SERI
        EB.DataAccess.FRead(FN.LIMIT, Y.LTR.LIMIT.ID, REC.CHILD.LIMIT, F.LIMIT, ER.LIMIT)
        Y.LTR.LIMIT.ACCT.LIST =  REC.CHILD.LIMIT<LI.Config.Limit.Account>
        Y.LTR.LIMIT.INTERNAL.AMT  = REC.CHILD.LIMIT<LI.Config.Limit.InternalAmount>
        Y.LTR.LIMIT.ACCT.COUNT = DCOUNT(Y.LTR.LIMIT.ACCT.LIST,@VM)
        FOR U = 1 TO Y.LTR.LIMIT.ACCT.COUNT
            Y.LTR.LIMIT.ACCT = Y.LTR.LIMIT.ACCT.LIST<1,U>
            EB.DataAccess.FRead(FN.ACCOUNT, Y.LTR.LIMIT.ACCT, REC.LTR.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
            Y.LTR.ARR.ID = REC.LTR.ACCOUNT<AC.AccountOpening.Account.ArrangementId>
            EB.DataAccess.FRead(FN.ARR, Y.LTR.ARR.ID, ARR.REC, F.ARR, ARR.ERR)
            IF ARR.REC THEN
                Y.LTR.ARR.STATUS = ARR.REC<AA.Framework.Arrangement.ArrArrStatus>
                !********************* FOR LOOP IF 2 START***********************
                IF Y.LTR.ARR.STATUS EQ 'AUTH' OR Y.LTR.ARR.STATUS EQ 'UNAUTH' THEN
                    Y.OLD.ACCT.COMMITMENT.AMT = 0
                    !*************** FOR LOOP IF 3 START*************
                    IF Y.LTR.ARR.STATUS EQ 'AUTH' THEN  ;*if amount go to UNC(UNC loan account status 'Auth') for this purose this condition needed.
                        Y.ACCT.NUM = Y.LTR.LIMIT.ACCT
                        GOSUB ACCT.OUTSTANDING.AMT
                        IF Y.ACCT.OUT.AMT NE '' THEN
                            Y.LTR.LIMIT.USED.AMT += Y.ACCT.OUT.AMT
                            CONTINUE
                        END
                    END
                    !*************** FOR LOOP IF 3 END*************
                    AA.Framework.GetArrangementConditions(Y.LTR.ARR.ID,PROP.CLASS.TERM,PROPERTY,'',RETURN.IDS.TERM,RETURN.VALUES.TERM,ERR.MSG.TERM)
                    Y.OLD.ACCT.COMMITMENT.PROPERTY = RAISE(RETURN.VALUES.TERM)
                    Y.OLD.ACCT.COMMITMENT.AMT = Y.OLD.ACCT.COMMITMENT.PROPERTY<AA.TermAmount.TermAmount.AmtAmount>
                    Y.LTR.LIMIT.USED.AMT += Y.OLD.ACCT.COMMITMENT.AMT
                END
                ELSE
                    Y.ACCT.NUM = Y.LTR.LIMIT.ACCT
                    GOSUB ACCT.OUTSTANDING.AMT
                    Y.LTR.LIMIT.USED.AMT += Y.ACCT.OUT.AMT
                END
                !********************** FOR LOOP IF 2 END********************
            END
        NEXT U

        Y.LTR.LIMIT.AVAL.AMT = Y.LTR.LIMIT.INTERNAL.AMT - Y.LTR.LIMIT.USED.AMT
        IF Y.LTR.LIMIT.AVAL.AMT LT 1 OR Y.COMMIT.AMT GT Y.LTR.LIMIT.AVAL.AMT THEN
            EB.SystemTables.setEtext("LTR amount geter than limit available amount!")
            EB.ErrorProcessing.StoreEndError()
        END
        !***********LTR Limit available amount check end*****************************
    END
**********************************************
*-------------Exced limit 1st if end----------
**********************************************
RETURN
   
******************************************************
ACCT.OUTSTANDING.AMT:
*-------------------------------------------------------------------------------------------------------
*NOTE: it retrun amount only when working balance is nagetive otherwise it retrun 0 as outstanding amount.
*--------------------------------------------------------------------------------------------------------
    Y.ACCT.CUR.AMT = ''
    Y.ACCT.OUT.AMT = ''
    AC.CashFlow.AccountserviceGetworkingbalance(Y.ACCT.NUM, REC.WRK.BAL, response.Details)
    Y.ACCT.CUR.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>
    IF Y.ACCT.CUR.AMT LT 0 THEN
        Y.ACCT.OUT.AMT = ABS(Y.ACCT.CUR.AMT)
    END
    IF Y.ACCT.CUR.AMT GE 0 THEN
        Y.ACCT.OUT.AMT = 0
    END
 
RETURN

END