SUBROUTINE TF.JBL.I.LD.EXP.DOC.PUR.PERC
*-----------------------------------------------------------------------------
*Subroutine Description: Pur check
*Subroutine Type:
*Attached To    : ACTIVITY API
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/04/2020 -                            Created   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Account
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.LN.PUR.PCT",Y.PUR.PCT.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.LN.BIL.DOCVL",Y.BILL.POS)
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.LN.PUR.FCAMT",Y.FCY.POS)
*
    Y.BILL.AMT=''
    Y.PER.AMT=''
    Y.AMT.CAL=''
    
RETURN
*** </region>



*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    Y.PUR.PCT = FIELD(TMP.DATA,SM, Y.PUR.PCT.POS)
    Y.BILL.CCY.AMT = FIELD(TMP.DATA,SM, Y.BILL.POS)
    Y.BILL.AMT = Y.BILL.CCY.AMT[4,LEN(Y.BILL.CCY.AMT)]
    Y.CCY = Y.BILL.CCY.AMT[1,3]
    Y.PER.AMT= Y.PUR.PCT/100
    Y.AMT.CAL = DROUND(Y.BILL.AMT * Y.PER.AMT,2)
    
    IF Y.PUR.PCT LE 0 OR Y.PUR.PCT GT 100 THEN
        EB.SystemTables.setEtext("Percentage Should be 1-100")
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        Y.TEMP = EB.SystemTables.getRNew(AA.Account.Account.AcLocalRef)
        Y.TEMP<1,Y.FCY.POS> = Y.CCY : Y.AMT.CAL
        EB.SystemTables.setRNew(AA.Account.Account.AcLocalRef, Y.TEMP)
    END
RETURN
*** </region>
END
