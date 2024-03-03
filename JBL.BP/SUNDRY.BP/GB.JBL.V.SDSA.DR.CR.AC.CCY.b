SUBROUTINE GB.JBL.V.SDSA.DR.CR.AC.CCY
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*Subroutine Description: USED TO UPDATE LOCKING FILE WHILE CREATING TELLER , FUNDS TRANSFER VERSION RECORD ID
* ATTACH FUNDS TRANSFER AND TELLER VERSION FUNDS.TRANSFER,JBL.SUSP.ORG, FUNDS.TRANSFER,JBL.SUSP.ADJ
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING FT.Contract
    $USING AC.AccountOpening
    $USING EB.DataAccess
    $USING EB.SystemTables

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

INIT:
*
    FN.AC = 'F.ACCOUNT'
    F.AC = ''
*
*    FN.FT = 'F.FUNDS.TRANSFER'
*    F.FT = ''
*
*    FN.TT = 'F.TELLER'
*    F.TT = ''
*
*    FN.CAT = 'F.CATEGORY'
*    F.CAT = ''
*
*    FN.SDSA.ENTRY = 'F.BD.SDSA.ENTRY.DETAILS'
*    F.SDSA.ENTRY = ''
RETURN

OPENFILES:

    EB.DataAccess.Opf(FN.AC,F.AC)

RETURN

PROCESS:

    Y.AC.ID = EB.SystemTables.getComi()

    EB.DataAccess.FRead(FN.AC,Y.AC.ID,AC.REC,F.AC,AC.ERR)
    Y.AC.CCY = AC.REC<AC.AccountOpening.Account.Currency>

    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        IF Y.AC.ID[1,2] NE "PL" THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitCurrency,Y.AC.CCY)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditCurrency,Y.AC.CCY)
        END ELSE
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitCurrency,"USD")
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditCurrency,"USD")
        END
    END

RETURN

END
