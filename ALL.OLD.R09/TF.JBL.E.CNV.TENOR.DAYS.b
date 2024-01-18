*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.TENOR.DAYS(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)
    
    

****************************
*
* Modification History
*
* 03/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Tenor Days from LC or DR
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-1798.57.1.GB & 1797.57.1.GB
*
******************************
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    
    $USING EB.Utility
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.LocalReferences
    $USING EB.Updates
    
    FN.DR='F.DRAWINGS'
    F.DR=''
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.LC, F.LC)
    
    Y.APP = 'DRAWINGS':FM:'LETTER.OF.CREDIT'
    Y.FLD = 'LT.TF.TENR.DAYS':FM:'LT.TF.LC.TENOR'
    Y.POS = ''
    
    EB.Updates.MultiGetLocRef(Y.APP,Y.FLD,Y.POS)
    Y.DR.TEN.POS = Y.POS<1,1>
    Y.LC.TEN.POS = Y.POS<2,1>
*    EB.LocalReferences.GetLocRef("DRAWINGS","LT.TF.TENR.DAYS",Y.DR.TENR)
*    EB.LocalReferences.GetLocRef("LETTER.OF.CREDIT","LT.TF.LC.TENOR",Y.LC.TENOR)

    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    !Y.ID = RECURRENCE
    EB.DataAccess.FRead(FN.DR, RECURRENCE, REC.DR, F.DR, ERR.DR)

    IF REC.DR THEN
        Y.DR.TENOR.REF = REC.DR<LC.Contract.Drawings.TfDrLocalRef>
        Y.DR.TENOR = Y.DR.TENOR.REF<1,Y.DR.TEN.POS>
    END
    Y.LC.NO = RECURRENCE[1,12]
    EB.DataAccess.FRead(FN.LC, Y.LC.NO, REC.LC, F.LC, ERR.LC)
    IF REC.LC THEN
        Y.LC.TENOR.REF = REC.LC<LC.Contract.LetterOfCredit.TfLcLocalRef>
        Y.LC.TENOR = Y.LC.TENOR.REF<1,Y.LC.TEN.POS>
    END
    IF Y.LC.TENOR NE "" THEN
        OUT.MASK = Y.LC.TENOR
        
    END ELSE
        OUT.MASK = Y.DR.TENOR
    END
    OUT.FREQ = OUT.MASK

RETURN

END