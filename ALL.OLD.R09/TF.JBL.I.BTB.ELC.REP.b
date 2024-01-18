* @ValidationCode : MjotMTg0Mjg0NTI3MDpDcDEyNTI6MTU3NDA3NDE4MDIwODpERUxMOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjE3X0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Nov 2019 16:49:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.I.BTB.ELC.REP
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* version: LETTER.OF.CREDIT,BD.ELC.REPLACE
* This input Routine is use to validate different fields for BTB Replacement LC
* and to update JOB Register and sales Contract Record accordingly
*-----------------------------------------------------------------------------
* Modification History : 12/20/2020     modified by: Mahmudur Rahman
* Modified line: 343-352  added another full replace check by differ between lc amount & contact amount.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.BD.SCT.CAPTURE
    $INSERT I_F.BD.BTB.JOB.REGISTER
    $INSERT I_F.BD.LC.AD.CODE
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING ST.CurrencyConfig
    $USING EB.Template
    $USING ST.CompanyCreation

    Y.STATUS = EB.SystemTables.getRNew(V - 8)
    IF Y.STATUS EQ 'IHLD' THEN RETURN
    IF V$FUNCTION EQ 'R' THEN
        EB.SystemTables.setEtext('LC Reversal Not Possible')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF V$FUNCTION EQ 'H' THEN
        EB.SystemTables.setEtext('History Restore not Possible')
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*****
INIT:
*****
    FN.LC = 'F.LETTER.OF.CREDIT';           F.LC = ''
    FN.SCT = 'F.BD.SCT.CAPTURE';            F.SCT = ''
    FN.BTB.JR = 'F.BD.BTB.JOB.REGISTER';    F.BTB.JR = ''
    FN.CCY = 'F.CURRENCY';                  F.CCY = ''
    FN.COMPANY = 'F.COMPANY';               F.COMPANY = ''
    FN.BD.LC.AD.CODE= 'F.BD.LC.AD.CODE';     F.BD.LC.AD.CODE = ''
    
    APP.NAME = ''; LOCAL.FIELDS = ''; Y.LC.BEN.CUST.ID = ''; Y.LC.LOC.REF = ''; Y.SCT.BEN.CUST.ID = ''; Y.SCT.ID.LST = ''; Y.SCT.ID.CNT = '';
    Y.TF.SCONT.ID = ''; Y.SCT.REP.ALLOW.YN = ''; Y.SCT.FULLY.REP.YN = ''; Y.SCT.FULLY.UTLIZED.YN = '';Y.TOT.SCT.ENT.AMT = ''; Y.SCT.COLL.AWT.AMT = '';
    Y.REP.ELC.VALUE.LST = ''; Y.REP.ELC.VAL.CNT = ''; Y.REP.ELC.VALUE = '';     Y.TOT.REP.ELC.VAL = ''; Y.AVAIL.SCT.REP.AMT = ''; Y.TF.CONT.RAMT = '';
    Y.SCT.CCY.PRV = ''; Y.SCT.CCY.CURR = ''; Y.SCT.CUS.PRV = ''; Y.SCT.CUS.CURR = ''; Y.SCT.JOB.PRV = ''; Y.SCT.JOB.CURR = ''; Y.TF.JOB.NUMBER = '';
    Y.JOB.CUS.ID = ''; Y.LC.AMOUNT = '';   Y.TOT.TF.CONT.RAMT = '';    Y.TF.EXCES.AMT = '';  Y.TF.NT.FO.VAL = '';  Y.TF.BTB.EAMT = ''; Y.TF.PC.EAMT = '';
    LT.AD.BR.CODE = ''
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.SCT,F.SCT)
    EB.DataAccess.Opf(FN.BTB.JR,FN.BTB.JR)
    EB.DataAccess.Opf(FN.CCY,F.CCY)
    EB.DataAccess.Opf(FN.COMPANY,F.COMPANY)
    EB.DataAccess.Opf(FN.BD.LC.AD.CODE,F.BD.LC.AD.CODE)

    APP.NAME = 'LETTER.OF.CREDIT':FM:'COMPANY'
    LOCAL.FIELDS = 'LT.TF.SCONT.ID':VM:'LT.TF.CONT.RAMT':VM:'LT.TF.FULL.REP':VM:'LT.TF.TOT.RAMT':VM:'LT.TF.FRGHT.CHG':VM:'LT.TF.FORGN.CHG':VM:'LT.TF.LAGENTCOM':VM:'LT.TF.NET.FOBVL':VM:'LT.TF.BTB.ENTRT':VM:'LT.TF.BTB.ENTAM':VM:'LT.TF.PC.ENT.RT':VM:'LT.TF.PC.ENT.AM':VM:'LT.TF.JOB.EX.RT':VM:'LT.TF.NW.EX.JOB':VM:'LT.TF.JOB.NUMBR':VM:'LT.TF.JOB.ENCUR':VM:'LT.TF.EXCES.AMT':FM:'LT.AD.BR.CODE'
    EB.Foundation.MapLocalFields(APP.NAME, LOCAL.FIELDS, FLD.POS)
