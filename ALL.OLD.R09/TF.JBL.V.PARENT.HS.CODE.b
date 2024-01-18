SUBROUTINE TF.JBL.V.PARENT.HS.CODE
*-----------------------------------------------------------------------------
*Subroutine Description: HS CODE VALIDATION
*Subroutine Type:
*Attached To    :LETTER.OF.CREDIT VERSION(LETTER.OF.CREDIT,JBL.EXLCTRF)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 03/11/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $USING   LC.Contract
    $USING   EB.SystemTables
    $USING   EB.DataAccess
    $USING   EB.LocalReferences
    $USING   EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE; *INITIALISATION
    GOSUB PROCESS; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------
*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>

*

    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    F.LETTER.OF.CREDIT = ''
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)

    Y.APP = 'LETTER.OF.CREDIT'
    Y.FLD = 'HS.CODE'
    Y.POS = ''
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)
    Y.HS.CODE.POS = Y.POS<1,1>

    Y.PARENT.LC.ID = EB.SystemTables.getComi()
    R.LC.REC = ''
    Y.LC.ERR = ''
    Y.HS.CODE = ''

RETURN

*** </region>

 
*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
*

    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.PARENT.LC.ID,R.LC.REC,F.LETTER.OF.CREDIT,Y.LC.ERR)
    Y.HS.CODE = R.LC.REC<LC.Contract.LetterOfCredit.TfLcLocalRef,Y.HS.CODE.POS>
*EB.SystemTables.getRNew(TF.LC.LOCAL.REF)<1,Y.HS.CODE.POS> = Y.HS.CODE
    Y.TEMP =EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TEMP<1,Y.HS.CODE.POS> = Y.HS.CODE
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef,Y.TEMP)

RETURN

END
