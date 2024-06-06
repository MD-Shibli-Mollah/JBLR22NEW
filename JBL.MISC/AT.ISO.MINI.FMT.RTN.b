SUBROUTINE AT.ISO.MINI.FMT.RTN(REQ.NO.OF.STMTS,Y.ACCT.NO,R.ACCT,TXN.DETLS.DETS)
*    -----------------------------------------------------------------------------------------------------------------------
** <Rating>-77</Rating>
*    -----------------------------------------------------------------------------------------------------------------------
*
**-----------------------------------------------------------------------------
** Subroutine Type : PROCEDURE
** Attached to     :
** Attached as     : CALL ROUTINE
** Primary Purpose :
** This routine formats the Mini Statement Details
**-----------------------------------------------------------------------------
** Incoming : REQ.NO.OF.STMTS,Y.ACCT.NO,R.ACCT
**---------------
** Outgoing : TXN.DETLS.DETS
**---------------
** Dependencies :
**---------------
** CALLS     : AT.ISO.FMT.BAL.RTN routine
** CALLED BY : -NA-
**-----------------------------------------------------------------------------
** Developed for ATM Framework ISO 8583-87/93 message standards
** Developer: Gpack ATM
**-----------------------------------------------------------------------------
** Modification History :
**
** 24/12/2013 - Ref 866817 / Task 866826
**              Movement to Core
**
** 30/10/15 - Task - 1516944
**          - Convert the routine to Encapsulation framework
**-----------------------------------------------------------------------------
*
*    $USING EB.SystemTables
*    $USING AC.AccountOpening
*    $USING ST.CurrencyConfig
*    $USING ATMFRM.Foundation
*    $USING AC.EntryCreation
*    $USING ST.AccountStatement
*    $USING EB.API
*    $USING ST.Config
*    $USING ATMFRM.Mapping
*
*
*    GOSUB INIT
*    GOSUB PROCESS
*RETURN
*
**-----------------------------------------------------------------------------
*INIT:
**-----------------------------------------------------------------------------
*
*    Y.STMT.ID.LIST=''
*    Y.STMT.ID=''
*    STMT.TXT=''
*    Y.SEL.STMT.PRINTED=''
*    Y.SELECTED.PRINTED=''
*    Y.SEL.PRINTED.ER=''
*    Y.STMT.PRINTED.ID=''
*    INTRF.MSG.ID = ATMFRM.Foundation.getAtIntrfMsgId()
*
*RETURN
**-----------------------------------------------------------------------------
*PROCESS:
**-----------------------------------------------------------------------------
*    CCY.CODE = R.ACCT<AC.AccountOpening.Account.Currency>
*    R.CCY = ST.CurrencyConfig.Currency.Read(CCY.CODE, ER.CCY)
*
*    NUM.CCY = R.CCY<ST.CurrencyConfig.Currency.EbCurNumericCcyCode>
*    NUM.CCY = FMT(NUM.CCY,'R%3')
*    NO.DEC = R.CCY<ST.CurrencyConfig.Currency.EbCurNoOfDecimals>
*
*    GOSUB GET.STMT.IDS
*
*RETURN
**-----------------------------------------------------------------------------
*GET.STMT.IDS:
**-----------------------------------------------------------------------------
*
*    R.ACCT.STMT.PRINTED = ST.AccountStatement.AcctStmtPrint.Read(Y.ACCT.NO, PR.ERR)
*
*    IF NOT(R.ACCT.STMT.PRINTED) THEN
*        RETURN
*    END
*    STMT.PRINT.CTR = 1
*    AC.STMT.CTR = DCOUNT(R.ACCT.STMT.PRINTED,@FM)
*
*    LOOP
*        WHILE(AC.STMT.CTR AND STMT.PRINT.CTR LE REQ.NO.OF.STMTS)
*        Y.STMT.PRINTED.ID = R.ACCT.STMT.PRINTED<AC.STMT.CTR>
*        Y.STMT.PRINTED.ID = Y.ACCT.NO:"-":FIELD(Y.STMT.PRINTED.ID,"/",1)
*        Y.STMT.PRINT.REC = ""
*        Y.STMT.PRINT.REC = ST.AccountStatement.StmtPrinted.Read(Y.STMT.PRINTED.ID, Y.ERR)
*
*        STMT.CTR = DCOUNT(Y.STMT.PRINT.REC,@FM)
*
*        LOOP
*            WHILE(STMT.CTR AND STMT.PRINT.CTR LE REQ.NO.OF.STMTS)
*            STMT.ID = Y.STMT.PRINT.REC<STMT.CTR>
*            GOSUB READ.STMT.ENTRIES
*            STMT.CTR = STMT.CTR - 1
*            STMT.PRINT.CTR = STMT.PRINT.CTR + 1
*        REPEAT
*
*        AC.STMT.CTR = AC.STMT.CTR - 1
*
*    REPEAT
*
*    IF INTRF.MSG.ID EQ '5004' THEN
*        STMT.TXT = FMT(STMT.TXT,"L#400")
*        TXN.DETLS = LOWER(STMT.TXT)
*    END ELSE
*        TXN.DETLS = LOWER(STMT.TXT)
*    END
*
*    NO.OF.TXNS = FMT(DCOUNT(TXN.DETLS,@VM),"R%2")
*
*    CHANGE @VM TO '' IN TXN.DETLS
*    IF ATMFRM.Foundation.getAtAtIntrfMapping() THEN
*        FldRtn = ATMFRM.Foundation.getAtAtIntrfMapping()<ATMFRM.Mapping.IntrfMapping.IntrfMapPreRtn,1>
*        CompFlag= ''
*        EB.API.CheckRoutineExist(FldRtn,CompFlag,RetInfo)
*    END
*    IF CompFlag EQ '1' THEN
*
*        CALL @FldRtn(Y.ACCT.NO,R.ACCT,tmp.BalAftTxn)
*        ATMFRM.Foundation.setBalafttxn(tmp.BalAftTxn)
*    END
*
*    TXN.DETLS.DETS = TXN.DETLS:',':"BAL.AFT.TXN:1:1=":ATMFRM.Foundation.getBalafttxn()
*
*RETURN
**-----------------------------------------------------------------------------
*READ.STMT.ENTRIES:
**-----------------------------------------------------------------------------
*
*    Y.STMT.REC = AC.EntryCreation.StmtEntry.Read(STMT.ID, Y.ERR.STMT.ENTRY)
*
*    IF R.ACCT<AC.AccountOpening.Account.Currency> EQ EB.SystemTables.getLccy() THEN
*        Y.TXN.AMT = Y.STMT.REC<AC.EntryCreation.StmtEntry.SteAmountLcy>
*    END ELSE
*        Y.TXN.AMT = Y.STMT.REC<AC.EntryCreation.StmtEntry.SteAmountFcy>
*    END
*    Y.DT.TXN = Y.STMT.REC<AC.EntryCreation.StmtEntry.SteBookingDate>
*    Y.TXN.CODE = Y.STMT.REC<AC.EntryCreation.StmtEntry.SteTransactionCode>
*    Y.TIME.TXN = Y.STMT.REC<AC.EntryCreation.StmtEntry.SteDateTime,1>
*    TRANSACTION.REC = ''
*    TRAN.READ.ERR = ''
*
*    TRANSACTION.REC = ST.Config.Transaction.Read(Y.TXN.CODE, TRAN.READ.ERR)
*    Y.TRAN.DESC = TRANSACTION.REC<ST.Config.Transaction.AcTraNarrative>
*
*    IF INTRF.MSG.ID EQ '5004' THEN
*        GOSUB GET.PHX.ENTRIES
*    END ELSE
*        GOSUB GET.ATM.ENTRIES
*    END
*
*RETURN
**-----------------------------------------------------------------------------
*GET.ATM.ENTRIES:
**-----------------------------------------------------------------------------
*    IF INDEX(Y.TXN.AMT,'-',1) THEN
*        Y.TXN.AMT = FIELD(Y.TXN.AMT,'-',2)
*        Y.SIGN = "D"
*    END ELSE        ;*PACS00227453
*        Y.SIGN = "C"
*    END
*
*    Y.TXN.AMT1 = FIELD(Y.TXN.AMT,'.',1)
*    Y.TXN.AMT2 = FIELD(Y.TXN.AMT,'.',2)
*    Y.TXN.AMT2 = FMT(Y.TXN.AMT2,'L%':NO.DEC)
*
*    Y.TXN.AMT = Y.TXN.AMT1:Y.TXN.AMT2
*    Y.TXN.AMT = FMT(Y.TXN.AMT,'R%12')
*
*    Y.DT.TXN.LEN=LEN(Y.DT.TXN)
*    Y.DT.TXN=Y.DT.TXN[3,Y.DT.TXN.LEN]
*
*    Y.TRAN.DESC = Y.TRAN.DESC[1,28]
*    Y.TRAN.DESC = FMT(Y.TRAN.DESC,"28' 'L")
*    Y.TIME.TXN = Y.TIME.TXN[7,4]
*
*    ONE.LINE = Y.DT.TXN:NUM.CCY:Y.SIGN:Y.TXN.AMT
*    STMT.TXT<-1> = ONE.LINE
*
*RETURN          ;*From READ.STMT.ENTRIES
**-----------------------------------------------------------------------------
*GET.PHX.ENTRIES:
**-----------------------------------------------------------------------------
*
*    STMT.DT = Y.DT.TXN[7,2]:'-':Y.DT.TXN[5,2]:'-':Y.DT.TXN[3,2]
*
*    Y.TRANS.DESC = FMT(UPCASE(Y.TRAN.DESC),"L#16")
*
*    IF INDEX(Y.TXN.AMT,'-',1) THEN
*        Y.TXN.AMT = FIELD(Y.TXN.AMT,'-',2)
*        Y.SIGN = " DB"
*        IF LEN(Y.TXN.AMT) GT 16 THEN
*            Y.TXN.AMT = Y.TXN.AMT[4,16]:Y.SIGN
*        END ELSE
*            Y.TXN.AMT = Y.TXN.AMT:Y.SIGN
*            Y.TXN.AMT = FMT(Y.TXN.AMT,"R#16")
*        END
*
*    END ELSE
*        Y.TXN.AMT = FMT(Y.TXN.AMT,"R#16")
*    END
*
*    ONE.LINE = STMT.DT:Y.TRANS.DESC:Y.TXN.AMT
*    STMT.TXT<-1> = ONE.LINE
*
*RETURN
*
*END
