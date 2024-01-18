*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE TF.JBL.E.CNV.SCDUL.TO.ISSBK2(IN.FREQ,HEADER.REC,MV.NO,OUT.FREQ,ERROR.MSG)

****************************
*
* Modification History
*
* 09/11/20 - SHAJJAD HOSSEN - FDS Bangladesh Ltd.
*            New routine for Presentor Ref or Issuing Bank  Details
*            mapping process of AA
*            Used in DE.FORMAT.PRINT- 1797.57.1.GB
*
******************************
    $INSERT  I_COMMON
    $INSERT  I_EQUATE


    $USING EB.Utility
    $USING EB.DataAccess
    $USING LC.Contract
    $USING ST.Customer

    
    FN.DR='F.DRAWINGS'
    F.DR=''
    FN.DR.NAU = 'F.DRAWINGS$NAU'
    F.DR.NAU = ''
    FN.LC='F.LETTER.OF.CREDIT'
    F.LC=''
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
    EB.DataAccess.FRead(FN.DR, Y.ID, REC.DR, F.DR, ERR.DR)
    IF REC.DR THEN
        Y.PRSNTOR.ID = REC.DR<LC.Contract.Drawings.TfDrPresentorCust>
    END
    IF REC.DR EQ '' THEN
        EB.DataAccess.FRead(FN.DR.NAU, Y.ID, REC.DR, F.DR.NAU, ERR.DR)
        IF REC.DR THEN
            Y.PRSNTOR.ID = REC.DR<LC.Contract.Drawings.TfDrPresentorCust>
        END
    END
    Y.LC.NO=Y.ID[1,12]

    IF Y.PRSNTOR.ID NE '' THEN
        EB.DataAccess.FRead(FN.CUS, Y.PRSNTOR.ID, REC.CUS, F.CUS, ERR.CUS)
        IF REC.CUS THEN
            CUS1 = REC.CUS<ST.Customer.Customer.EbCusStreet>
            CONVERT SM TO VM IN CUS1
            Y.1 = FIELD(CUS1,VM,1)
            OUT.MASK = Y.1
        END
        
    END
    ELSE
        EB.DataAccess.FRead(FN.LC, Y.LC.NO, REC.LC, F.LC, ERR.LC)
        IF REC.LC THEN
            ISS.BK = REC.LC<LC.Contract.LetterOfCredit.TfLcIssuingBank>
            Y.ISS.BK1 = FIELD(ISS.BK,VM,2)
            OUT.MASK = Y.ISS.BK1
        END
    END
    OUT.FREQ = OUT.MASK

RETURN

END


