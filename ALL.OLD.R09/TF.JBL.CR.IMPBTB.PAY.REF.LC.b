SUBROUTINE TF.JBL.CR.IMPBTB.PAY.REF.LC
*-----------------------------------------------------------------------------
*Subroutine Description: Set LC External Reference from drawings by LC's old number
*Subroutine Type:
*Attached To    : DRAWINGS,JBL.BTBMAT , DRAWINGS,JBL.BTBSP , DRAWINGS,JBL.BTBSP.T , DRAWINGS,JBL.IMPMAT , DRAWINGS,JBL.IMPMAT.PPMT  ,
*  DRAWINGS,JBL.IMPSP , DRAWINGS,JBL.IMPSP.PPMT ,   DRAWINGS,JBL.IMPSP.T
*Attached As    : CHECK RECODE ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    
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
    FN.LETTER.OF.CREDIT="F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT=""
    FN.DRAWINGS="F.DRAWINGS"
    F.DRAWINGS=""
    Y.EXTERNAL.REFERENCE = ''
    Y.OLD.LC.NUMBER = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.DRAWINGS,F.DRAWINGS)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.DR.ID = EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]
    EB.DataAccess.FRead( FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.ERR)
    Y.OLD.LC.NUMBER = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
    R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcExternalReference> = Y.OLD.LC.NUMBER
    WRITE R.LETTER.OF.CREDIT TO F.LETTER.OF.CREDIT, Y.LC.ID
RETURN
*** </region>
END
