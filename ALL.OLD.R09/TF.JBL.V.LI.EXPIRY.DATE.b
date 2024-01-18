SUBROUTINE TF.JBL.V.LI.EXPIRY.DATE
*-----------------------------------------------------------------------------
*Subroutine Description: Expiry Date Validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBUSANCE)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 07/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.Utility
    $USING EB.API
    $USING EB.Display
    
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getComi() EQ "" THEN RETURN
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.EXP.DATE = EB.SystemTables.getComi()
    Y.REV.EXP.DATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate)

    IF Y.EXP.DATE NE "" AND Y.REV.EXP.DATE EQ "" THEN
        EB.API.Cdt('',Y.EXP.DATE,'+25C')
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate,Y.EXP.DATE)
    END

    
RETURN
*** </region>
END
