SUBROUTINE TF.JBL.CR.LC.OUTSTANDING.AMT
*-----------------------------------------------------------------------------
*Subroutine Description:    This is the validation routine attached with OPERATION field which will calculate
*                           LC Oustanding amount after deducting summation of all the transfered amount if any
*                           from actual LC amount and populate in LCAMT.OUTSTAND field if OPERATION is "A".
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.BTBRECORD)
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/11/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    
    $USING EB.DataAccess
*$USING EB.LocalReferences
    $USING EB.Updates
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT = ''
    
    Y.APP = 'LETTER.OF.CREDIT'
    Y.FLD = 'LT.TF.LC.OUSAMT'
    Y.POS = ''
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)

    Y.LCAMT.OUTSTAND.POS = Y.POS<1,1>
    Y.OPERATION = EB.SystemTables.getComi()
    Y.LC.ID = EB.SystemTables.getIdNew()
    R.LC.REC = ''
    Y.LC.ERR = ''
    Y.LC.TRF.NO = ''
    Y.LC.TRF.AMT = ''
    Y.LC.TOTAL.TRF.AMT = ''
    Y.LC.TRF.AMT.CNT = ''
    Y.LC.AMT = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    !IF Y.OPERATION EQ 'A' THEN
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LC.REC,F.LETTER.OF.CREDIT,Y.LC.ERR)
    IF R.LC.REC THEN
        Y.LC.AMT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.LC.TRF.AMT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcTranPortAmt>
        Y.LC.TRF.AMT.CNT = DCOUNT(Y.LC.TRF.AMT,VM)
    
        IF Y.LC.TRF.AMT.CNT GT 1 THEN
            GOSUB GET.TRF.LC.AMT
        END ELSE
            IF Y.LC.TRF.AMT.CNT EQ 1 THEN
                Y.LC.TRF.TOTAL.AMT = Y.LC.TRF.AMT
            END
        END
    
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.LCAMT.OUTSTAND.POS> = Y.LC.AMT - Y.LC.TRF.TOTAL.AMT
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
RETURN
*** </region>

*** <region name= GET.TRF.LC.AMT>
GET.TRF.LC.AMT:
*** <desc>GET.TRF.LC.AMT </desc>
* This section is to add all the transfered LC amount
    FOR I = 1 TO Y.LC.TRF.AMT.CNT
        Y.LC.TRF.TOTAL.AMT += Y.LC.TRF.AMT<1,I>
    NEXT I
RETURN
*** </region>
END
