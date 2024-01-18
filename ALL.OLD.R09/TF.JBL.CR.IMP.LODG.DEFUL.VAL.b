SUBROUTINE TF.JBL.CR.IMP.LODG.DEFUL.VAL
*-----------------------------------------------------------------------------
*Subroutine Description: Set in initial data in drawings from LC
*Attached To    : DRAWINGS,JBL.BTBMAT
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 24/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING LC.Contract
    
    $USING EB.LocalReferences
    $USING EB.DataAccess
    $USING EB.SystemTables
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB CHECK.REFNO ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT="F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT=""
    R.LETTER.OF.CREDIT=""
    FN.DRAWINGS="F.DRAWINGS"
    F.DRAWINGS=""
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

*** <region name= CHECK.REFNO>
CHECK.REFNO:
*** <desc>CHECK REF NO </desc>
    GOSUB GET.LOC.REF.POS
    
    Y.DR.ID = EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]
    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.ERR)
    IF R.LETTER.OF.CREDIT THEN
        Y.LC.NO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.APP.CUSNO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcApplicantCustno>

        ! S - Ayush - 20130917
        Y.LIMIT.REFERENCE = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLimitReference>
        Y.LC.ISSUE.DATE = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcIssueDate>
        !E
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrDrawCurrency, R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLcCurrency>)
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.DAPPCUS.POS>  = Y.APP.CUSNO
        Y.TEMP<1,Y.DLCNO.POS>  = Y.LC.NO
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
        Y.BEN.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcBeneficiary>
        Y.IMP.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcApplicant>
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.DEXPNAME.POS>=EREPLACE(Y.BEN.NAME,VM,SM)
        Y.TEMP<1,Y.DIMPNAME.POS>=EREPLACE(Y.IMP.NAME,VM,SM)
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    END
    ! S - Ayush - 20130917

    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLimitReference, Y.LIMIT.REFERENCE)
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.TEMP<1,Y.LC.DATE> = Y.LC.ISSUE.DATE
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    !E
RETURN
*** </region>
 
*** <region name= GET.LOC.REF.POS>
GET.LOC.REF.POS:
*** <desc>GET.LOC.REF.POS </desc>
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.APL.CUSNO",Y.DAPPCUS.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TFDR.LC.NO",Y.DLCNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXPR.NAME",Y.DEXPNAME.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.IMPR.NAME",Y.DIMPNAME.POS)
    ! S - Ayush - 20130917
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.LC.DATE",Y.LC.DATE)
    !E
RETURN
*** </region>
END
