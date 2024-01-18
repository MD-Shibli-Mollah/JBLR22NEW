* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.SG.YEAR(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 05/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Taking Year From Full Date
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-762.1.1.GB &
*
******************************

    $USING EB.Utility
    $USING EB.DataAccess
    $USING DE.Config
    
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.ID = RECURRENCE
   
    Y.START.DT=Y.ID[3,2]
    OUT.MASK = Y.START.DT

    OUT.FREQ = OUT.MASK

RETURN

END
