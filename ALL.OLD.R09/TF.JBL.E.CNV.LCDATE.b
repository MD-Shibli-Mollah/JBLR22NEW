* <Rating>0</Rating>
*-----------------------------------------------------------------------------

SUBROUTINE TF.JBL.E.CNV.LCDATE(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 05/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for  l LC Issue Date
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-762.1.1.GB & 762.1.1.GB
*
******************************
    $USING ST.Config
    $USING EB.DataAccess
    $USING LC.Contract
    
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    
    EB.DataAccess.Opf(FN.LC, F.LC)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.ID = RECURRENCE
    
    EB.DataAccess.FRead(FN.LC, Y.ID, REC.LC, F.LC, ERR.LC)
    IF REC.LC THEN
        Y.DT=REC.LC<LC.Contract.LetterOfCredit.TfLcIssueDate>
    END
    DATE.CONV.FMT = 'D4'
    ST.Config.DieterDate(Y.DT, JBASE.CONV.DATE, DATE.CONV.FMT)
    OUT.MASK = JBASE.CONV.DATE

    OUT.FREQ = OUT.MASK

RETURN

END