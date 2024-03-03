SUBROUTINE BD.TRADE.TXN.PROFILE.ID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.BD.TRADE.TXN.PROFILE
    
    $USING EB.SystemTables
    $USING ST.Customer
    $USING EB.DataAccess
    $USING EB.ErrorProcessing
    
    GOSUB INIT
    GOSUB OPEN.FILE
    GOSUB PROCESS
RETURN

INIT:
    FN.CUS = 'F.CUSTOMER'
    F.CUS = ''
RETURN

OPEN.FILE:
    EB.DataAccess.Opf(FN.CUS, F.CUS)
RETURN

PROCESS:
    Y.CUS.ID = EB.SystemTables.getComi()
    EB.DataAccess.FRead(FN.CUS, Y.CUS.ID, CUS.REC, F.CUS, CUS.ERR)
    
    IF CUS.REC EQ '' THEN
        EB.SystemTables.setEtext(Y.CUS.ID:" This Id has no Customer")
        EB.ErrorProcessing.StoreEndError()
    END
    
RETURN

END
