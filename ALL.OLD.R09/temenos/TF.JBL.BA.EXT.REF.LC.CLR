SUBROUTINE TF.JBL.BA.EXT.REF.LC.CLR
*-----------------------------------------------------------------------------
*Subroutine Description: Copy LC.NO from Drawings to the correspondent LC
*                        record to pass this reference to STMT.ENTRY and NR Items
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPSP)
*Attached As    : BEFORE AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
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
    R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcExternalReference> = Y.OLD.LC.NUMBER
    WRITE R.LETTER.OF.CREDIT TO F.LETTER.OF.CREDIT, Y.LC.ID
RETURN
*** </region>
END
