SUBROUTINE TF.JBL.CR.EXP.COLL.REF.LC
*-----------------------------------------------------------------------------
*Subroutine Description: Set LC extarnal refrence from Drawings
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.F.CONDOCREAL , DRAWINGS,JBL.F.EXPDOCREAL , DRAWINGS,JBL.F.PPMT.EXPDOCREAL
*  DRAWINGS,JBL.I.CONDOCREAL , DRAWINGS,JBL.I.EXPDOCREAL , DRAWINGS,JBL.I.PPMT.EXPDOCREAL)
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 29/10/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
    $USING    LC.Contract
    $USING    EB.DataAccess
    $USING    EB.SystemTables
    $USING    EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE; *INITIALISATION
    GOSUB OPENFILE; *FILE OPEN
    GOSUB CHECK.REFNO
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
    Y.EXLC.COLL.NO = ''
    Y.LOC.POS =''
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

 
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
CHECK.REFNO:
*** <desc>PROCESS BUSINESS LOGIC </desc>

    GOSUB GET.LOC.REF.POS

    Y.DR.ID =EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]

    EB.DataAccess.FRead( FN.DRAWINGS,Y.DR.ID,R.DR,F.DRAWINGS,Y.ERR)
    Y.EXLC.COLL.NO = R.DR<LC.Contract.Drawings.TfDrLocalRef,Y.COLLNO.POS>

    EB.DataAccess.FRead( FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.ERR)
    R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcExternalReference> = Y.EXLC.COLL.NO
    WRITE R.LETTER.OF.CREDIT TO F.LETTER.OF.CREDIT, Y.LC.ID

GET.LOC.REF.POS:
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.ELC.COLNO",Y.COLLNO.POS)
RETURN
END
