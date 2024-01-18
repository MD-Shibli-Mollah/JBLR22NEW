SUBROUTINE TF.JBL.I.LC.IRC.CHECK
*-----------------------------------------------------------------------------
*Subroutine Description: IRC validation for LC
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
    $USING EB.LocalReferences
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.OverrideProcessing
    $USING LC.Config
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC.TYPE = "F.LC.TYPES"
    F.LC.TYPE = ""
    
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.IRC.LIMIT",LIMIT.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.IRC.EXP.DAT",EXP.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.AVL.LIMIT",AVL.AMT.POS)
    EB.LocalReferences.GetLocRef("LC.TYPES","LT.LCTP.LOC.FRG",Y.LCTYPE.LOC.POS)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC.TYPE, F.LC.TYPE)
RETURN
*** </region>
*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.LIMIT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,LIMIT.POS>
    Y.EXP.DATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,EXP.POS>
    Y.AVL.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,AVL.AMT.POS>
    
*    Y.CUS.ID = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcApplicantCustno)
*    EB.DataAccess.FRead(FN.CUS, Y.CUS.ID, R.CUS, F.CUS, E.CUS)
*
*    EB.LocalReferences.GetLocRef("CUSTOMER","LT.TF.AVL.LIMIT",AVL.AMT.POS)
*    Y.AVL.AMT = R.CUS<ST.Customer.Customer.EbCusLocalRef ,AVL.AMT.POS>
    Y.LC.TYPE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcType)
    EB.DataAccess.FRead(FN.LC.TYPE,Y.LC.TYPE,R.LC.TYPE,F.LC.TYPE,Y.LC.ERR)
    IF R.LC.TYPE THEN
        Y.LOC.FOR = R.LC.TYPE<LC.Config.Types.TypLocalRef,Y.LCTYPE.LOC.POS>
        IF Y.LOC.FOR EQ 'LOCAL' THEN RETURN
    END
    

    IF Y.EXP.DATE LT EB.SystemTables.getToday() THEN
        IF Y.AVL.AMT GT 0 THEN
            EB.SystemTables.setText("IRC Validity expired. check IRC availed Amt is initialized or not for this FY")
            GOSUB TRIGGER.OVERRIDE
            RETURN
        END ELSE
            EB.SystemTables.setText("IRC Validity expired")
            GOSUB TRIGGER.OVERRIDE
            RETURN
        END
    END
 
    BEGIN CASE
        CASE Y.LIMIT EQ ""
            EB.SystemTables.setText("IRC Limit not define for the applicant")
            GOSUB TRIGGER.OVERRIDE
        CASE Y.LIMIT LT 0
            EB.SystemTables.setText("IRC Limit not define for the applicant")
            GOSUB TRIGGER.OVERRIDE
        CASE Y.LIMIT EQ 0
            EB.SystemTables.setText("Amount reached the Limit ")
            GOSUB TRIGGER.OVERRIDE
    END CASE
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= TRIGGER.OVERRIDE>
TRIGGER.OVERRIDE:
*** <desc>TRIGGER OVERRIDE </desc>
    Y.OVERRIDES = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcOverride)
    OVERRIDE.NO = DCOUNT(Y.OVERRIDES,VM)
    OVERRIDE.NO += 1
    EB.OverrideProcessing.StoreOverride(OVERRIDE.NO)
RETURN
*** </region>
END
