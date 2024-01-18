*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.NOSTRO.CUS.DET(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 09/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Credit Account Customer Details
*            mapping process of AA
*            Used in DE.FORMAT.PRINT- 1796.57.1.GB
*F******************************

    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    
    $USING EB.Utility
    $USING EB.DataAccess
    $USING LC.Contract
    $USING ST.Customer
    
    FN.CUS='F.CUSTOMER'
    F.CUS=''
    
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.ID = RECURRENCE
    EB.DataAccess.FRead(FN.CUS, Y.ID, REC.CUS, F.CUS, ERR.CUS)
    IF REC.CUS THEN
        CUS.STRT = REC.CUS<ST.Customer.Customer.EbCusStreet>
        CUS.ADDR = REC.CUS<ST.Customer.Customer.EbCusAddress>
        CUS.TOWN = REC.CUS<ST.Customer.Customer.EbCusTownCountry>
    END
    CUS.FULL = CUS.STRT : ", " : CUS.ADDR : ", " : CUS.TOWN
    OUT.MASK = CUS.FULL
    OUT.FREQ = OUT.MASK
RETURN

END
