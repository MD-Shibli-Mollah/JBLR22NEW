SUBROUTINE GB.JBL.AU.OVERRIDE.TO.ERROR
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    :
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* /0/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_SOA.COMMON
    $INSERT I_AA.LOCAL.COMMON
    
    $USING AA.Framework
    $USING AA.ProductManagement
    $USING AA.Account
    $USING AA.Limit
    $USING AA.Settlement
    $USING AA.TermAmount
    $USING LI.Config
    $USING AC.AccountOpening
    
    
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
***************************************************FASDFASFDASFASDF
RETURN
*********************************************************fdsaFASDFASFAS
*-----------------------------------------------------------------------------
GOSUB INITIALISE ; *INITIALISATION
GOSUB OPENFILE ; *FILE OPEN
GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

    FN.AA.PRODUCT.DESIGNER = "F.AA.PRODUCT.DESIGNER"
    F.AA.PRODUCT.DESIGNER = ""

    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""

    FN.LIMIT = "F.LIMIT"
    F.LIMIT = ""
    
    Y.OVERRIDE.ID = ""
    
    FN.JBL.LTR.INNER = 'F.JBL.LTR.INNER'
    F.JBL.LTR.INNER = ''
   
 
    EB.Updates.MultiGetLocRef("AA.ARR.ACCOUNT","LT.TF.IMP.PADID",Y.POS)
    Y.PAD.AC.POS =Y.POS<1,1>
  
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.AA.PRODUCT.DESIGNER, F.AA.PRODUCT.DESIGNER)
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.DataAccess.Opf(FN.LIMIT, F.LIMIT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.PRODUCT = EB.SystemTables.getRNew(AA.Framework.ArrangementActivity.ArrActProduct):"-19990601"

    EB.DataAccess.FRead(FN.AA.PRODUCT.DESIGNER, Y.PRODUCT, REC.AA.PRODUCT.DESIGNER, F.AA.PRODUCT.DESIGNER, ER.AA.PRODUCT.DESIGNER)

    Y.AA.PRO.GROUP = REC.AA.PRODUCT.DESIGNER<AA.ProductManagement.ProductDesigner.PrdProductGroup>

    Y.AA.CUSTOMER = EB.SystemTables.getRNew(AA.Framework.ArrangementActivity.ArrActCustomer)
    Y.AA.ID = EB.SystemTables.getRNew(AA.Framework.ArrangementActivity.ArrActArrangement)
************************************
    WRITE.FILE.VAR = "STACK TRACE : ":SYSTEM(1029):" SOA$OVERRIDES:=>":SOA$OVERRIDES
    GOSUB FILE.WRITE
*********************************************
    Y.SOA.OVERRIDES.COUNT = DCOUNT(SOA$OVERRIDES,'"')
    IF Y.SOA.OVERRIDES.COUNT THEN
        FOR I = 2 TO Y.SOA.OVERRIDES.COUNT STEP 2
            Y.OVERRIDE.ID = FIELD(SOA$OVERRIDES,'"',I)
**********************************************
            WRITE.FILE.VAR = "OVERRIDE ID :":I:": ":Y.OVERRIDE.ID
            GOSUB FILE.WRITE
**********************************************
            IF Y.OVERRIDE.ID EQ 'NO.LINE' THEN BREAK
            IF Y.OVERRIDE.ID EQ 'EXCESS.ID' THEN BREAK
        NEXT I
    END ELSE
        Y.VM.COUNT = DCOUNT(OFS$OVERRIDES, @VM)
**********************************************
        WRITE.FILE.VAR = "Y.VM.COUNT: ":Y.VM.COUNT
        GOSUB FILE.WRITE
**********************************************

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
    
    IF Y.OVERRIDE.ID EQ 'EXCESS.ID' THEN
**********************************************
        WRITE.FILE.VAR = "135 Y.OVERRIDE.ID: ":Y.OVERRIDE.ID
        GOSUB FILE.WRITE
*****************************************************
        IF Y.AA.PRO.GROUP EQ "JBL.LTR.LN" THEN
**********************************************
            WRITE.FILE.VAR = "140 Y.AA.PRO.GROUP: ":Y.AA.PRO.GROUP:" Y.AA.ID:":Y.AA.ID
            GOSUB FILE.WRITE
******************************************************************************************
            Y.PROP.CLASS.IN = 'LIMIT'
            AA.Framework.GetArrangementConditions(Y.AA.ID,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
            Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
******************************************************************************************
            WRITE.FILE.VAR = "147 Y.R.REC.IN: ":Y.R.REC.IN
            GOSUB FILE.WRITE
******************************************************************************************
            Y.AA.LIM.REF = Y.R.REC.IN<AA.Limit.Limit.LimLimitReference>
            Y.AA.LIM.SERI = Y.R.REC.IN<AA.Limit.Limit.LimLimitSerial>
**********************************************
            WRITE.FILE.VAR = "Y.AA.LIM.REF: ":Y.AA.LIM.REF:"  Y.AA.LIM.SERI:": Y.AA.LIM.SERI
            GOSUB FILE.WRITE
*****************************************************
            
            Y.PROP.CLASS.IN = 'ACCOUNT'
            AA.Framework.GetArrangementConditions(Y.AA.ID,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
            Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
**********************************************
            WRITE.FILE.VAR = "Y.R.REC.IN: ":Y.R.REC.IN:"   ERR.MSG:":ERR.MSG
            GOSUB FILE.WRITE
*****************************************************
            Y.AA.LTR.AC = Y.R.REC.IN<AA.Account.Account.AcAccountReference>
            Y.AA.AC.LOC.REF = Y.R.REC.IN<AA.Account.Account.AcLocalRef>
            Y.AA.PAD.AC = Y.AA.AC.LOC.REF<1, Y.PAD.AC.POS>
**********************************************
            WRITE.FILE.VAR = "Y.AA.LTR.AC: ":Y.AA.LTR.AC:" Y.AA.AC.LOC.REF:":Y.AA.AC.LOC.REF:" Y.AA.PAD.AC:":Y.AA.PAD.AC
            GOSUB FILE.WRITE
*****************************************************
        
            Y.PROP.CLASS.IN = 'TERM.AMOUNT'
            AA.Framework.GetArrangementConditions(Y.AA.ID,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
            Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
            Y.AA.AMOUNT = Y.R.REC.IN<AA.TermAmount.TermAmount.AmtAmount>
        
            Y.PROP.CLASS.IN = 'SETTLEMENT'
            AA.Framework.GetArrangementConditions(Y.AA.ID,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
            Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
            Y.AA.PAYOUT.AC = Y.R.REC.IN<AA.Settlement.Settlement.SetPayoutAccount>
            
            Y.LIMIT.ID = Y.AA.CUSTOMER:".000":Y.AA.LIM.REF:".":Y.AA.LIM.SERI
            EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, REC.LIMIT, F.LIMIT, ER.LIMIT)
            Y.LIM.AVAILAMT = REC.LIMIT<LI.Config.Limit.AvailAmt> - Y.AA.AMOUNT
            
            Y.LIMIT.ID.PR = Y.AA.CUSTOMER:".0007500.":Y.AA.LIM.SERI
            EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID.PR, REC.LIMIT.PR, F.LIMIT, ER.LIMIT.PR)
            Y.LIM.AVAILAMT.PR = REC.LIMIT.PR<LI.Config.Limit.AvailAmt>
*************
            WRITE.FILE.VAR = "174 Y.LIM.AVAILAMT: ":Y.LIM.AVAILAMT:"  Y.LIM.AVAILAMT.PR:":Y.LIM.AVAILAMT.PR:"  Y.AA.LIM.REF:":Y.AA.LIM.REF:"  Y.AA.PAYOUT.AC:":Y.AA.PAYOUT.AC:"  Y.AA.PAD.AC:":Y.AA.PAD.AC
            GOSUB FILE.WRITE
************
            IF Y.LIM.AVAILAMT GE '0' AND Y.LIM.AVAILAMT.PR GE '0' AND Y.AA.LIM.REF[1,2] EQ '75' AND Y.AA.PAYOUT.AC EQ '' AND Y.AA.PAD.AC NE '' THEN
**********************************************
                WRITE.FILE.VAR = "176 Y.LIM.AVAILAMT: ":Y.LIM.AVAILAMT
                GOSUB FILE.WRITE
*****************************************************
                EB.DataAccess.FRead(FN.ACCOUNT, Y.AA.PAD.AC, REC.ACCOUNT, F.ACCOUNT, ERR.ACCOUNT)
                Y.PAC.AC.LIMIT.REFF = REC.ACCOUNT<AC.AccountOpening.Account.LimitRef>
                IF Y.PAC.AC.LIMIT.REFF[1,2] EQ '75' AND Y.PAC.AC.LIMIT.REFF[6,2] EQ Y.AA.LIM.SERI THEN
**********************************************
                    WRITE.FILE.VAR = "183 Y.PAC.AC.LIMIT.REFF: ":Y.PAC.AC.LIMIT.REFF
                    GOSUB FILE.WRITE
*****************************************************
                    IF Y.PAC.AC.LIMIT.REFF[1,4] EQ '7516' OR Y.PAC.AC.LIMIT.REFF[1,4] EQ '7546' OR Y.PAC.AC.LIMIT.REFF[1,4] EQ '7547' OR Y.PAC.AC.LIMIT.REFF[1,4] EQ '7548' OR Y.PAC.AC.LIMIT.REFF[1,4] EQ '7549' THEN
**********************************************
                        WRITE.FILE.VAR = "188 Y.PAC.AC.LIMIT.REFF: ":Y.PAC.AC.LIMIT.REFF
                        GOSUB FILE.WRITE
*****************************************************
                        Y.END.DATE = EB.SystemTables.getToday()
                        Y.START.DATE = EB.SystemTables.getToday()
                        BaseBalance = 'CURACCOUNT'
                        BaseBalance2 = 'ACCDRPENALTYINT'
                        BaseBalance3 = 'ACCDRINTEREST'

                        RequestType<2> = 'ALL'      ;* Unauthorised Movements required.
                        RequestType<3> = 'ALL'      ;* Projected Movements requierd
                        RequestType<4> = 'ECB'      ;* Balance file to be used
                        RequestType<4,2> = 'END'    ;* Balance required as on TODAY - though Activity date can be less than today
*----------------------------here check system mature value and orginal given mature LT or GT for Savings Scheme and Multipleir DP-----------------------------------
                        AA.Framework.GetPeriodBalances(Y.AA.PAD.AC, BaseBalance, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails, ErrorMessage)    ;*Balance left in the balance Type
                        AA.Framework.GetPeriodBalances(Y.AA.PAD.AC, BaseBalance2, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails2, ErrorMessage)    ;*Balance left in the balance Type
                        AA.Framework.GetPeriodBalances(Y.AA.PAD.AC, BaseBalance3, RequestType, Y.START.DATE, Y.END.DATE, SystemDate, BalDetails3, ErrorMessage)    ;*Balance left in the balance Type
                        Y.CUR.AMT = ABS(MAXIMUM(ABS(BalDetails<4>))) + ABS(MAXIMUM(ABS(BalDetails2<4>))) ABS(MAXIMUM(ABS(BalDetails3<4>)))
                    
                        IF Y.AA.AMOUNT GT Y.CUR.AMT THEN
**********************************************
                            WRITE.FILE.VAR = "209 Y.AA.AMOUNT: ":Y.AA.AMOUNT
                            GOSUB FILE.WRITE
*****************************************************
                            EB.SystemTables.setEtext("LI-EXCESS.ID")
                            EB.ErrorProcessing.StoreEndError()
                        END
*                        R.REC<LTR.INNER.PAD.ID> = Y.AA.PAYOUT.AC
*                        R.REC<LTR.INNER.LTR.CCY> = 'BDT'
*                        R.REC<LTR.INNER.LTR.AMOUNT> = Y.AA.AMOUNT
*                        EB.DataAccess.FWrite(FN.JBL.LTR.INNER, Y.AA.LTR.AC, R.REC)
                    END ELSE
                        EB.SystemTables.setEtext("LI-EXCESS.ID")
                        EB.ErrorProcessing.StoreEndError()
                    END
                END ELSE
                    EB.SystemTables.setEtext("LI-EXCESS.ID")
                    EB.ErrorProcessing.StoreEndError()
                END
                
            END ELSE
                EB.SystemTables.setEtext("LI-EXCESS.ID")
                EB.ErrorProcessing.StoreEndError()
            END
                
        END ELSE
            EB.SystemTables.setEtext("LI-EXCESS.ID")
            EB.ErrorProcessing.StoreEndError()
        END
    END
    
    

    
*************************************
*    WRITE.FILE.VAR = "STACK TRACE : ":SYSTEM(1029):"OVER MSG:=>":OFS$OVERRIDES
*    GOSUB FILE.WRITE
***********************************************
*    WRITE.FILE.VAR = "Y.ARR.ID1: ":Y.AA.ID
*    GOSUB FILE.WRITE
*****************************************************
*
*    Y.VM.COUNT = DCOUNT(OFS$OVERRIDES, @VM)
***********************************************
*    WRITE.FILE.VAR = "Y.VM.COUNT: ":Y.VM.COUNT
*    GOSUB FILE.WRITE
***********************************************
*
*    FOR I = 1 TO Y.VM.COUNT
*        Y.OFS.OVERRIDE = OFS$OVERRIDES<1,I>
***********************************************
*        WRITE.FILE.VAR = "Y.OFS.OVERRIDE: ":Y.OFS.OVERRIDE
*        GOSUB FILE.WRITE
******************************************************
*
*        IF OFS$OVERRIDES<1,I> EQ "NO LINE ALLOCATED" THEN
*            EB.SystemTables.setEtext("LI-LIMIT.KEY.NOT.FOUND")
*            EB.ErrorProcessing.StoreEndError()
*        END
*
*
*        Y.FMT.4 = FIELD(OFS$OVERRIDES<1,I>," ",4)
*        Y.FMT.7 = FIELD(OFS$OVERRIDES<1,I>," ",7)
*        Y.FMT.9 = FIELD(OFS$OVERRIDES<1,I>," ",9)
*        Y.FMT.10 = FIELD(OFS$OVERRIDES<1,I>," ",10)
*
*        IF Y.FMT.4 EQ "Excess" AND Y.FMT.9 EQ "Limit" THEN
*
*            IF Y.AA.PRO.GROUP EQ "JBL.LTR.LN" AND FIELD(Y.FMT.10,'.',2)[4,4] EQ '7500' THEN
*
*                Y.PROP.CLASS.IN = 'TERM.AMOUNT'
*                AA.Framework.GetArrangementConditions(Y.AA.ID,Y.PROP.CLASS.IN,PROPERTY,'',RETURN.IDS,RETURN.VALUES.IN,ERR.MSG)
*                Y.R.REC.IN = RAISE(RETURN.VALUES.IN)
*                Y.AA.AMOUNT = Y.R.REC.IN<AA.TermAmount.TermAmount.AmtAmount>
***********************************************
*                WRITE.FILE.VAR = "Y.AA.AMOUNT: ":Y.AA.AMOUNT
*                GOSUB FILE.WRITE
***********************************************
*
*                EB.DataAccess.FRead(FN.LIMIT, Y.FMT.10, REC.LIMIT, F.LIMIT, ER.LIMIT)
*                IF REC.LIMIT<LI.Config.Limit.AvailAmt> GE '0' THEN
*                    Y.PAD.LIMIT.LIST = "7516":@VM:"7546":@VM:"7547":@VM:"7548":@VM:"7549"
*                    Y.PAD.LIMIT.LIST.VM.COUNT = DCOUNT(Y.PAD.LIMIT.LIST, @VM)
*                    Y.PAD.USED.AMT = "0"
*                    FOR J = 1 TO Y.PAD.LIMIT.LIST.VM.COUNT
*                        Y.LIMIT.ID = FIELD(Y.FMT.10,'.',1):".000":Y.PAD.LIMIT.LIST<1,I>:".":FIELD(Y.FMT.10,'.',3)
*                        EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, REC.LIMIT.SUB, F.LIMIT, ER.LIMIT.SUB)
*                        IF REC.LIMIT.SUB THEN
*                            Y.PAD.USED.AMT += REC.LIMIT.SUB<LI.Config.Limit.InternalAmount> - REC.LIMIT.SUB<LI.Config.Limit.AvailAmt>
*                        END
*                    NEXT J
*
*                    Y.LTR.LIMIT.LIST = "7518":@VM:"7529":@VM:"7517":@VM:"7530":@VM:"7531"
*                    Y.LTR.LIMIT.LIST.VM.COUNT = DCOUNT(Y.LTR.LIMIT.LIST, @VM)
*                    Y.LTR.USED.AMT = "0"
*                    FOR J = 1 TO Y.LTR.LIMIT.LIST.VM.COUNT
*                        Y.LIMIT.ID = FIELD(Y.FMT.10,'.',1):".000":Y.LTR.LIMIT.LIST<1,I>:".":FIELD(Y.FMT.10,'.',3)
*                        EB.DataAccess.FRead(FN.LIMIT, Y.LIMIT.ID, REC.LIMIT.SUB, F.LIMIT, ER.LIMIT.SUB)
*                        IF REC.LIMIT.SUB THEN
*                            Y.LTR.USED.AMT += REC.LIMIT.SUB<LI.Config.Limit.InternalAmount> - REC.LIMIT.SUB<LI.Config.Limit.AvailAmt>
*                        END
*                    NEXT J
*                    Y.LTR.AMT = Y.LTR.USED.AMT + Y.AA.AMOUNT
*                    IF Y.PAD.USED.AMT GE Y.LTR.AMT ELSE
*                        EB.SystemTables.setEtext("LI-EXCESS.ID")
*                        EB.ErrorProcessing.StoreEndError()
*                    END
*                END
*                ELSE
*                    EB.SystemTables.setEtext("LI-EXCESS.ID")
*                    EB.ErrorProcessing.StoreEndError()
*                END
*
*            END
*            ELSE
*                EB.SystemTables.setEtext("LI-EXCESS.ID")
*                EB.ErrorProcessing.StoreEndError()
*            END
*        END
*    NEXT I
RETURN
*** </region>

*****************************************************
FILE.WRITE:
*    Y.LOG.FILE='OVERRIDE TEST RI.txt'
*    Y.FILE.DIR ='./DFE.TEST'
*    OPENSEQ Y.FILE.DIR,Y.LOG.FILE TO F.FILE.DIR ELSE NULL
*    WRITESEQ WRITE.FILE.VAR APPEND TO F.FILE.DIR ELSE NULL
*    CLOSESEQ F.FILE.DIR
RETURN
********************************************************
END