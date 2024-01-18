SUBROUTINE TF.JBL.I.OVER.TO.ERROR
*-----------------------------------------------------------------------------
*Subroutine Description: excess limit override to error
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT,JBL.BTB.AMD.JOB , LETTER.OF.CREDIT,JBL.BTBAMDEXT , LETTER.OF.CREDIT,JBL.BTBAMDINT , LETTER.OF.CREDIT,JBL.BTBSIGHT
* LETTER.OF.CREDIT,JBL.BTBUSANCE , LETTER.OF.CREDIT,JBL.EDFOPEN , LETTER.OF.CREDIT,JBL.IMAMDEXT , LETTER.OF.CREDIT,JBL.IMAMDINT , LETTER.OF.CREDIT,JBL.IMPMGNREL
*   LETTER.OF.CREDIT,JBL.IMPMXPMT , LETTER.OF.CREDIT,JBL.IMPSIGHT , LETTER.OF.CREDIT,JBL.IMPUSANCE
*Attached As    :
*-----------------------------------------------------------------------------
* Modification History :
* 14/10/2020 -                            Create   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.OverrideProcessing
    $USING EB.LocalReferences
    $USING LC.Contract
*-----------------------------------------------------------------------------
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.OVR = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
    CONVERT SM TO VM IN Y.OVR
    CONVERT FM TO VM IN Y.OVR
    Y.COUNT = DCOUNT(Y.OVR,@VM)
    FOR I=1 TO Y.COUNT
        Y.PART = FIELD(Y.OVR,@VM,I)
        Y.S.PART = FIELD(Y.PART,'}',1)
        IF Y.S.PART EQ 'EXCESS.ID' THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLimitReference)
            EB.SystemTables.setEtext("Execss Over Limit is not Allowed")
            EB.ErrorProcessing.StoreEndError()
        END
        IF Y.S.PART EQ 'NO.LINE' THEN
            EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLimitReference)
            EB.SystemTables.setEtext("NO LINE ALLOCATED")
            EB.ErrorProcessing.StoreEndError()
        END
    NEXT

RETURN
*** </region>
END