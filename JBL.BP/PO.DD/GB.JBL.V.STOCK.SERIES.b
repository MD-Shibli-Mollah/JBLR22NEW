
SUBROUTINE GB.JBL.V.STOCK.SERIES
*-----------------------------------------------------------------------------
*Subroutine Description:
* THIS ROUTINE is used as a validation routine for funds transfer and teller version Pay order for series id creation
*
*Attached To    : VERSION(FUNDS.TRANSFER,JBL.DUP.DD.ISSUE , FUNDS.TRANSFER,JBL.DUP.PO.ISSUE , FUNDS.TRANSFER,JBL.DUP.PS.ISSUE
*                   FUNDS.TRANSFER,JBL.DUP.SDR.ISSUE , FUNDS.TRANSFER,JBL.PO.ISSUE , FUNDS.TRANSFER,JBL.PS.ISSUE , FUNDS.TRANSFER,JBL.SDR.ISSUE
*                   TELLER,JBL.PO.SELL.CASH , TELLER,JBL.PS.SELL.CASH , TELLER,JBL.SDR.SELL.CASH)

*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 21/08/2022 - CREATED BY                         NEW - NILOY SARKAR
*                                                 NITSL
* 07/03/2024 - CREATED BY                         UPDATE - MD SHIBLI MOLLAH
*                                                 NITSL
*
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
    Y.APP = EB.SystemTables.getApplication()
    IF Y.APP EQ 'FUNDS.TRANSFER' THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.STOCK.SERIES = 'PO*'
    
        Y.SERIES.ID = Y.ISS.CHQ.TYPE:'*':Y.STOCK.SERIES
        EB.SystemTables.setComi(Y.SERIES.ID)
    END
    
    IF Y.APP EQ 'TELLER' THEN
        Y.TT.ISS.CHQ.TYP = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.STOCK.SERIES = 'PO*'
        Y.SERIES.ID = Y.TT.ISS.CHQ.TYP:'*':Y.STOCK.SERIES
        EB.SystemTables.setComi(Y.SERIES.ID)
    END
RETURN

END

