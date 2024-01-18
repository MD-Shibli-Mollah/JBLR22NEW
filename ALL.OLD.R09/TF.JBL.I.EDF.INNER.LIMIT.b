SUBROUTINE TF.JBL.I.EDF.INNER.LIMIT
*-----------------------------------------------------------------------------
*VERSION NAME : FUNDS.TRANSFER,JBL.AA.ACDI.EDF
*-----------------------------------------------------------------------------
* Modification History :
* 29/03/2021 -                            Retrofit   - SHAJJAD HOSSEN
*                                                 FDS Ltd
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
     
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING FT.Contract
    $USING EB.DataAccess
    $USING AC.AccountOpening
    $USING AA.Framework
    $USING LI.Config
    $USING ST.CurrencyConfig
    $USING LI.LimitTransaction
    $USING LI.GroupLimit
    $USING AC.CashFlow

    
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
INIT:
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    
    FN.AA = 'F.AA.ARRANGEMENT'
    F.AA = ''
    
    FN.LMT = 'F.LIMIT'
    F.LMT = ''
    
    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    
    Y.EDF.INT.BAL = ''
    Y.EDF.BAL = ''
    
RETURN
OPENFILES:
    EB.DataAccess.Opf(FN.ACC, F.ACC)
    EB.DataAccess.Opf(FN.AA, F.AA)
    EB.DataAccess.Opf(FN.LMT, F.LMT)
    EB.DataAccess.Opf(FN.CUR, F.CUR)
RETURN

PROCESS:
    GOSUB FT.INFO
    GOSUB DEBIT.ACCOUNT.INFO
    GOSUB LIMIT.INFO
    GOSUB LIMIT.ACCOUNT.BAL.CALC
    GOSUB CREDIT.BALANCE
    GOSUB LIMIT.AVAIL.AMOUNT.CALC
    
    IF Y.PRD.GRP EQ 'JBL.EDF.LN' THEN
        IF Y.DBT.CUS EQ Y.CRDT.CUS THEN
            IF Y.DBT.LMT.REF EQ Y.CRDT.LMT.REF THEN
                IF Y.AVAIL.LMT.AMT GE '0' THEN
                    IF Y.CHLD.AVL.LMT GE '0' THEN
                        IF Y.DEBIT.AMT GT Y.CR.BAL THEN
                            Y.EXCS = 'Dr Amt Exceeded Cr Account Balances by ' : Y.EXCED.AMT
                            EB.SystemTables.setEtext(Y.EXCS)
                            EB.ErrorProcessing.StoreEndError()
                        END
                    END ELSE
                        EB.SystemTables.setEtext("LI-EXCESS.ID")
                        EB.ErrorProcessing.StoreEndError()
                    END
                END ELSE
                    EB.SystemTables.setEtext("LI-EXCESS.ID")
                    EB.ErrorProcessing.StoreEndError()
                END
            END ELSE
                EB.SystemTables.setEtext("LI-EXCESS.ID")
                EB.ErrorProcessing.StoreEndError()
            END
        END ELSE
            EB.SystemTables.setEtext("DEBIT CUSTOMER AND CREDIT CUSTOMER SHOULD BE SAME")
            EB.ErrorProcessing.StoreEndError()
        END
    END ELSE
        EB.SystemTables.setEtext("LI-EXCESS.ID")
        EB.ErrorProcessing.StoreEndError()
    END

RETURN
*=============================================================================
*=============================================================================
DEBIT.ACCOUNT.INFO:
    EB.DataAccess.FRead(FN.ACC, Y.DBT.AC, REC.DBT, F.ACC, E.DBT)
    Y.DBT.LMT.REF = REC.DBT<AC.AccountOpening.Account.LimitRef>
    Y.DBT.LMT.PROD = Y.DBT.LMT.REF(1,4)
    Y.DBT.LMT.SRL = Y.DBT.LMT.REF(6,2)
    Y.DBT.AA = REC.DBT<AC.AccountOpening.Account.ArrangementId>
    Y.DBT.CUS = REC.DBT<AC.AccountOpening.Account.Customer>
    EB.DataAccess.FRead(FN.AA, Y.DBT.AA, REC.AA, F.AA, E.AA)
    Y.PRD.GRP = REC.AA<AA.Framework.Arrangement.ArrProductGroup>
    Y.AA.CUS = REC.AA<AA.Framework.Arrangement.ArrCustomer>
RETURN
*============================================================================
*=============================================================================
FT.INFO:
    Y.FT.ID = EB.SystemTables.getIdNew()
    Y.DBT.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
    Y.DBT.AC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
    Y.CRDT.AC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
    Y.TRSR.RT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.TreasuryRate)
    Y.DEBIT.AMT = Y.DBT.AMT*Y.TRSR.RT