RETURN

********
PROCESS:
********
* find Local Reference field position
    GOSUB GET.LOC.REF.POS
    Y.LC.OPERATION = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOperation)
    Y.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
    Y.LC.LOC.REF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.LC.BEN.CUST.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno)
    Y.LC.CCY = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcCurrency)
    Y.LC.LOC.REF.POS= LC.Contract.LetterOfCredit.TfLcLocalRef
*  Check for LC Beneficiary ID and JOB Customer ID are same or not
    GOSUB CHK.CUS.CONS
    Y.SCT.ID.LST = Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>
    Y.SCT.ID.CNT = DCOUNT(Y.LC.LOC.REF<1,Y.TF.SCONT.ID.POS>,SM)
    FOR I = 1 TO Y.SCT.ID.CNT
        Y.TF.SCONT.ID = FIELD(Y.SCT.ID.LST,SM,I)
        EB.DataAccess.FRead(FN.SCT,Y.TF.SCONT.ID,R.SCT.REC,F.SCT,SCT.ERR)
        IF R.SCT.REC THEN
            !check all validation related to sales contract
            IF V$FUNCTION EQ 'I' THEN
                GOSUB CHK.SCT.REC
            END
            !check for Unauth record delete and update Sales Contract Accordingly
            IF V$FUNCTION EQ 'D' THEN
                GOSUB UPDATE.SCT.AVAIL.NAU.AMT
            END
        END
    NEXT I
    
    IF V$FUNCTION EQ 'I' THEN
* set all new local reference field value
        GOSUB SET.RNEW.LOC.VAL
* calculate Excess Amount BTB & PCECC Entitlement
        GOSUB CALC.EXCES.AMT.BTB.ENT
* set all new local reference field value again finally
        GOSUB SET.RNEW.LOC.VAL
    END
RETURN

*************
CHK.CUS.CONS:
*************
* Check for LC Beneficiary ID and JOB Customer ID are same or not
    Y.TF.JOB.NUMBER =  Y.LC.LOC.REF<1,Y.TF.JOB.NUMBER.POS>
    EB.DataAccess.FRead(FN.BTB.JR,Y.TF.JOB.NUMBER,R.JOB.REC,F.BTB.JR,JR.ERR)
    IF R.JOB.REC THEN
        Y.JOB.CUS.ID = R.JOB.REC<BTB.JOB.CUSTOMER.NO>
        IF Y.LC.BEN.CUST.ID NE '' THEN
            IF Y.LC.BEN.CUST.ID NE Y.JOB.CUS.ID THEN
                EB.SystemTables.setEtext('LC Beneficiary ID and JOB Customer must be equal')
                EB.SystemTables.setAf(Y.LC.LOC.REF.POS)
                EB.SystemTables.setAv(Y.TF.JOB.NUMBER.POS)
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END
        END
    END
RETURN

