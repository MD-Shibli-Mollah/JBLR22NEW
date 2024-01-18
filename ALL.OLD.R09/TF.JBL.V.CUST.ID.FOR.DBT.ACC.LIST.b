SUBROUTINE TF.JBL.V.CUST.ID.FOR.DBT.ACC.LIST
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :          Created by : SHAJJAD HOSSEN - FDS SERVICES LTD
* Attached : FUNDS.TRANSFER,JBL.IMP.PART.PAY.INFO
* attached filed: Customer id from droawings for Debit Account Dropdown list.
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE

    

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING ST.Customer
    $USING LC.Contract
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *INITIALISATION
    GOSUB OPENFILE ; *FILE OPEN
    GOSUB PROCESS ; *PROCESS BUSINESS LOGIC
RETURN
    
INITIALISE:
    FN.DR = 'F.DRAWINGS'
    F.DR = ''
    
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    
    FLD.POS = ''
    APPLICATION.NAME ='DRAWINGS'
    LOCAL.FIELD = 'LT.TF.APL.CUSNO'
    EB.Updates.MultiGetLocRef(APPLICATION.NAME,LOCAL.FIELD,FLD.POS)
    Y.DR.CUS.POS = FLD.POS<1,1>
RETURN
OPENFILE:
    EB.DataAccess.Opf(FN.DR, F.DR)
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    
    Y.DR.ID = EB.SystemTables.getComi()
RETURN
PROCESS:
    IF Y.DR.ID NE '' THEN
        EB.DataAccess.FRead(FN.DR, Y.DR.ID, REC.DR, F.DR, ERR.DR)
        Y.CUS.ID = REC.DR<LC.Contract.Drawings.TfDrLocalRef,Y.DR.CUS.POS>

        EB.Foundation.MapLocalFields('FUNDS.TRANSFER', 'LT.TF.APL.CUSNO', Y.FT.CUS.ID.POS)
        Y.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.TEMP<1,Y.FT.CUS.ID.POS> = Y.CUS.ID

       
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.TEMP)

    END
RETURN

END
