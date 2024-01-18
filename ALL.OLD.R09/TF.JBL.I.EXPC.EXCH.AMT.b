SUBROUTINE TF.JBL.I.EXPC.EXCH.AMT
*-----------------------------------------------------------------------------
*Subroutine Description: term.amount calculation from Account property data for Packing Credit Loan
*Subroutine Type:
*Attached To    : JBL.TF.PC.OPEN.API-19990601 (property TERM.AMOUNT)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/04/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $USING LD.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING AA.Account
    $USING AA.LendingData
    $USING AA.TermAmount
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.DOC.VL.FC",Y.PC.FCVAL.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.EXCH.RATE",Y.RATE.POS)
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT',"LT.TF.JOB.ENTAM",Y.LD.PC.ENT.AMT.POS)
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

    Y.LD.FC.AMT = FIELD(TMP.DATA,SM,Y.PC.FCVAL.POS)
    Y.EXCH.RATE = FIELD(TMP.DATA,SM,Y.RATE.POS)
    Y.JOB.PC.ENT.AMT = FIELD(TMP.DATA,SM,Y.LD.PC.ENT.AMT.POS)

    
    IF Y.LD.FC.AMT GT Y.JOB.PC.ENT.AMT THEN
        Y.PC.DIFF = Y.LD.FC.AMT - Y.JOB.PC.ENT.AMT
        EB.SystemTables.setAv(Y.PC.FCVAL.POS)
        EB.SystemTables.setEtext("PC Disburse Amt Exceeds Job PC Entitle Amt":Y.PC.DIFF)
        EB.ErrorProcessing.StoreEndError()
    END ELSE
        IF Y.EXCH.RATE LE "0" THEN
            Y.PC.AMT = Y.LD.FC.AMT * 1
        END ELSE
            Y.PC.AMT = Y.LD.FC.AMT * Y.EXCH.RATE
        END
        EB.API.RoundAmount('LCCY',Y.PC.AMT,'2','')

        EB.SystemTables.setRNew(AA.TermAmount.TermAmount.AmtAmount, Y.PC.AMT)
    END

   
RETURN
*** </region>



END

