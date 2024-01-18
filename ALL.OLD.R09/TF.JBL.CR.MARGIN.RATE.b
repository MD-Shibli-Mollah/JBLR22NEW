SUBROUTINE TF.JBL.CR.MARGIN.RATE
*-----------------------------------------------------------------------------
*Subroutine Description: This check record routine is attached with LETTER.OF.CREDIT,BD.SHIPPMGNTAK version which will calculate the total margin percentage and populated in local ref field LC.MARGIN.RATE.
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH)
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING ST.CurrencyConfig
    $INSERT I_GTS.COMMON
    
    $USING EB.Updates
    $USING EB.DataAccess
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
    FN.CURRENCY = 'F.CURRENCY'
    F.CURRENCY = ''

    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT = ''

    Y.LC.ID = EB.SystemTables.getIdNew()
    R.LC.REC = ''
    Y.LC.ERR = ''
    Y.LCCY = EB.SystemTables.getLccy()

    Y.LC.MARGIN.RATE = ''

    Y.APP = 'LETTER.OF.CREDIT'
    Y.FLD = 'LT.TF.LC.MGN.RT'
    Y.POS = ''

    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)
    Y.LC.MARGIN.RATE.POS = Y.POS<1,1>
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.CURRENCY,F.CURRENCY)
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LC.REC,F.LETTER.OF.CREDIT,Y.LC.ERR)
    IF R.LC.REC THEN
        Y.LC.CURRENCY = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcCurrency>
        Y.LC.AMOUNT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcAmount>
        Y.LC.ORIG.RATE = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLcOrigRate>
        Y.PRO.OS.AMT = R.LC.REC<LC.Contract.LetterOfCredit.TfLcProOsAmt>
        Y.LOCAL.AMT = Y.LC.AMOUNT * Y.LC.ORIG.RATE
        Y.MARGIN = (Y.PRO.OS.AMT * 100) / Y.LOCAL.AMT
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
        Y.TEMP<1,Y.LC.MARGIN.RATE.POS> = Y.MARGIN
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
    END
RETURN
*** </region>
END
