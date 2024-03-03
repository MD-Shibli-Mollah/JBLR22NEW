SUBROUTINE GB.JBL.V.TELLER.EXCHG.LCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.Foundation
    $USING TT.Contract
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

******
INIT:
******
    FN.TELLER = 'FBNK.TELLER'
    F.TELLER = ''
    
    Y.APPLICATION.NAME = 'TELLER'
    Y.FLD.POS = ''
    Y.LOCAL.FIELDS = 'LT.FCY.AMT'
    EB.Foundation.MapLocalFields(Y.APPLICATION.NAME, Y.LOCAL.FIELDS, Y.FLD.POS)
    Y.FCY.AMOUNT.POS = Y.FLD.POS<1,1>
RETURN

***********
OPENFILES:
***********
    EB.DataAccess.Opf(FN.TELLER,F.TELLER)
RETURN

***********
PROCESS:
***********
    Y.EXCHANGE.RATE = EB.SystemTables.getComi()
    Y.TT.ID = EB.SystemTables.getIdNew()
    EB.DataAccess.FRead(FN.TELLER,Y.TT.ID,R.TELLER,F.TELLER,Y.ERR)
    Y.TT.AMT.LOC.CALC = DROUND((Y.FCY.AMT.FINAL * Y.EXCHANGE.RATE),2)
    Y.FCY.CCY.AMT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)<1,Y.FCY.AMOUNT.POS>
    Y.FCY.AMT.LEN = LEN(Y.FCY.CCY.AMT)
    Y.FCY.AMT.FINAL = SUBSTRINGS(Y.FCY.CCY.AMT,4,Y.FCY.AMT.LEN)
    EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne, Y.TT.AMT.LOC.CALC)

RETURN
END