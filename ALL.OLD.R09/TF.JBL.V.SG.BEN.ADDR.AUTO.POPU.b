SUBROUTINE TF.JBL.V.SG.BEN.ADDR.AUTO.POPU
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING MD.Contract
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN    
INITIALISE:
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
RETURN
OPENFILE:
    EB.DataAccess.Opf(FN.CUS, F.CUS)
    CUS.ID = EB.SystemTables.getComi()
RETURN
PROCESS:
    IF CUS.ID NE '' THEN
        EB.DataAccess.FRead(FN.CUS, CUS.ID, REC.CUS, F.CUS, ERR.CUS)
        Y.CUS.NAME1 = REC.CUS<ST.Customer.Customer.EbCusNameOne>
        Y.CUS.NAME2 = REC.CUS<ST.Customer.Customer.EbCusNameTwo>
        Y.STATE = REC.CUS<ST.Customer.Customer.EbCusStreet>
        Y.COUNTRY.TWN = REC.CUS<ST.Customer.Customer.EbCusTownCountry>
    
        Y.CUS.DETALS = Y.CUS.NAME1:VM:Y.CUS.NAME2:VM:Y.STATE:VM:Y.COUNTRY.TWN
        CONVERT FM TO VM IN Y.CUS.DETALS
        CONVERT SM TO VM IN Y.CUS.DETALS
        EB.SystemTables.setRNew(MD.Contract.Deal.DeaBankAddress,Y.CUS.DETALS)
    END
RETURN
END
