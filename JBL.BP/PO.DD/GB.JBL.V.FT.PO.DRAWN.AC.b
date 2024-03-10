
SUBROUTINE GB.JBL.V.FT.PO.DRAWN.AC
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Subroutine Description:
* THIS ROUTINE is used to GET DEBIT FT ACCOUNT FOR PO FT ISSUE
* Attach To: VERSION(FUNDS.TRANSFER,MBL.PO.ISSUE)
* Attach As: VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 10/08/2020 -                             NEW   -NILOY SARKAR
*                                                 NITSL Limited
* 09/03/2024 -                             UPDATE - MD SHIBLI MOLLAH
*                                                   NITSL Limited
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING CQ.ChqConfig
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
*** <desc> </desc>
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""
    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    
    FN.CHEQUE.TYPE = "CHEQUE.TYPE"
    F.CHEQUE.TYPE = ""
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.TELLER, F.TELLER)
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc> </desc>
    Y.CATEG.AC = ""
* Y.CATEG.AC = 'BDT177060001'
* Y.CATEG.AC = 'BDT17706'

    Y.APP = EB.SystemTables.getApplication()
    
    IF Y.APP EQ "FUNDS.TRANSFER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, Rec.PO, F.CHEQUE.TYPE, ERR)
        Y.CAT = Rec.PO<CQ.ChqConfig.ChequeType.ChequeTypeCategory>
        Y.CATEG.AC = "BDT":Y.CAT
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
    
    IF Y.APP EQ "TELLER" THEN
        Y.TT.ISS.CHQ.TYP = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, Rec.PO, F.CHEQUE.TYPE, ERR)
        Y.CAT = Rec.PO<CQ.ChqConfig.ChequeType.ChequeTypeCategory>
        Y.CATEG.AC = "BDT":Y.CAT
        EB.SystemTables.setComi(Y.CATEG.AC)
    END
RETURN
*** </region>
END