***********************
CALC.EXCES.AMT.BTB.ENT:
***********************
* set JOB Exchange Rate
    Y.EXCHANGE.RATE = ''
    Y.JOB.CURR = R.JOB.REC<BTB.JOB.JOB.CURRENCY>
    EB.DataAccess.FRead(FN.CCY, Y.LC.CCY, R.ELC.CCY.REC, F.CCY, Y.ELC.CCY.ERR)
    EB.DataAccess.FRead(FN.CCY, Y.JOB.CURR, R.JOB.CCY.REC, F.CCY, Y.JOB.CCY.ERR)
    BEGIN CASE
        CASE Y.LC.CCY EQ Y.JOB.CURR
            Y.EXCHANGE.RATE = '1'
            
        CASE Y.LC.CCY NE Y.JOB.CURR AND Y.LC.CCY EQ LCCY
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.ELC.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.ELC.CCY.EXC.RATE = R.ELC.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.JOB.CCY.EXC.RATE = R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END
            Y.EXCHANGE.RATE = DROUND((Y.ELC.CCY.EXC.RATE / Y.JOB.CCY.EXC.RATE),4)
            
        CASE Y.LC.CCY NE Y.JOB.CURR AND Y.LC.CCY NE LCCY
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.ELC.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.ELC.CCY.EXC.RATE = R.ELC.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END
            Y.CCY.MKT = '1'
            FIND Y.CCY.MKT IN R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurCurrencyMarket> SETTING Y.CCY.MKT.POS1, Y.CCY.MKT.POS2, Y.CCY.MKT.POS3 THEN
                Y.JOB.CCY.EXC.RATE = R.JOB.CCY.REC<ST.CurrencyConfig.Currency.EbCurMidRevalRate, Y.CCY.MKT.POS2>
            END
            Y.EXCHANGE.RATE = DROUND((Y.ELC.CCY.EXC.RATE / Y.JOB.CCY.EXC.RATE),4)
    END CASE
    Y.LC.LOC.REF<1,Y.TF.JB.EX.RTE.POS> = Y.EXCHANGE.RATE

* set JOB CCY
    Y.LC.LOC.REF<1,Y.TF.JOB.CURR.POS> = Y.JOB.CURR
* check Total Replacement Amt it greater than LC Amt
    IF Y.TOT.TF.CONT.RAMT GT Y.LC.AMOUNT THEN
        EB.SystemTables.setEtext('Total Replacement Amt is more than LC Amount')
        EB.SystemTables.setAf(Y.LC.LOC.REF.POS)
        EB.SystemTables.setAv(Y.TF.TOT.RAMT.POS)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    
*to check AD Branch or Nor
    EB.DataAccess.FRead(FN.BD.LC.AD.CODE,EB.SystemTables.getIdCompany(),R.BD.LC.AD.CODE,F.BD.LC.AD.CODE,BD.LC.AD.CODE.ERR)
    IF BD.LC.AD.CODE.ERR THEN
        EB.SystemTables.setE("AD CODE DOES NOT EXIST FOR THIS COMPANY")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        Y.AD.BR.CODE = R.BD.LC.AD.CODE<AD.CODE.AD.CODE>
    END

* set Excess LC Replacement Amt
    IF Y.TOT.TF.CONT.RAMT GT '0' THEN
        IF Y.LC.AMOUNT GT Y.TOT.TF.CONT.RAMT THEN
            Y.TF.EXCES.AMT = Y.LC.AMOUNT - Y.TOT.TF.CONT.RAMT
            Y.LC.LOC.REF<1,Y.TF.EXCES.AMT.POS> = Y.TF.EXCES.AMT
        END ELSE
            Y.LC.LOC.REF<1,Y.TF.EXCES.AMT.POS> = '0'
        END
    END
    
