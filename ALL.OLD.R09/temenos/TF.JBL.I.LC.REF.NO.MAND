SUBROUTINE TF.JBL.I.LC.REF.NO.MAND
*-----------------------------------------------------------------------------
*Subroutine Description: LC referance mark check for margin
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
    REF.NO= ''
    Y.APP="LETTER.OF.CREDIT"
    Y.FLDS="LT.TF.LC.LINMRK":VM:"LT.TF.LC.LINREF"
    Y.POS= ''
    
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLDS,Y.POS)
    Y.LIN.MRK =Y.POS<1,1>
    Y.REF.NO = Y.POS<1,2>
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
        LIN.MRK = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.LIN.MRK>
        REF.NO = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.REF.NO>


        IF LIN.MRK EQ "YES" THEN
            IF REF.NO EQ '' THEN
                EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLocalRef)
                EB.SystemTables.setAv(Y.REF.NO)
                EB.SystemTables.setEtext('LC-REF.NO.MUST')
                
                EB.ErrorProcessing.StoreEndError()
            END
        END

    END
RETURN
*** </region>
END
