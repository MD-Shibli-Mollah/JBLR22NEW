SUBROUTINE TF.JBL.V.VAL.LC.INCOTERM
*-----------------------------------------------------------------------------
*Subroutine Description: Description Goods Validation in LC
*Subroutine Type:
*Attached To    : LETTER.OF.CREDIT Version (LETTER.OF.CREDIT,JBL.IMPSIGH | LETTER.OF.CREDIT,JBL.BTBUSANCE)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING EB.DataAccess
    $USING EB.LocalReferences
    $USING EB.Display
    $USING LC.Contract
    $USING ST.Config
    $USING EB.Updates
    $USING EB.SystemTables
    $USING EB.ErrorProcessing

*$INSERT JBL.BP I_F.HS.CODE.LIST
*-----------------------------------------------------------------------------
    IF EB.SystemTables.getMessage() EQ "VAL" THEN RETURN
    
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT = 'F.LETTER.OF.CREDIT'
    FV.LETTER.OF.CREDIT = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,FV.LETTER.OF.CREDIT)
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.COMMO.COD',BB.COM.POS)
    EB.LocalReferences.GetLocRef('LETTER.OF.CREDIT','LT.TF.HS.CODE',HS.POS)
    
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.TEMP<1,BB.COM.POS> = FIELD(EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)<1,HS.POS>,@VM,1)
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.TEMP)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    Y.INCOTERM1 = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcDescGoods)
    CHANGE ' ' TO VM IN Y.INCOTERM1
    IF Y.INCOTERM1 THEN
        FINDSTR EB.SystemTables.getComi() IN Y.INCOTERM1 SETTING POS ELSE
            EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcDescGoods, EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcDescGoods):" ":EB.SystemTables.getComi())
        END
    END ELSE
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcDescGoods, EB.SystemTables.getComi())
    END
RETURN
*** </region>
END
