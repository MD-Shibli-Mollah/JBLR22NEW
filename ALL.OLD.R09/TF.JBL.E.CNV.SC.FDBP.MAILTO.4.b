*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
$PACKAGE AA.ModelBank
SUBROUTINE TF.JBL.E.CNV.SC.FDBP.MAILTO.4(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 09/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Cystomer Town Country
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
    
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.DR.NAU, F.DR.NAU)
    EB.DataAccess.Opf(FN.LC, F.LC)
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    
    RECURRENCE = IN.FREQ
    IN.DATE = ''
    OUT.MASK = ''
    Y.ID = RECURRENCE
    EB.DataAccess.FRead(FN.CUS, Y.ID, REC.CUS, F.CUS, ERR.CUS)
    CUS.ADDR = REC.CUS<ST.Customer.Customer.EbCusTownCountry>
    OUT.FREQ = CUS.ADDR
RETURN

END