RETURN
*=========================================================================
*=============================================================================
LIMIT.INFO:
    Y.LMT.ID = Y.AA.CUS : '.000' : Y.DBT.LMT.REF
    EB.DataAccess.FRead(FN.LMT, Y.LMT.ID, REC.LMT, F.LMT, E.LMT)
    Y.CLD.LMT.AMT = REC.LMT<LI.Config.Limit.InternalAmount>
    Y.LMT.AVL = REC.LMT<LI.Config.Limit.AvailAmt>
    Y.ALL.ACCT = REC.LMT<LI.Config.Limit.Account>
    Y.LIM.LINE = REC.LMT<LI.Config.Limit.RecordParent>
    
    EB.DataAccess.FRead(FN.LMT, Y.LIM.LINE, REC.LMT.LINE, F.LMT, E.LMT)
    Y.LMT.LN.OST = REC.LMT.LINE<LI.Config.Limit.TotalOs>
    Y.LMT.AMT = REC.LMT.LINE<LI.Config.Limit.InternalAmount>
RETURN
*============================================================================
*=============================================================================
LIMIT.ACCOUNT.BAL.CALC:
    IF Y.ALL.ACCT NE '' THEN
        Y.ALL.ACCT.LIST = DCOUNT(Y.ALL.ACCT, @VM)
        FOR J = 1 TO Y.ALL.ACCT.LIST
            Y.EDF.ACC = Y.ALL.ACCT<1,J>
            EB.DataAccess.FRead(FN.ACC, Y.EDF.ACC, REC.EDF, F.ACC, E.EDF)
            Y.EDF.CUR = REC.EDF<AC.AccountOpening.Account.Currency>
            AC.CashFlow.AccountserviceGetworkingbalance(Y.EDF.ACC, REC.WRK.BAL, response.Details)
            Y.CUR.AMT = REC.WRK.BAL<AC.CashFlow.BalanceWorkingbal>
            GOSUB LIMIT.OUTSTANDING.CALC
        NEXT J
    END

    YCONV.CURRENCY = 'USD'
    LCCY = 'BDT'
    CALL LIMIT.CURR.CONV(YCONV.CURRENCY,Y.EDF.BAL,LCCY,Y.EDF.TK.AMT,Y.DBT.LMT.PROD)
RETURN
*==================================================================
*=============================================================================
LIMIT.OUTSTANDING.CALC:
    IF Y.CUR.AMT LT '0' THEN
        IF Y.EDF.CUR EQ "BDT" THEN
            Y.EDF.INT.BAL = Y.EDF.INT.BAL + Y.CUR.AMT
        END
        IF Y.EDF.CUR EQ "USD" THEN
            Y.EDF.BAL = Y.EDF.BAL + Y.CUR.AMT
        END
    END
RETURN
*=============================================================================
*=============================================================================
CREDIT.BALANCE:
    EB.DataAccess.FRead(FN.ACC, Y.CRDT.AC, REC.CRDT, F.ACC, E.CRDT)
    Y.CRDT.LMT.REF = REC.CRDT<AC.AccountOpening.Account.LimitRef>
    Y.CRDT.CUS = REC.CRDT<AC.AccountOpening.Account.Customer>
    Y.CR.CUR.BAL = REC.CRDT<AC.AccountOpening.Account.WorkingBalance>
    Y.CR.BAL = '-1' * Y.CR.CUR.BAL
    Y.EXCED.AMT.F = Y.DEBIT.AMT - Y.CR.BAL
    Y.EXCED.AMT = DROUND(Y.EXCED.AMT.F,2)
RETURN
*===========================================================================
*=============================================================================
LIMIT.AVAIL.AMOUNT.CALC:
    
    IF Y.LMT.LN.OST LT '0' THEN
        Y.LIM.OUT.AMT = Y.EDF.INT.BAL + Y.EDF.TK.AMT + Y.LMT.LN.OST
    END ELSE
        Y.LIM.OUT.AMT = Y.EDF.INT.BAL + Y.EDF.TK.AMT
    END
    Y.CHLD.OT.AMT = Y.EDF.INT.BAL + Y.EDF.TK.AMT
    Y.CHLD.AVL.LMT = Y.CLD.LMT.AMT + Y.CHLD.OT.AMT + Y.DEBIT.AMT
    Y.AVAIL.LMT.AMT = Y.LMT.AMT + Y.LIM.OUT.AMT + Y.DEBIT.AMT
RETURN

END
