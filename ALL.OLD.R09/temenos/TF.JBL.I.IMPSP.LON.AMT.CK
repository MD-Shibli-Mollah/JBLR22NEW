SUBROUTINE TF.JBL.I.IMPSP.LON.AMT.CK
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* Description : this routine check dr payment can't be gretter than PAD loan amount
*               that define in Account property.
* 11/24/2020 -                            Create by   - MAHMUDUR RAHMAN (UDOY),
*                                                 FDS Bangladesh Limited
* VERSION : DRAWINGS,JBL.IMPSP, DRAWINGS,JBL.IMPMAT, DRAWINGS,JBL.BTBSP, DRAWINGS,JBL.BTBMAT,
*           FUNDS.TRANSFER,JBL.AFTR.FTHP, FUNDS.TRANSFER,JBL.AA.ACDI

    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING EB.SystemTables
    $USING LC.Contract
    $USING EB.DataAccess
    $USING AA.Framework
    $USING EB.LocalReferences
    $USING AA.Account
    $USING ST.CurrencyConfig
    $USING AC.AccountOpening
    $USING AC.CashFlow
    $USING EB.ErrorProcessing
    $USING FT.Contract
    
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
*
RETURN
*-----------------------------------------------------------------------------
*-------
INIT:
*-------

    FN.DRW = 'F.DRAWINGS'
    F.DRW = ''
*
    FN.ACCT = 'F.ACCOUNT'
    F.ACCT = ''
    Y.DR.ACCT=''
    REC.ACCT.ID=''
    
    FN.CURR = 'F.CURRENCY'
    F.CURR = ''
    
    FN.ARR = 'F.AA.ARRANGEMENT'
    F.ARR = ''
    
    Y.ACCT.LN.AMT = 0
    Y.APP = EB.SystemTables.getApplication()
    
RETURN
*---------
OPENFILES:
*---------

    EB.DataAccess.Opf(FN.DRW,F.DRW)
    EB.DataAccess.Opf(FN.ACCT, F.ACCT)
    EB.DataAccess.Opf(FN.CURR, F.CURR)
    EB.DataAccess.Opf(FN.ARR, F.ARR)
RETURN
*---------
PROCESS:
    Y.WORK.BAL = 0
    Y.CHEK.AMT = 0
    !********FOR FT*******************************
    IF Y.APP EQ 'FUNDS.TRANSFER' THEN
        Y.DR.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    END
    !********FOR FT*******************************
    ELSE
        Y.DR.ACCT = EB.SystemTables.getRNew(LC.Contract.Drawings.TfDrDrawdownAccount)
    END
    IF ALPHA(Y.DR.ACCT[1,2]) THEN RETURN

    EB.DataAccess.FRead(FN.ACCT,Y.DR.ACCT, REC.ACCT.ID, F.ACCT.ID, ERR.ACCT.ID)
    IF REC.ACCT.ID EQ '' THEN RETURN
    Y.AA.ID = REC.ACCT.ID<AC.AccountOpening.Account.ArrangementId>
    Y.AA.CUR = REC.ACCT.ID<AC.AccountOpening.Account.Currency>
    EB.DataAccess.FRead(FN.ARR, Y.AA.ID, ARR.REC, F.ARR, ARR.ERR)
    Y.PROD.GP = ARR.REC<AA.Framework.Arrangement.ArrProductGroup>
    IF Y.PROD.GP EQ 'JBL.PAD.CASH.LN' OR Y.PROD.GP EQ 'JBL.EDF.INFIN.LN' OR Y.PROD.GP EQ 'JBL.EDF.LN' THEN
        GOSUB LN.AMT.CHK
        AC.CashFlow.AccountserviceGetworkingbalance(Y.DR.ACCT, REC.WRK.BAL, response.Details)
        Y.WORK.BAL = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>
        Y.WORK.BAL = ABS(Y.WORK.BAL)
        
        IF Y.WORK.BAL GT Y.ACCT.LN.AMT THEN
            Y.DIFF.AMT = Y.WORK.BAL - Y.ACCT.LN.AMT
            !********FOR FT*******************************
            IF Y.APP EQ 'FUNDS.TRANSFER' THEN
                EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitAcctNo)
                ETEXT = 'Debit Amount Greater Than Loan Amount By ': Y.DIFF.AMT
                EB.ErrorProcessing.StoreEndError()
            END
            !********FOR FT*******************************
            ELSE
                EB.SystemTables.setAf(LC.Contract.Drawings.TfDrDrawdownAccount)
                ETEXT = 'Debit Amount Greater Than Loan Amount By ': Y.DIFF.AMT
                EB.ErrorProcessing.StoreEndError()
            END
        END
    
    END
RETURN
*-----------
LN.AMT.CHK:
*-----------
    PROP.CLASS.SETT = 'ACCOUNT'
    AA.Framework.GetArrangementConditions(Y.AA.ID,PROP.CLASS.SETT,PROPERTY,'',RETURN.IDS.SETT,RETURN.VALUES.SETT,ERR.MSG.SETT)
    REC.DATA = RAISE(RETURN.VALUES.SETT)
    ACCT.LN.AMT = "LT.ACCT.LN.AMT"
    ACCT.AMOUNT.POS = ""
    EB.LocalReferences.GetLocRef("AA.ARR.ACCOUNT",ACCT.LN.AMT,ACCT.AMOUNT.POS)
    Y.ACCT.LN.AMT = REC.DATA<AA.Account.Account.AcLocalRef,ACCT.AMOUNT.POS>
RETURN

END