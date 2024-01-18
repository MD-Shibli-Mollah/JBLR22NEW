SUBROUTINE TF.JBL.I.LC.REF.NO.REQ
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (ETTER.OF.CREDIT,JBL.IMPSIGHT)
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
    R.LC = ''
    Y.CR.REF.NO= ''
    Y.APP="LETTER.OF.CREDIT"
    Y.FLDS="LT.TF.EX.CR.REP":VM:"LT.TF.EX.CRRPNO"
    Y.POS= ''
    
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.EX.CR.REP.POS =Y.POS<1,1>
    Y.CR.REF.NO.POS = Y.POS<1,2>
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
*    CALL F.READ(FN.LC,Y.LC.ID,R.LC,F.LC,LC.ERR)
    IF Y.LC.ID THEN
        Y.EX.CR.REP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.EX.CR.REP.POS>
        Y.CR.REF.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.CR.REF.NO.POS>


        IF Y.EX.CR.REP EQ "YES" THEN
            IF Y.CR.REF.NO EQ '' THEN
                EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
                EB.SystemTables.setAv(Y.CR.REF.NO.POS)
                EB.SystemTables.setEtext('Credit.Ref.No not be null')
                
                EB.ErrorProcessing.StoreEndError()
            END
        END

    END
RETURN
*** </region>
END


