SUBROUTINE GB.JBL.I.MCD.TP.VALID
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------------------

*CODE PURPOSE:Transaction Profile Validation(Multiple Debit Credit).

*APPLICATION USE:FUNDS.TRANSFER,ACCOUNT,STMT.ENTRY,TELLER And EB.JBL.DCC.TP
*FUNCTION USE: OPF(),EB.READLIST(),F.READ(),WRITE(),EB.ACCT.ENTRY.LIST(),R.NEW(),FIELD().
*FUNCTION USE: DCOUNT(),STORE.OVERRIDE(),IF(),ELSEIF(),ELSE().
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.H.MUL.MCD
*    $INSERT BP I_F.EB.JBL.DCC.TP
    $INSERT I_F.ACCOUNT


    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING AC.AccountOpening

    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

*------
INIT:
*------

    FN.MCD ='FBNK.JBL.H.MUL.MCD'
    F.MCD = ''
*    FN.TP = 'FBNK.EB.JBL.DCC.TP'
*    F.TP = ''

RETURN

*---------
OPENFILE:
*---------
    EB.DataAccess.Opf(FN.MCD,F.MCD)
*    EB.DataAccess.Opf(FN.TP,F.TP)

RETURN

*---------
PROCESS:
*---------
    IF APPLICATION EQ 'JBL.H.MUL.MCD' THEN
        Y.AC.ID = EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO)
        Y.DP.AC.ID = EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO)
        Y.FT.AMT = EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)
        Y.CHK.AMT = Y.FT.AMT
        Y.MCD.CR.AMT = EB.SystemTables.getRNew(MCD.CREDIT.AMOUNT)
        Y.CR.CHK.AMT = Y.MCD.CR.AMT

        Y.AC.CNT = DCOUNT(Y.AC.ID,@VM)
        Y.DP.AC.CNT = DCOUNT(Y.DP.AC.ID,@VM)
    END

*---------------------------For Withdwawal(Start)------------------------------------------------
    !DEBUG
    FOR M = 1 TO Y.AC.CNT
        Y.MCD.AC.ID = FIELD(Y.AC.ID,@VM,M)
        Y.MCD.CHK.AMT = FIELD (Y.CHK.AMT,@VM,M)
        Y.MCD.DR.AMT = Y.MCD.CHK.AMT

*        IF ISALPHA(LEFT(Y.MCD.AC.ID,2)) EQ '0' THEN
*            EB.DataAccess.FRead(FN.TP,Y.MCD.AC.ID,R.TP.REC,F.TP,Y.TP.ERR)
*            Y.TRNC.STATUS = R.TP.REC<EB.JBL52.WITH.PARTICULAR>
*            Y.MAX.TRNC = R.TP.REC<EB.JBL52.WITH.NO.TXN.MON>
*            Y.MAX.TRNS.AMT = R.TP.REC<EB.JBL52.WITH.MAX.TXN.AM>
*            Y.MCD.WITH.TOT.AMT = R.TP.REC<EB.JBL52.WITH.TOT.AMT>
*            Y.TRNC.STATUS.CNT = DCOUNT(Y.TRNC.STATUS,@VM)

*        FOR I = 1 TO Y.TRNC.STATUS.CNT
*            Y.TRNC.STATUS.OBO = FIELD(Y.TRNC.STATUS,@VM,I)
*            IF Y.TRNC.STATUS.OBO EQ 'Paid by Transfer/Instrument' THEN
*                Y.MAX.TRNC.OBO = FIELD(Y.MAX.TRNC,@VM,I)
*                Y.MAX.TRNS.AMT.OBO = FIELD(Y.MAX.TRNS.AMT,@VM,I)
*                Y.MCD.WITH.TOT.AMT.OBO = FIELD(Y.MCD.WITH.TOT.AMT,@VM,I)
*                BREAK
*            END
*
*        NEXT I
*        IF Y.MCD.DR.AMT GT Y.MAX.TRNS.AMT.OBO THEN
*            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
*            EB.SystemTables.setAv(M)
*            V.NO = DCOUNT(R.NEW(MCD.OVERRIDE), VM) + 1
*            !TEXT = 'DUP.CONTRACT'
*            EB.SystemTables.setText('Your Amount Limit is over in Debit Account(Multiple Debit Credit(Withdraw));Please Update Your TP in ': Y.MCD.AC.ID:';')
*            EB.OverrideProcessing.StoreOverride(V.NO)
*        END
*    END
    NEXT M
*------------------------For Withdrawal(End)-----------------------------------------------------
*************************************************************************************************
*------------------------For Deposit (Start)-----------------------------------------------------
    FOR I = 1 TO Y.DP.AC.CNT
        Y.MCD.DP.AC.ID = FIELD(Y.DP.AC.ID,@VM,I)
        Y.MCD.CR.AMT = FIELD(Y.CR.CHK.AMT,@VM,I)
        Y.MCD.DP.CR.CHK.AMT = Y.MCD.CR.AMT

        IF ISALPHA(LEFT(Y.MCD.DP.AC.ID,2)) EQ '0' THEN
*        EB.DataAccess.FRead(FN.TP,Y.MCD.DP.AC.ID,R.DP.ACC.REC,F.TP,Y.DP.ACC.ERR)
*        Y.DP.TRNC.STATUS = R.DP.ACC.REC<EB.JBL52.DEP.PARTICULARS>
*        Y.DP.MAX.TRNC = R.DP.ACC.REC<EB.JBL52.NO.TXN.MON>
*        Y.DP.MAX.TRNS.AMT = R.DP.ACC.REC<EB.JBL52.MAX.TXN.AMT>
*        Y.DP.TOT.AMT = R.DP.ACC.REC<EB.JBL52.DEP.TOT.AMT>
*        Y.DP.TRNC.STATUS.CNT = DCOUNT(Y.DP.TRNC.STATUS,@VM)

*        FOR K = 1 TO Y.DP.TRNC.STATUS.CNT
*            Y.DP.TRNC.STATUS.OBO = FIELD(Y.DP.TRNC.STATUS,@VM,K)
*            IF Y.DP.TRNC.STATUS.OBO EQ 'Deposted by Transfer/Instrument' THEN
*                Y.DP.MAX.TRNC.OBO = FIELD(Y.DP.MAX.TRNC,@VM,K)
*                Y.DP.MAX.TRNS.AMT.OBO = FIELD(Y.DP.MAX.TRNS.AMT,@VM,K)
*                Y.DP.TOT.AMT.OBO = FIELD(Y.DP.TOT.AMT,@VM,K)
*                BREAK
*            END
*        NEXT K
*        IF Y.MCD.DP.CR.CHK.AMT GT Y.DP.MAX.TRNS.AMT.OBO THEN
*            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
*            EB.SystemTables.setAv(P)
*            V.NO = DCOUNT(R.NEW(MCD.OVERRIDE), VM) + 1
*            !TEXT = 'DUP.CONTRACT'
*            EB.SystemTables.setText('Your Amount Limit is over in Credit Account(Multiple Debit Credit(Deposit));Please Update Your TP in ':Y.MCD.DP.AC.ID:';')
*            EB.OverrideProcessing.StoreOverride(V.NO)
*        END
        END
    NEXT I
RETURN
END
******************************************FOR DEPOSIT(END)**********************************************

