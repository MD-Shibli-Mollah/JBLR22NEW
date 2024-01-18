* @ValidationCode : MjotMTg1MTMyNjk0MTpDcDEyNTI6MTU5NDYyNTE1NjMxMDpERUxMOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 13 Jul 2020 13:25:56
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : DELL
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
SUBROUTINE CR.JBL.AMC.CALC.LOAN(arrId,arrProp,arrCcy,arrRes,balanceAmount,perDat)
*-----------------------------------------------------------------------------
*
* 1)
*    Date : 05/05/2021
*    Modification Description :
*    Created By  : shajjad Hossen - shossain@fortress-global.com - FDS Ltd.
*
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_AA.APP.COMMON
    $INSERT I_F.BD.CHG.INFORMATION
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCT.BALANCE.ACTIVITY
    
    $USING EB.SystemTables
    $USING AA.Framework
    $USING EB.DataAccess
    $USING LI.Config
    $USING AA.Account
    $USING AC.AccountOpening
    $USING EB.Interface
    $USING EB.Updates
    $USING EB.TransactionControl
    $USING ST.ChargeConfig
    $USING EB.API
    $USING AA.ActivityRestriction
    $USING AC.BalanceUpdates
    $USING AA.Limit
*-----------------------------------------------------------------------------
    CompanyToLeaveAmc = 'BD0013109':FM:'BD0013117':FM:'BD0013118':FM:'BD0013121':FM:'BD0013129':FM:'BD0013139':FM:'BD0013143':FM:'BD0013150':FM:'BD0013155':FM:'BD0013164':FM:'BD0013302':FM:'BD0013310':FM:'BD0013327':FM:'BD0013341':FM:'BD0013348'
    CompanyId = EB.SystemTables.getIdCompany()
    LOCATE CompanyId IN CompanyToLeaveAmc SETTING Y.POS.1 THEN
        balanceAmount = 0
        RETURN
    END
    
    IF EB.SystemTables.getVFunction() EQ 'I' THEN RETURN
    IF EB.SystemTables.getVFunction() EQ 'V' THEN RETURN
    IF EB.SystemTables.getVFunction() EQ 'A' THEN RETURN
    IF (OFS$OPERATION EQ 'VALIDATE' OR OFS$OPERATION EQ 'PROCESS') AND c_aalocCurrActivity EQ 'LENDING-ISSUEBILL-SCHEDULE*DISBURSEMENT.%' THEN RETURN

    GOSUB INIT
    GOSUB OPENFILES

    IF c_aalocCurrActivity EQ 'LENDING-MAKEDUE-SCHEDULE' OR c_aalocCurrActivity EQ 'ACCOUNTS-CAPITALISE-SCHEDULE' THEN
        GOSUB PROCESS
    END
RETURN

*****
INIT:
*****

    FN.FTCT = 'F.FT.COMMISSION.TYPE'
    F.FTCT = ''
    FN.AA.ARRG = 'F.AA.ARRANGEMENT'
    F.AA.ARRG = ''
    FN.LMT = 'F.LIMIT'
    F.LMT = ''
    
    arrangementId = ''
    balanceAmount = 0

RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.FTCT,F.FTCT)
    EB.DataAccess.Opf(FN.AA.ARRG, F.AA.ARRG)
    EB.DataAccess.Opf(FN.LMT, F.LMT)
RETURN

********
PROCESS:
********
    ArrangementId = arrId
    EB.DataAccess.FRead(FN.AA.ARRG, arrId, R.AA.ARRG, F.AA.ARRG, Er)
    ArrStartDate = R.AA.ARRG<AA.Framework.Arrangement.ArrStartDate>
    Y.LN.CUS = R.AA.ARRG<AA.Framework.Arrangement.ArrCustomer>
    
    Y.PROP.CLASS = 'LIMIT'
    AA.Framework.GetArrangementConditions(ArrangementId,Y.PROP.CLASS,PROPERTY,'',RETURN.IDS,RETURN.VALUES,ERR.MSG)
    R.REC = RAISE(RETURN.VALUES)
    Y.LIMIT.REF = R.REC<AA.Limit.Limit.LimLimitReference>
    Y.LIMIT.SR = R.REC<AA.Limit.Limit.LimLimitSerial>
    Y.LMT.ID = Y.LN.CUS : '.000' : Y.LIMIT.REF : '.' : Y.LIMIT.SR

    EB.DataAccess.FRead(FN.LMT, Y.LMT.ID, REC.LMT, F.LMT, E.LMT)
    Y.LMT.AMT = REC.LMT<LI.Config.Limit.InternalAmount>
    Y.LMT.AVL = REC.LMT<LI.Config.Limit.AvailAmt>
    
    Y.FTCT.ID = 'AMCLN'
    EB.DataAccess.FRead(FN.FTCT,Y.FTCT.ID,R.FTCT,F.FTCT,FT.CT.ERR)
    Y.UPTO.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouUptoAmt>
    Y.MIN.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouMinimumAmt>
    Y.FLAT.AMT = R.FTCT<ST.ChargeConfig.FtCommissionType.FtFouFlatAmt>
    
    CHARGE.AMOUNT = Y.FLAT.AMT
    IF CHARGE.AMOUNT EQ '' THEN
        CONVERT SM TO VM IN Y.UPTO.AMT
        CONVERT SM TO VM IN Y.MIN.AMT
        Y.DCOUNT = DCOUNT(Y.UPTO.AMT,VM)
        FOR I = 1 TO Y.DCOUNT
            Y.AMT = Y.UPTO.AMT<1,I>
            IF Y.AMT NE '' AND Y.LMT.AMT LE Y.AMT THEN
                BREAK
            END ELSE
                CHARGE.AMOUNT = Y.MIN.AMT<1,I>
            END
        NEXT I
        CHARGE.AMOUNT = Y.MIN.AMT<1,I>
    END
    balanceAmount = CHARGE.AMOUNT
RETURN
END