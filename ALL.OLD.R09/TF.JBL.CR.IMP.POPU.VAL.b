SUBROUTINE TF.JBL.CR.IMP.POPU.VAL
*-----------------------------------------------------------------------------
*Subroutine Description: Import Drawings initial data set from LC
*Subroutine Type:
*Attached To    : DRAWINGS Version (DRAWINGS,JBL.BTBAC , DRAWINGS,JBL.BTBDOCREJ , DRAWINGS,JBL.BTBLODGE , DRAWINGS,JBL.BTBSP, DRAWINGS,JBL.BTBSP.T ,
* DRAWINGS,JBL.IMPAC ,  DRAWINGS,JBL.IMPDOCREJ , DRAWINGS,JBL.IMPLODGE , DRAWINGS,JBL.IMPSP , DRAWINGS,JBL.IMPSP.PPMT , DRAWINGS,JBL.IMPSP.T)
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 23/10/2019 -                            Retrofit   - MD. EBRAHIM KHALIL RIAN,
*                                                 FDS Bangladesh Limited
*Modification 1
*11/22/2020    Limit Reference field auto populate from LC record.
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
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc>INITIALISATION </desc>
    FN.LETTER.OF.CREDIT = "F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT  = ""
    FN.DRAWINGS         = "F.DRAWINGS"
    F.DRAWINGS          = ""
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

    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.LC.ERR)
    
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.LC.JOB.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.JOB.NUMBR",Y.DR.JOB.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.IMPR.NAME",Y.DR.APP.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXPR.NAME",Y.DR.BEN.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TFDR.LC.NO",Y.DR.LC.NO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.LC.DATE",Y.DR.ISS.DT.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.APL.CUSNO",Y.DR.APPCUS.POS)
    IF R.LETTER.OF.CREDIT THEN
        Y.BB.LC.NO    = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
        Y.LC.ISS.DATE = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcIssueDate>
        Y.LC.APP.ID   = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcApplicantCustno>
        Y.LC.APP.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcApplicant>
        Y.LC.BEN.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcBeneficiary>
        Y.LC.JOB.NO   = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLocalRef><1,Y.LC.JOB.POS>
    END
*************************Modification 1******************
    Y.LC.LIMIT  = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLimitReference>
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLimitReference, Y.LC.LIMIT)
*************************    END 1    *******************
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.TEMP<1,Y.DR.APPCUS.POS>   = Y.LC.APP.ID
    Y.TEMP<1,Y.DR.LC.NO.POS>    = Y.BB.LC.NO
    Y.TEMP<1,Y.DR.ISS.DT.POS>   = Y.LC.ISS.DATE
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    IF Y.LC.JOB.NO NE '' THEN
        Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
        Y.TEMP<1,Y.DR.JOB.POS> = Y.LC.JOB.NO
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
    END
    Y.TEMP = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)
    Y.TEMP<1,Y.DR.APP.POS>  = EREPLACE(Y.LC.APP.NAME,VM,SM)
    Y.TEMP<1,Y.DR.BEN.POS> = EREPLACE(Y.LC.BEN.NAME,VM,SM)
    EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, Y.TEMP)
RETURN
*** </region>
END
