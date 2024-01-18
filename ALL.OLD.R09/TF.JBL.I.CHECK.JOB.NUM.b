SUBROUTINE TF.JBL.I.CHECK.JOB.NUM
*-----------------------------------------------------------------------------
*Subroutine Description: job check for customer
*Subroutine Type:
*Attached To    :
*Attached As    : activity api pre routine
*-----------------------------------------------------------------------------
* Modification History :
* 25/10/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING AA.Framework
    $USING EB.API
    $USING AA.Account
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT","LT.TF.JOB.NUMBR",Y.JOB.NO.POS)
RETURN
*** </region>


*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    Y.AA.REC = AA.Framework.Arrangement.Read(Y.ARR.ID, E.AA)
    Y.CUS.ID = Y.AA.REC<AA.Framework.Arrangement.ArrCustomer>
    
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    Y.JOB.NUM = FIELD(TMP.DATA,SM, Y.JOB.NO.POS)
    IF Y.JOB.NUM NE "" THEN
        Y.JOB.CUS.ID = FIELD(Y.JOB.NUM,'.',2)
        IF Y.JOB.CUS.ID NE Y.CUS.ID THEN
            EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
            EB.SystemTables.setAv(Y.JOB.NO.POS)
            EB.SystemTables.setEtext("This JOB not belongs to the customer")
        END
    END
RETURN
*** </region>
END
