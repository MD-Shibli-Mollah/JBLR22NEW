SUBROUTINE TF.JBL.V.AC.OLD.LC.NO.DEF
*-----------------------------------------------------------------------------
*Subroutine Description: This routine is used to dafault the OLD.LC.NO to based on the field TF Number.
*Subroutine Type:
*Attached To    : ACCOUNT Version (ACCOUNT,BD.DL.CL.LN.PAD)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 28/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    $USING AC.AccountOpening
    $USING EB.Utility
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.Display
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    Y.OLD.LC.NUM=''
    Y.TF.NO=''
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''

    FN.AC='F.ACCOUNT'
    F.AC= ''
    
    EB.LocalReferences.GetLocRef("ACCOUNT","LT.AC.BD.EXLCNO",AC.POS1)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc>FILE OPEN </desc>
    EB.DataAccess.Opf(FN.LC,F.LC)
    EB.DataAccess.Opf(FN.AC,F.AC)
RETURN
*** </region>

*** <region name= PROCESS>
PROCESS:
*** <desc>PROCESS BUSINESS LOGIC </desc>
    IF EB.SystemTables.getComi() EQ "" THEN RETURN

    Y.TF.NO = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.LC,Y.TF.NO,R.LC,F.LC,LC.ERR)
    IF (R.LC) THEN
        Y.OLD.LC.NUM=R.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.TEMP = EB.SystemTables.getRNew(AC.AccountOpening.Account.LocalRef)
        Y.TEMP<1,AC.POS1>=Y.OLD.LC.NUM
        EB.SystemTables.setRNew(AC.AccountOpening.Account.LocalRef, Y.TEMP)
        EB.Display.RefreshField(EB.SystemTables.getAf(),"")

    END
RETURN
*** </region>
END
