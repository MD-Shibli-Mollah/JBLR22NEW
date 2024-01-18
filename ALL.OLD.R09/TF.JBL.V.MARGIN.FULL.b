SUBROUTINE TF.JBL.V.MARGIN.FULL
*-----------------------------------------------------------------------------
*Subroutine Description: Update Margin Rate Field Valu from Margin Status
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT,JBL.IMPSIGHT
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 25/03/2020 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.APP.COMMON
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING AA.Account
    $USING LD.Contract
    $USING EB.LocalReferences
    $USING EB.API
    $USING LC.Contract
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.LC.MGN.RT',Y.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.MARGING.STS = EB.SystemTables.getComi()
    
    IF Y.MARGING.STS EQ "FULL" THEN
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.POS> = "100"
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
RETURN
*** </region>

END