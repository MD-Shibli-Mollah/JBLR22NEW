*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.PORT.ADDRESS(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 23/12/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Customer Name and Address
*            mapping process of AA
*            Used in DE.FORMAT.PRINT-762.1.1.GB
*
******************************
    $INSERT  I_COMMON
    $INSERT  I_EQUATE

    $USING EB.Utility
    $USING EB.DataAccess
    $USING LC.Contract
    $USING EB.API
    $USING ST.Customer
    
    FN.CUS='F.CUSTOMER'
    F.CUS=''
    
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    EB.DataAccess.FRead(FN.CUS, RECURRENCE, R.CUS, F.CUS, CUS.ERR)
    IF R.CUS THEN
        Y.CUS.NAME = R.CUS<ST.Customer.Customer.EbCusNameTwo>
        Y.CUS.STRT = R.CUS<ST.Customer.Customer.EbCusStreet>
    END
    Y.FULL = Y.CUS.NAME : " , " : Y.CUS.STRT
    OUT.MASK = Y.FULL
    

    OUT.FREQ = OUT.MASK

RETURN

END
