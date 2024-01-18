* @ValidationCode : MjotNzE0NjgxMjUwOkNwMTI1MjoxNTcwMDE5OTQ4OTUwOkRFTEw6LTE6LTE6MDowOmZhbHNlOk4vQTpSMTdfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 02 Oct 2019 18:39:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R17_AMR.0
SUBROUTINE TF.JBL.A.TF.DR.MARGIN.BAL
*-----------------------------------------------------------------------------
*Subroutine Description: Add margin for import LC write in BD.LC.MARGIN.BAL
*Attached To    : LETTER.OF.CREDIT,JBL.IMPADDMGN
*Attached As    : AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :  Abu Huraira
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.LC.MARGIN.BAL
*-----------------------------------------------------------------------------
    $USING LC.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.TransactionControl
    $USING EB.ErrorProcessing
    
    IF EB.SystemTables.getVFunction() NE 'A' THEN RETURN
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
*-----
INIT:
*-----
    FN.LC = 'F.LETTER.OF.CREDIT'
    F.LC = ''
    
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.MRG.BAL = 'F.BD.LC.MARGIN.BAL'
    F.MRG.BAL = ''
    
    Y.LR.APPL = 'LETTER.OF.CREDIT'
    Y.LR.FLD = 'LT.LC.DR.NO':VM:'LT.LC.DR.DAMT':VM:'LT.LC.DR.OM.AMT'
    Y.LR.POS = ''

    EB.Foundation.MapLocalFields(Y.LR.APPL, Y.LR.FLD, Y.LR.POS)
    Y.DR.ID.POS = Y.LR.POS<1,1>
    Y.DR.DOC.AMT.POS = Y.LR.POS<1,2>
    Y.DR.OUT.MGN.AMT.POS = Y.LR.POS<1,3>
RETURN

*----------
OPENFILES:
*----------
    EB.DataAccess.Opf(FN.LC, F.LC)
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.MRG.BAL, F.MRG.BAL)
RETURN

*----------
PROCESS:
*----------
    Y.TF.ID = EB.SystemTables.getIdNew()
    Y.LC.LF = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
    Y.DR.ID = Y.LC.LF<1, Y.DR.ID.POS >
    Y.DOC.AMT = Y.LC.LF<1, Y.DR.DOC.AMT.POS>
    Y.OUT.MRG.AMT = Y.LC.LF<1, Y.DR.OUT.MGN.AMT.POS>

********************LC Record Update***********
    EB.DataAccess.FRead(FN.LC, Y.TF.ID, R.TF.REC, F.LC, Y.TF.ERR)
    
    Y.MRG.AMT = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcProvisAmount)
    Y.MRG.RLSED = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcProAwaitRel)
    Y.PROV.PER.NEW = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcProvisPercent)
    Y.PROV.PER.OLD = EB.SystemTables.getROld(LC.Contract.LetterOfCredit.TfLcProvisPercent)
    Y.LC.ORIG.RATE = EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLcOrigRate)
    
    IF Y.MRG.AMT EQ '' THEN
        Y.MRG.RLSED.AMT = Y.MRG.RLSED
    END ELSE
        Y.MRG.RLSED.AMT =  Y.MRG.RLSED + Y.MRG.AMT
    END
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcProAwaitRel, Y.MRG.RLSED.AMT)
    EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcProvisPercent, Y.PROV.PER.OLD)
****************end LC Record Update**********

************Drawing Record Update*************
    EB.DataAccess.FRead(FN.DR, Y.DR.ID, R.DR.REC, F.DR, Y.DR.ERR)
    Y.DR.PROV.AMT.REL = R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel> + Y.MRG.AMT
    R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel> = Y.DR.PROV.AMT.REL
    IF R.DR.REC<LC.Contract.Drawings.TfDrProvNetting> EQ 'NO' THEN
        Y.DR.PROV.COV.AMT =  R.DR.REC<LC.Contract.Drawings.TfDrCoveredAmount> + Y.MRG.AMT
        R.DR.REC<LC.Contract.Drawings.TfDrCoveredAmount> = Y.DR.PROV.COV.AMT
    END
    R.DR.REC<LC.Contract.Drawings.TfDrProvRelLcCcy> = DROUND(Y.DR.PROV.AMT.REL/Y.LC.ORIG.RATE,2)
    R.DR.REC<LC.Contract.Drawings.TfDrProvRelDocCcy> = DROUND(Y.DR.PROV.AMT.REL/Y.LC.ORIG.RATE,2)
    WRITE R.DR.REC TO F.DR,Y.DR.ID
