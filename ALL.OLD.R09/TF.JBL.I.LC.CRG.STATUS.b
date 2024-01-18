SUBROUTINE TF.JBL.I.LC.CRG.STATUS
*Subroutine Description:
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMP.CHARGES)
*Attached As    : INPUT ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING EB.ErrorProcessing
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables

    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC = ''

    Y.LC.ID = ''
   
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LC.ID= EB.SystemTables.getIdNew()

    IF Y.LC.ID THEN
        LC.CRG.STS = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcChargeStatus)
        LC.CRG.ACCT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcChargeAcct)


        IF LC.CRG.STS NE "" THEN
            IF LC.CRG.STS NE '3' THEN
                IF LC.CRG.ACCT EQ "" THEN
                    EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcChargeAcct)
                    EB.SystemTables.setEtext('CHARGE ACCOUNT MANDATORY')
                
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END

    END
RETURN
*** </region>
END
