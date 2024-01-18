SUBROUTINE TF.JBL.I.TFDR.FLD.CLR
*-----------------------------------------------------------------------------
* Attached to: LETTER.OF.CREDIT,JBL.IMPADDMGN
*-----------------------------------------------------------------------------
* Modification History : Abu Huraira
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.LC.MARGIN.BAL

    $USING LC.Contract
    $USING LC.Config
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING EB.ErrorProcessing
  
    IF EB.SystemTables.getVFunction() NE 'I' THEN RETURN
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
    
    FN.LC.TYPE = 'F.LC.TYPES'
    F.LC.TYPE = ''
    
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
    EB.DataAccess.Opf(FN.LC.TYPE, F.LC.TYPE)
    EB.DataAccess.Opf(FN.LC, F.LC)
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.MRG.BAL, F.MRG.BAL)
RETURN

*----------
PROCESS:
*----------
    Y.TF.ID = EB.SystemTables.getIdNew()
    EB.DataAccess.FRead(FN.LC, Y.TF.ID, R.TF.REC, F.LC, Y.TF.ERR)
    Y.LC.TYPE = R.TF.REC<LC.Contract.LetterOfCredit.TfLcLcType>
    EB.DataAccess.FRead(FN.LC.TYPE, Y.LC.TYPE, R.LC.TYPE.REC, F.LC.TYPE, Y.LC.TYPE.ERR)
    Y.LC.LF= EB.SystemTables.getRNew(LC.Contract.LetterOfCredit.TfLcLocalRef)
*Y.LC.LF = R.TF.REC<LC.Contract.LetterOfCredit.TfLcLocalRef>
    Y.DR.ID = Y.LC.LF<1, Y.DR.ID.POS>
    EB.DataAccess.FRead(FN.DR,Y.DR.ID,R.DR.REC,F.DR,Y.DR.ERR)
    
    IF R.LC.TYPE.REC<LC.Config.Types.TypImportExport> NE 'I' THEN
        EB.SystemTables.setEtext('LC is Not an Import LC')
        EB.SystemTables.setAf(LC.Contract.LetterOfCredit.TfLcLcType)
*EB.SystemTables.setAv()
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF Y.TF.ID NE Y.DR.ID[1,12] THEN
        EB.SystemTables.setEtext('Drawings ID Not Belongs to this LC')
        EB.SystemTables.setAf(Y.LC.LF)
        EB.SystemTables.setAv(Y.DR.ID.POS)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    IF R.DR.REC EQ '' THEN
        EB.SystemTables.setEtext("Drawing ID Does Not Exist")
        EB.SystemTables.setAf(Y.LC.LF)
        EB.SystemTables.setAv(Y.DR.ID.POS)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    Y.DR.TYPE = R.DR.REC<LC.Contract.Drawings.TfDrDrawingType>
    IF (Y.DR.TYPE EQ 'AC' OR Y.DR.TYPE EQ 'DP') THEN
        Y.DOC.AMT = R.DR.REC<LC.Contract.Drawings.TfDrDocumentAmount>
        Y.LC.LF<1,Y.DR.DOC.AMT.POS> = R.DR.REC<LC.Contract.Drawings.TfDrDocumentAmount>
        Y.DR.PROV.REL.AMT = R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel>
        Y.LC.LF<1,Y.DR.OUT.MGN.AMT.POS> = R.DR.REC<LC.Contract.Drawings.TfDrProvAmtRel>
        EB.SystemTables.setRNew(LC.Contract.LetterOfCredit.TfLcLocalRef, Y.LC.LF)
    END
    ELSE
        EB.SystemTables.setEtext('Drawing Type must be AC or DP')
        EB.SystemTables.setAf(Y.LC.LF)
        EB.SystemTables.setAv(Y.DR.ID.POS)
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END

RETURN
END
