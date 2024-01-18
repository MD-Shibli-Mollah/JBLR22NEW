SUBROUTINE TF.JBL.V.PRESENTOR.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :          Created by : Mahmudur Rahman Udoy
* Attached : DRAWINGS,BD.OUTCOL.SPMT
* attached filed: Presentor Id
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING ST.Customer
    $USING LC.Contract
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
    PRESENTOR.CUS.ID = EB.SystemTables.getComi()
RETURN
PROCESS:
    IF PRESENTOR.CUS.ID NE '' THEN
        EB.DataAccess.FRead(FN.CUS, PRESENTOR.CUS.ID, REC.CUS, F.CUS, ERR.CUS)
        Y.CUS.SHORT.NAME = REC.CUS<ST.Customer.Customer.EbCusShortName>
       
        EB.SystemTables.setRNew(LC.Contract.Drawings.TfDrPresentor, Y.CUS.SHORT.NAME)
    END
RETURN
END
