SUBROUTINE TF.JBL.I.LC.IRC.AMOUNT.OVER
*-----------------------------------------------------------------------------
*Subroutine Description: IRC amount limit check for LC.
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
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.OverrideProcessing
    $USING ST.Config
    $USING EB.LocalReferences
    $USING LC.Config
*-----------------------------------------------------------------------------
     
    IF EB.SystemTables.getVFunction() NE 'I' THEN RETURN
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC= ''
    Y.LC.AMOUNT = ''
    R.LC =''
    LC.ERR=''

    Y.APP = "LETTER.OF.CREDIT"
    Y.FLD = "LT.TF.AVL.LIMIT"
    Y.POS = ''
    
    FN.LC.TYPE = "F.LC.TYPES"
    F.LC.TYPE = ""

    Y.LC.ID = ''
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.AVL.LIMIT",Y.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.IRC.LIMIT",Y.IRC.LIMIT.POS)
    EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LOC.FRG",Y.LCTYPE.LOC.POS)
*    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.LC.TYPE, F.LC.TYPE)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LC.ID  = EB.SystemTables.getIdNew()
    Y.LC.TYPE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcType)
    EB.DataAccess.FRead(FN.LC.TYPE,Y.LC.TYPE,R.LC.TYPE,F.LC.TYPE,Y.LC.ERR)
    IF R.LC.TYPE THEN
        Y.LOC.FOR = R.LC.TYPE<LC.Config.Types.TypLocalRef,Y.LCTYPE.LOC.POS>
        IF Y.LOC.FOR EQ 'LOCAL' THEN RETURN
    END

    IF Y.LC.ID THEN
        Y.LC.AMOUNT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcAmount)
        Y.EX.RT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcOrigRate)
        Y.LC.AMOUNT *= Y.EX.RT
        Y.LC.AVAIL.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.POS>
        Y.LC.IRC.LIMIT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,Y.IRC.LIMIT.POS>
        Y.TOT.AVL.AMT = Y.LC.AMOUNT + Y.LC.AVAIL.AMT

        IF Y.TOT.AVL.AMT GT Y.LC.IRC.LIMIT THEN
            Y.EXCEED.AMT = Y.TOT.AVL.AMT - Y.LC.IRC.LIMIT
*            Y.EXCEED.AMT /= Y.EX.RT
            EB.SystemTables.setText("Total availed limit with LC amount exceed IRC limit by :": DROUND(Y.EXCEED.AMT,2))
*            EB.SystemTables.setText("IRC Limit Availed with LC Amout is exceed IRC Limit amount")
*            EB.SystemTables.setText("IRC Limit amount is greater than IRC Availed amount")
            GOSUB TRIGGER.OVERRIDE
        END
    END
RETURN
*** </region>

*** <region name= TRIGGER.OVERRIDE>
TRIGGER.OVERRIDE:
*** <desc>TRIGGER OVERRIDE</desc>
    Y.OVERRIDES = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
    OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
    OVERRIDE.NO += 1
    EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
RETURN
*** </region>

END
