SUBROUTINE TF.JBL.V.JBL.EXPIRY.DATE
*-----------------------------------------------------------------------------
*Subroutine Description: LC Expiry Date Validation
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.Utility
    $USING EB.API
    $USING EB.SystemTables
    $USING EB.Display
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
        EB.API.Cdt('',Y.EXP.DATE,'+15C')
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcExpiryDate,Y.EXP.DATE)
    END
RETURN
*** </region>
END
