SUBROUTINE GB.JBL.V.DD.STOCK.SERIES
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING CQ.ChqStockControl

    
    
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-------------------------------------------------------------------
INITIALISE:
*** <desc> </desc>
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    FN.TEL = 'F.TELLER' ; F.TEL = ''
RETURN
*-------------------------------------------------------------------
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.TEL, F.TEL)
RETURN
*---------------------------------------------------------------
PROCESS:
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.CHQ.TYP = 'DD*'
        Y.SERIES.ID = Y.CHQ.TYP:Y.ISS.CHQ.TYPE:'*'
        EB.SystemTables.setComi(Y.SERIES.ID)
    END
    
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.TT.ISS.CHQ.TYP = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.TT.CHQ.TYP = 'DD*'
        Y.SERIES.ID = Y.TT.CHQ.TYP:Y.TT.ISS.CHQ.TYP:'*'
        EB.SystemTables.setComi(Y.SERIES.ID)
    END
RETURN
END