* Calculate Net FOB Value on Excess Replacement Amt
    Y.TF.FRGHT.CHG = Y.LC.LOC.REF<1,Y.TF.FRGHT.CHG.POS>
    Y.TF.FORGH.CHG = Y.LC.LOC.REF<1,Y.TF.FORGH.CHG.POS>
    Y.TF.LOC.AGT.CM = Y.LC.LOC.REF<1,Y.TF.LC.AGT.CM.POS>
    Y.TOT.CHG = Y.TF.FRGHT.CHG + Y.TF.FORGH.CHG + Y.TF.LOC.AGT.CM
    Y.TF.NT.FO.VAL = Y.TF.EXCES.AMT - Y.TOT.CHG
    IF Y.TF.EXCES.AMT GT Y.TOT.CHG THEN
        Y.LC.LOC.REF<1,Y.TF.NT.FO.VAL.POS> = Y.TF.NT.FO.VAL
    END ELSE
        Y.LC.LOC.REF<1,Y.TF.NT.FO.VAL.POS> = '0'
        Y.TF.NT.FO.VAL = '0'
    END
*
    IF OFS$BROWSER AND OFS$OPERATION EQ 'PROCESS' THEN
        IF Y.TF.NT.FO.VAL LE '0' THEN
            EB.SystemTables.setText('No Available FOB Value for Entitlement Calculation')
            Y.OVERRIDE.NO = DCOUNT(EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride),VM)
            Y.OVERRIDE.NO +=1
            EB.OverrideProcessing.StoreOverride(Y.OVERRIDE.NO)
        END
    END
* Calculate BTB & PCECC Entitlement Amt on Excess LC Amount
    Y.TF.BTB.ERATE = Y.LC.LOC.REF<1,Y.TF.BTB.ERATE.POS>
    Y.TF.PC.ERATE = Y.LC.LOC.REF<1,Y.TF.PC.ERATE.POS>
    Y.TOT.ERATE = Y.TF.BTB.ERATE + Y.TF.PC.ERATE
    IF Y.TOT.ERATE GT '100' THEN
        EB.SystemTables.setEtext('Total Rate of Entitlement Cannot Exceed 100')
        EB.SystemTables.setAf(Y.LC.LOC.REF.POS)
        EB.SystemTables.setAv(Y.TF.BTB.ERATE.POS)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END ELSE
        Y.TF.BTB.EAMT = (Y.TF.NT.FO.VAL * Y.TF.BTB.ERATE)/100
        Y.LC.LOC.REF<1,Y.TF.BTB.EAMT.POS> = Y.TF.BTB.EAMT
        Y.TF.PC.EAMT = (Y.TF.NT.FO.VAL * Y.TF.PC.ERATE)/100
        Y.LC.LOC.REF<1,Y.TF.PC.EAMT.POS> = Y.TF.PC.EAMT
    END
RETURN

*****************
SET.RNEW.LOC.VAL:
*****************
* set all new local reference field value
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef,Y.LC.LOC.REF)
RETURN

*************
CHK.SCT.REC:
*************
* Check for JOB Customer ID and SC Customer ID are same or not
    Y.SCT.BEN.CUST.ID = R.SCT.REC<SCT.BENEFICIARY.CUSTNO>
    IF Y.SCT.BEN.CUST.ID NE Y.JOB.CUS.ID THEN
        EB.SystemTables.setEtext('JOB Customer ID and Sales Contract Customer must be equal')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END

* LC CCY and Sales Contract CCY must be same
    Y.SCT.CCY = R.SCT.REC<SCT.CURRENCY>
    IF Y.LC.CCY NE Y.SCT.CCY THEN
        EB.SystemTables.setEtext('LC Currency and Contract Currency must be Same')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END

* LC JOB ID and Sales Contract JOB ID must be Same
    Y.SCT.JOB = R.SCT.REC<SCT.BTB.JOB.NO>
    IF Y.SCT.JOB NE Y.TF.JOB.NUMBER THEN
        EB.SystemTables.setEtext('Contract JOB and LC JOB are not same')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END
    
* Check for SC Replacement allowed or not
    Y.SCT.REP.ALLOW.YN = R.SCT.REC<SCT.REPLACE.ALLOW.YN>
    IF Y.SCT.REP.ALLOW.YN EQ 'NO' THEN
        EB.SystemTables.setEtext('Contract Replacement not Allowed')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END

