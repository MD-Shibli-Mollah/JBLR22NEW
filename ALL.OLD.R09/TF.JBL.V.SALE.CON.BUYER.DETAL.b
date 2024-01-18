SUBROUTINE TF.JBL.V.SALE.CON.BUYER.DETAL
*-----------------------------------------------------------------------------
* Description: read customer information from customer application auto-populate sales contact buyer detals fields.
*-----------------------------------------------------------------------------
* Created by: mahmudur rahman
* Attached version: BD.SCT.CAPTURE,CONT.AMEND BD.SCT.CAPTURE,CONT.RECORD
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SCT.CAPTURE
    

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
    
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
        IF REC.CUS THEN
            Y.CUS.NAME1 = REC.CUS<ST.Customer.Customer.EbCusNameOne>
            Y.CUS.NAME2 = REC.CUS<ST.Customer.Customer.EbCusNameTwo>
            Y.STATE = REC.CUS<ST.Customer.Customer.EbCusStreet>
            Y.COUNTRY.TWN = REC.CUS<ST.Customer.Customer.EbCusTownCountry>
    
            Y.CUS.DETALS = Y.CUS.NAME1:VM:Y.CUS.NAME2:VM:Y.STATE:VM:Y.COUNTRY.TWN
            CONVERT FM TO VM IN Y.CUS.DETALS
            CONVERT SM TO VM IN Y.CUS.DETALS
            EB.SystemTables.setRNew(SCT.BUYER.NAME, Y.CUS.DETALS)
        END
    END
RETURN
END
