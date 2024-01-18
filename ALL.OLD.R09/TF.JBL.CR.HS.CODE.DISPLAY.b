SUBROUTINE TF.JBL.CR.HS.CODE.DISPLAY
*-----------------------------------------------------------------------------
*Subroutine Description:  This rtn display the HS code from LC
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.IMPDOCAMD)
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING ST.CompanyCreation
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LC = "F.LETTER.OF.CREDIT"
    F.LC = ''
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
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.HS.CODE",Y.HS.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.HS.CODE",Y.DR.POS)
    Y.ID = EB.SystemTables.getIdNew()
    Y.LC.ID = Y.ID[1,12]
    EB.DataAccess.FRead(FN.LC,Y.LC.ID,R.REC,F.LC,Y.ERR)
    IF R.REC THEN
        Y.HS.CODE = R.REC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.HS.POS>
    END
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.TEMP<1,Y.DR.POS> = Y.HS.CODE
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
RETURN
*** </region>
END

