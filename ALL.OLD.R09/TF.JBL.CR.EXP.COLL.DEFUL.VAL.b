SUBROUTINE TF.JBL.CR.EXP.COLL.DEFUL.VAL
*-----------------------------------------------------------------------------
*Subroutine Description: Export collection pre set values from LC
*Subroutine Type:
*Attached To    : DRAWINGS,JBL.F.EXPCOLL , DRAWINGS,JBL.I.EXPCOLL , DRAWINGS,JBL.SALCSCOLL
*Attached As    : CHECK RECORD ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 22/10/2019 -                            Retrofit   - MD.KAMRUL HASAN
*                                                 FDS Pvt Ltd
*-----------------------------------------------------------------------------
    $INCLUDE  I_COMMON
    $INCLUDE  I_EQUATE
 
    $USING LC.Contract
    $USING ST.CompanyCreation
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
*-----------------------------------------------------------------------------
    GOSUB INITIALISE; *INITIALISATION
    GOSUB OPENFILES; *FILE OPEN
    GOSUB CHECK.REFNO
RETURN
*-----------------------------------------------------------------------------
 
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.LETTER.OF.CREDIT="F.LETTER.OF.CREDIT"
    F.LETTER.OF.CREDIT=""
    FN.DRAWINGS="F.DRAWINGS"
    F.DRAWINGS=""

    Y.EXPORT.LCNO = ''
    Y.LC.CONTNO = ''
    Y.LC.JOBNO = ''
    Y.BEN.CUSNO = ''
    Y.LC.BEN.NAME = ''
    Y.LC.APP.NAME = ''
    Y.LC.AMT = ''
    Y.LC.TRF.CNT = ''
    Y.LC.TRAN.AMT = ''
    Y.LC.OUTS.AMT = ''
RETURN
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    EB.DataAccess.Opf(FN.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT)
    EB.DataAccess.Opf(FN.DRAWINGS,F.DRAWINGS)
RETURN

CHECK.REFNO:

    GOSUB GET.LOC.REF.POS
    Y.DR.ID =EB.SystemTables.getIdNew()
    Y.LC.ID = Y.DR.ID[1,12]

    EB.DataAccess.FRead(FN.LETTER.OF.CREDIT,Y.LC.ID,R.LETTER.OF.CREDIT,F.LETTER.OF.CREDIT,Y.ERR)
    Y.EXPORT.LCNO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcIssBankRef>
    Y.LC.CONTNO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLocalRef><1,Y.CONTNO.POS>
    Y.LC.JOBNO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLocalRef><1,Y.JOBNO.POS>
    Y.BEN.CUSNO = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcBeneficiaryCustno>
    Y.LC.BEN.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcBeneficiary>
    Y.LC.APP.NAME = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcApplicant>
    Y.LC.AMT = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLcAmount>
    Y.LC.TRF.CNT = DCOUNT(R.LETTER.OF.CREDIT<TF.LC.TRANSFERRED.LC>,VM)

    GOSUB GET.LC.OUTS.AMT
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.LCOUTAMT.POS> = Y.LC.OUTS.AMT
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DR.LCOUTAMT.POS> = Y.LC.OUTS.AMT)
    R.NEW(LC.Contract.Drawings.TfDrDrawCurrency) = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLcCurrency>
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrDrawCurrency, R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLcCurrency>)
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DEXPLCNO.POS>  = Y.EXPORT.LCNO
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DEXPLCNO.POS>  = Y.EXPORT.LCNO)
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DCONTNO.POS> = Y.LC.CONTNO
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DCONTNO.POS> = Y.LC.CONTNO)
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DJOBNO.POS> = Y.LC.JOBNO
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DJOBNO.POS> = Y.LC.JOBNO)
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DBENCUS.POS>  = Y.BEN.CUSNO
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DBENCUS.POS>  = Y.BEN.CUSNO)
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DEXPNAME.POS> = EREPLACE(Y.LC.BEN.NAME,VM,SM)
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DEXPNAME.POS> = EREPLACE(Y.LC.BEN.NAME,VM,SM))
    R.NEW(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DIMPNAME.POS> = EREPLACE(Y.LC.APP.NAME,VM,SM)
*EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrLocalRef, EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrLocalRef)<1,Y.DIMPNAME.POS> = EREPLACE(Y.LC.APP.NAME,VM,SM))
RETURN

GET.LC.OUTS.AMT:
    IF Y.LC.TRF.CNT GE 1 THEN
        FOR I = 1 TO Y.LC.TRF.CNT
            Y.LC.TRAN.AMT += R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcTranPortAmt,I>
        NEXT I
        Y.LC.OUTS.AMT = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLiabilityAmt> - Y.LC.TRAN.AMT
        Y.LC.TRAN.AMT = ''
    END ELSE
        Y.LC.OUTS.AMT = R.LETTER.OF.CREDIT<LC.Contract.LetterOfCredit.TfLcLiabilityAmt>
    END

RETURN

GET.LOC.REF.POS:
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.JOB.NUMBR",Y.JOBNO.POS)
    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.CONT.NO",Y.CONTNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXP.LC.NO",Y.DEXPLCNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.BTB.CNTNO",Y.DCONTNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.JOB.NUMBR",Y.DJOBNO.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.APL.CUSNO",Y.DBENCUS.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.EXPR.NAME",Y.DEXPNAME.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.IMPR.NAME",Y.DIMPNAME.POS)
    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.LC.OUSAMT",Y.DR.LCOUTAMT.POS)

RETURN
END

