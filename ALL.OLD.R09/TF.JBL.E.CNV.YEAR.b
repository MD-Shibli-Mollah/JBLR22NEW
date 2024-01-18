*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.YEAR(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 03/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for taking Year From Full Date
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-1798.57.1.GB & 1797.57.1.GB
*
******************************
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    YR = RECURRENCE
    YEAR = YR[1,4]
    OUT.MASK = YEAR
    OUT.FREQ = OUT.MASK

RETURN

END