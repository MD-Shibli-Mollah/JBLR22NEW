SUBROUTINE GB.JBL.I.AZ.ACCT.FT.BLOCK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.AZ.ACCOUNT
*    $INSERT I_F.JBL.H.BK.MCD
    $INSERT I_F.EB.JBL.RD.BASE.CATEG
    $INSERT I_F.JBL.H.MUL.MCD
   
   
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING  AC.AccountOpening
    $USING  FT.Contract
    $USING  AZ.Contract
    $USING  TT.Contract
        
   

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS

******
INIT:
******
    FN.ACCOUNT = 'FBNK.ACCOUNT'
    F.ACCOUNT = ''
    FN.FT = 'FBNK.FUNDS.TRANSFER'
    F.FT = ''
    FN.AZ.ACCT = 'FBNK.AZ.ACCOUNT'
    F.AZ.ACCT = ''
    FN.RD.BASE.CATEG = 'FBNK.EB.JBL.RD.BASE.CATEG'
    F.RD.BASE.CATEG = ''

RETURN

***********
OPENFILES:
***********
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)
    EB.DataAccess.Opf(FN.AZ.ACCT,F.AZ.ACCT)
    EB.DataAccess.Opf(FN.RD.BASE.CATEG,F.RD.BASE.CATEG)
    EB.DataAccess.Opf(FN.FT,F.FT)
RETURN

********
PROCESS:
********
    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.DR.ACC.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        Y.CR.ACC.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        Y.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
        IF Y.STATUS NE 'IHLD' THEN
            GOSUB MSG.PRINT
        END
    END

    IF APPLICATION EQ 'TELLER' THEN
        Y.CR.ACC.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        GOSUB MSG.PRINT
    END

    IF APPLICATION EQ 'JBL.H.MUL.MCD' THEN
        Y.CR.ACC.NO.CNT = DCOUNT(EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO),@VM)
        IF Y.CR.ACC.NO.CNT EQ 1 THEN
            Y.CR.ACC.NO = EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO)
            GOSUB MSG.PRINT
        END ELSE
            FOR I=1 TO Y.CR.ACC.NO.CNT
                Y.CR.ACC.NO = EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO)<1,I>
                GOSUB MSG.PRINT
            NEXT I
        END
    END
   
   
*    IF APPLICATION EQ 'JBL.H.BK.MCD' THEN
*        Y.CR.ACC.NO.CNT = DCOUNT(EB.SystemTables.getRNew(MCD.BK.CREDIT.ACCT.NO),@VM)
*        IF Y.CR.ACC.NO.CNT EQ 1 THEN
*            Y.CR.ACC.NO = EB.SystemTables.getRNew(MCD.BK.CREDIT.ACCT.NO)
*            GOSUB MSG.PRINT
*        END ELSE
*            FOR I=1 TO Y.CR.ACC.NO.CNT
*                Y.CR.ACC.NO = EB.SystemTables.getRNew(MCD.BK.CREDIT.ACCT.NO)<1,I>
*                GOSUB MSG.PRINT
*            NEXT I
*        END
*       END
RETURN
************
MSG.PRINT:
************
    EB.DataAccess.FRead(FN.ACCOUNT,Y.DR.ACC.NO,R.DR.ACCT,F.ACCOUNT,Y.ERR.DR)
    Y.DR.CATEG = R.DR.ACCT<AC.AccountOpening.Account.Category>
    !EB.DataAccess.FRead(FN.AZ.ACCT,Y.DR.ACC.NO,R.DR.AZ.ACCT,F.AZ.ACCT,Y.ERR.DR.AZ)

    EB.DataAccess.FRead(FN.ACCOUNT,Y.CR.ACC.NO,R.CR.ACCT,F.ACCOUNT,Y.ERR.CR)
    Y.CR.CATEG = R.CR.ACCT<AC.AccountOpening.Account.Category>
    !EB.DataAccess.FRead(FN.AZ.ACCT,Y.CR.ACC.NO,R.CR.AZ.ACCT,F.AZ.ACCT,Y.ERR.CR.AZ)

    EB.DataAccess.FRead(FN.RD.BASE.CATEG,'SYSTEM',R.RD.CATEG,F.RD.BASE.CATEG,Y.RD.ERR)
    Y.RD.CATEG = R.RD.CATEG<EB.RD.69.CATEGORY>

    !IF R.DR.AZ.ACCT EQ '' THEN
    FINDSTR Y.DR.CATEG IN Y.RD.CATEG SETTING POS THEN
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
*  ETEXT = 'Debit Account is a Base Account'
        EB.SystemTables.setEtext("Debit Account is a Base Account")
        EB.ErrorProcessing.StoreEndError()
    END
    !END
    !IF R.CR.AZ.ACCT EQ '' THEN
    

    FINDSTR Y.CR.CATEG IN Y.RD.CATEG SETTING POS THEN
        BEGIN CASE

            CASE APPLICATION EQ 'TELLER'
                EB.SystemTables.setAf(TT.Contract.Teller.TeAccountOne)

            CASE APPLICATION EQ 'FUNDS.TRANSFER'
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.CreditAcctNo)

            CASE APPLICATION EQ 'JBL.H.MUL.MCD'
                EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
*    CRT "HELLO"
*            CASE APPLICATION EQ 'JBL.H.BK.MCD'
*                EB.SystemTables.setAf(MCD.BK.CREDIT.ACCT.NO)
        END CASE

        EB.SystemTables.setEtext("Credit Account is a Base Account")
**   ETEXT = 'Credit Account is a Base Account'
        EB.ErrorProcessing.StoreEndError()
    END
    !END
RETURN
END