SUBROUTINE TF.JBL.V.AMORT.CHARGES
*-----------------------------------------------------------------------------
*Subroutine Description: Validate Charge
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Versions for charge : DRAWINGS,JBL.BTBAC
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 12/09/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING LC.Contract
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.COMY = EB.SystemTables.getComi()
    Y.CHARGE.CODE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcChargeCode)
    IF Y.CHARGE.CODE NE "" AND  Y.COMY EQ "" THEN
        EB.SystemTables.setComi("NO")
    END
RETURN
*** </region>

END