* Check for SC fully replaced or not
    Y.SCT.FULLY.REP.YN = R.SCT.REC<SCT.FULLY.REPLACE.YN>
    IF Y.SCT.FULLY.REP.YN EQ 'YES' THEN
        EB.SystemTables.setEtext('Contract Fully Replaced')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END

* Check for Contract replacement amount available or not and Update accordingly
    Y.SCT.AVAIL.AMT = R.SCT.REC<SCT.CONTRACT.AVAIL.AMT>
    Y.FULL.REP.MARK = Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I>
    Y.TF.CONT.RAMT = Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I>
    
    BEGIN CASE
        CASE Y.SCT.AVAIL.AMT LE '0'
            EB.SystemTables.setEtext('No Available Amount for Contract Replacement')
            GOSUB SET.REP.AMT.FIELD.POS
            RETURN

        CASE Y.SCT.AVAIL.AMT GT '0' AND Y.FULL.REP.MARK EQ 'YES'
            IF Y.TF.CONT.RAMT NE '' THEN
                IF Y.TF.CONT.RAMT NE Y.SCT.AVAIL.AMT THEN
                    EB.SystemTables.setEtext("Fully Replace Marked as 'YES'.Replace Amt must be Equal to Available Amt")
                    GOSUB SET.REP.AMT.FIELD.POS
                    RETURN
                END
            END ELSE
                Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I> = Y.SCT.AVAIL.AMT
            END

        CASE Y.SCT.AVAIL.AMT GT '0' AND Y.FULL.REP.MARK EQ 'NO'
            IF (Y.TF.CONT.RAMT GE Y.SCT.AVAIL.AMT OR Y.TF.CONT.RAMT LE '0' OR Y.TF.CONT.RAMT EQ '') THEN
                EB.SystemTables.setEtext("Fully Replace Marked as 'NO'.Replace Amt must be GT zero and LT Available Amt")
                GOSUB SET.REP.AMT.FIELD.POS
                RETURN
            END

        CASE Y.SCT.AVAIL.AMT GT '0' AND Y.FULL.REP.MARK EQ ''
            IF Y.TF.CONT.RAMT NE '' THEN
                IF (Y.TF.CONT.RAMT GT Y.SCT.AVAIL.AMT  OR Y.TF.CONT.RAMT LE '0') THEN
                    EB.SystemTables.setEtext('Replace Amt must be GT zero and LE Available Amt')
                    GOSUB SET.REP.AMT.FIELD.POS
                    RETURN
                END
                IF Y.TF.CONT.RAMT EQ Y.SCT.AVAIL.AMT THEN
                    Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I> = 'YES'
                END
                IF Y.TF.CONT.RAMT LT Y.SCT.AVAIL.AMT THEN
                    Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I> = 'NO'
                END
            END ELSE
****************************Modification 12/20/2020******************************************
                IF Y.LC.AMOUNT GE Y.SCT.AVAIL.AMT THEN
                    Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I> = Y.SCT.AVAIL.AMT ;*before modification line
                    Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I> = 'YES';*before modification line
                END
                ELSE
                    Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I> = Y.LC.AMOUNT
                    Y.LC.LOC.REF<1,Y.TF.FULL.REP.POS,I> = 'NO'
                END
****************************Modification 12/20/2020 End******************************************
            END
    END CASE
    
* Assign total Contract Replacemet Amt to respective field
    Y.TOT.TF.CONT.RAMT = Y.TOT.TF.CONT.RAMT + Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I>
    Y.LC.LOC.REF<1,Y.TF.TOT.RAMT.POS> = Y.TOT.TF.CONT.RAMT
    
* to check duplicate Sales contract ID in the replacement screen
    Y.DUP.SCNT.CNT = DCOUNT(Y.SCT.ID.LST,Y.TF.SCONT.ID)
    IF Y.DUP.SCNT.CNT GE '3' THEN
        EB.SystemTables.setEtext('Duplicate Sales Contract')
        GOSUB SET.SCONT.ID.FIELD.POS
        RETURN
    END

    IF OFS$BROWSER AND OFS$OPERATION EQ 'PROCESS' THEN
