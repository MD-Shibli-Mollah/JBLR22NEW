*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.DRNO.TO.OLDLC(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 23/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Company swift code
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-900.21.1.GB
*
******************************
    $INSERT  I_COMMON
    $INSERT  I_EQUATE

    $USING EB.Utility
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.API
    
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
    
    EB.DataAccess.Opf(FN.LC, F.LC)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.DRLC = LEN(RECURRENCE)
    IF Y.DRLC NE 12 THEN
        Y.LC.NO = RECURRENCE[1,12]
    END
    ELSE
        Y.LC.NO = RECURRENCE
    END

    
    EB.DataAccess.FRead(FN.LC, Y.LC.NO, REC.LC, F.LC, ERR.LC)
    IF REC.LC NE '' THEN
        Y.OLD.LC = REC.LC<LC.Contract.LetterOfCredit.TfLcOldLcNumber>
    END
    OUT.MASK = Y.OLD.LC
    

    OUT.FREQ = OUT.MASK

RETURN

END