*******************end************************
    
******************Update Additional Margin Info to Margin Table*****************
    EB.DataAccess.FRead(FN.MRG.BAL, Y.TF.ID, REC.MRG.BAL, F.MRG.BAL, Y.MRG.BAL.ERRR)
    IF REC.MRG.BAL NE '' THEN
        LOCATE Y.DR.ID IN REC.MRG.BAL<MRG.BAL.DR.NUMBER> SETTING Y.CNT.POS THEN
            Y.CNT = DCOUNT(REC.MRG.BAL<MRG.BAL.DR.PROV.ORG.OUT.AMT>, @SM) + 1
            REC.MRG.BAL<MRG.BAL.DR.PROV.ORG.OUT.AMT, Y.CNT.POS, Y.CNT> = Y.OUT.MRG.AMT
            REC.MRG.BAL<MRG.BAL.DR.PROV.INC.AMT, Y.CNT.POS, Y.CNT> = Y.MRG.AMT
            REC.MRG.BAL<MRG.BAL.DATE, Y.CNT.POS, Y.CNT> = '20':LEFT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,6)
            REC.MRG.BAL<MRG.BAL.TIME, Y.CNT.POS, Y.CNT> = SUBSTRINGS(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,7,2):':':RIGHT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,2)
            
*            REC.MRG.BAL<MRG.BAL.DR.PROV.ORG.OUT.AMT, Y.CNT.POS, 1> = Y.OUT.MRG.AMT
*            REC.MRG.BAL<MRG.BAL.DR.PROV.INC.AMT, Y.CNT.POS, 1> += Y.MRG.AMT
*            REC.MRG.BAL<MRG.BAL.DATE, Y.CNT.POS, 1> = '20':LEFT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,6)
*            REC.MRG.BAL<MRG.BAL.TIME, Y.CNT.POS, 1> = SUBSTRINGS(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,7,2):':':RIGHT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,2)
            WRITE REC.MRG.BAL TO F.MRG.BAL,Y.TF.ID
        END ELSE
            Y.R.MRG.BAL.CNT = DCOUNT(REC.MRG.BAL<MRG.BAL.DR.NUMBER>, @VM) + 1
            REC.MRG.BAL<MRG.BAL.DR.NUMBER, Y.R.MRG.BAL.CNT> = Y.DR.ID
            REC.MRG.BAL<MRG.BAL.DR.PROV.ORG.OUT.AMT, Y.R.MRG.BAL.CNT, 1> = Y.OUT.MRG.AMT
            REC.MRG.BAL<MRG.BAL.DR.PROV.INC.AMT, Y.R.MRG.BAL.CNT, 1> = Y.MRG.AMT
            REC.MRG.BAL<MRG.BAL.DATE, Y.R.MRG.BAL.CNT, 1> = '20':LEFT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,6)
            REC.MRG.BAL<MRG.BAL.TIME, Y.R.MRG.BAL.CNT, 1> = SUBSTRINGS(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,7,2):':':RIGHT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,2)
            WRITE REC.MRG.BAL TO F.MRG.BAL,Y.TF.ID
        END
    END ELSE
        REC.MRG.BAL<MRG.BAL.DR.NUMBER, 1> = Y.DR.ID
        REC.MRG.BAL<MRG.BAL.DR.PROV.ORG.OUT.AMT, 1, 1> = Y.OUT.MRG.AMT
        REC.MRG.BAL<MRG.BAL.DR.PROV.INC.AMT, 1, 1> = Y.MRG.AMT
        REC.MRG.BAL<MRG.BAL.DATE, 1, 1> = '20':LEFT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,6)
        REC.MRG.BAL<MRG.BAL.TIME, 1, 1> = SUBSTRINGS(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,7,2):':':RIGHT(R.TF.REC<LC.Contract.LetterOfCredit.TfLcDateTime>,2)
        WRITE REC.MRG.BAL TO F.MRG.BAL,Y.TF.ID
    END
************************end Addition Margin Collection****************

RETURN

END
