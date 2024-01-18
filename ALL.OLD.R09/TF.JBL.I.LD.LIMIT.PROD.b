SUBROUTINE TF.JBL.I.LD.LIMIT.PROD
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version   Activity.Api - JBL.TF.LTR.API
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 14/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
* 12/17/2020 -                            Retrofit   - MAHMUDUR RAHMAN,
* Modified line - 71 Limit Reference and Loan Type mismatch then error shows.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AA.Account
    $USING AA.Limit
    $USING AA.Framework
    $USING EB.ErrorProcessing
    $USING EB.LocalReferences
    $USING EB.API
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef('AA.ARR.ACCOUNT','LT.AC.BD.LMTPRD',Y.LIMIT.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.ARR.ID = AA.Framework.getC_aalocarrid()
    
    
    APP.NAME = 'AA.ARR.ACCOUNT'
    EB.API.GetStandardSelectionDets(APP.NAME, R.SS)
    Y.FIELD.NAME = 'LOCAL.REF'
    LOCATE Y.FIELD.NAME IN R.SS<AA.Account.Account.AcLocalRef> SETTING Y.POS THEN
    END
    CALL AA.GET.ACCOUNT.RECORD(R.PROPERTY.RECORD, PROPERTY.ID)
    TMP.DATA = R.PROPERTY.RECORD<1,Y.POS>
    Y.BD.LIMIT.PROD = FIELD(TMP.DATA,SM, Y.LIMIT.POS)
     

    PROP.CLASS = 'LIMIT'
    AA.Framework.GetArrangementConditions(Y.ARR.ID,PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    AC.R.REC = RAISE(RETURN.VALUES)
    Y.LIMIT.REFEREMNCE = AC.R.REC<AA.Limit.Limit.LimLimitReference>
    Y.LIMIT.REFEREMNCE1=FIELD(Y.LIMIT.REFEREMNCE,'.',1)
     
    IF Y.BD.LIMIT.PROD NE '' AND Y.LIMIT.REFEREMNCE1 NE Y.BD.LIMIT.PROD THEN
        EB.SystemTables.setAf(AA.Account.Account.AcLocalRef)
        EB.SystemTables.setAv(Y.LIMIT.POS)
        EB.SystemTables.setEtext("Limit Reference and Loan Type mismatch")
        EB.ErrorProcessing.StoreEndError()
    END
RETURN
*** </region>


END