* Check for Sales Contract Already Expired or not
        Y.SCT.EXP.DT = R.SCT.REC<SCT.EXPIRY.DATE>
        IF Y.SCT.EXP.DT LT TODAY THEN
            EB.SystemTables.setText('Sales Contract ':Y.TF.SCONT.ID:' is Expired')
            Y.OVERRIDE.NO = DCOUNT(EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride),VM)
            Y.OVERRIDE.NO +=1
            EB.OverrideProcessing.StoreOverride(Y.OVERRIDE.NO)
        END
    END

RETURN

*************************
UPDATE.SCT.AVAIL.NAU.AMT:
*************************
*update each Sales Contract record if unauth record processed for delete
* Operation not allowed other than 'O'
    IF Y.LC.OPERATION NE 'O' THEN
        EB.SystemTables.setEtext('LC Operation Type must be O')
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcOperation)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

    Y.SCT.CONT.AMT.NAU = R.SCT.REC<SCT.CONTRACT.AMT.NAU>
    Y.SCT.AVAIL.AMT = R.SCT.REC<SCT.CONTRACT.AVAIL.AMT>
    Y.TF.CONT.RAMT = Y.LC.LOC.REF<1,Y.TF.CONT.RAMT.POS,I>
    R.SCT.REC<SCT.CONTRACT.AVAIL.AMT> = Y.SCT.AVAIL.AMT + Y.TF.CONT.RAMT
    R.SCT.REC<SCT.CONTRACT.AMT.NAU> = Y.SCT.CONT.AMT.NAU - Y.TF.CONT.RAMT
    WRITE R.SCT.REC ON F.SCT,Y.TF.SCONT.ID
RETURN

**********************
SET.REP.AMT.FIELD.POS:
**********************
    EB.SystemTables.setAf(Y.LC.LOC.REF.POS)
    EB.SystemTables.setAv(Y.TF.CONT.RAMT.POS)
    EB.SystemTables.setAs(I)
    EB.ErrorProcessing.StoreEndError()
RETURN

***********************
SET.SCONT.ID.FIELD.POS:
***********************
    EB.SystemTables.setAf(Y.LC.LOC.REF.POS)
    EB.SystemTables.setAv(Y.TF.SCONT.ID.POS)
    EB.SystemTables.setAs(I)
    EB.ErrorProcessing.StoreEndError()
RETURN
    
****************
GET.LOC.REF.POS:
****************
    Y.TF.SCONT.ID.POS = FLD.POS<1,1>
    Y.TF.CONT.RAMT.POS = FLD.POS<1,2>
    Y.TF.FULL.REP.POS = FLD.POS<1,3>
    Y.TF.TOT.RAMT.POS = FLD.POS<1,4>
    Y.TF.FRGHT.CHG.POS = FLD.POS<1,5>
    Y.TF.FORGH.CHG.POS = FLD.POS<1,6>
    Y.TF.LC.AGT.CM.POS = FLD.POS<1,7>
    Y.TF.NT.FO.VAL.POS = FLD.POS<1,8>
    Y.TF.BTB.ERATE.POS = FLD.POS<1,9>
    Y.TF.BTB.EAMT.POS = FLD.POS<1,10>
    Y.TF.PC.ERATE.POS = FLD.POS<1,11>
    Y.TF.PC.EAMT.POS = FLD.POS<1,12>
    Y.TF.JB.EX.RTE.POS = FLD.POS<1,13>
    Y.TF.NW.EX.JBN.POS = FLD.POS<1,14>
    Y.TF.JOB.NUMBER.POS = FLD.POS<1,15>
    Y.TF.JOB.CURR.POS = FLD.POS<1,16>
    Y.TF.EXCES.AMT.POS = FLD.POS<1,17>
    Y.LT.AD.BR.CODE.POS = FLD.POS<2,1>
RETURN
END
