$PACKAGE BD.Soc
*
* Implementation of BD.Soc.SocGetEdChgAmt
*
* Y.ACCOUNTNO(IN) :
* Y.COM.CODE(IN) :
* Y.BASE.BALANCE(IN) :
* Y.CHG.AMT(OUT) :
* Y.DUE.AMT(OUT) :
*
SUBROUTINE BD.SOC.GET.EDCHGAMT(Y.ACCOUNTNO, Y.COM.CODE, Y.BASE.BALANCE, Y.CHG.AMT, Y.DUE.AMT)
    $INSERT I_COMMON
    $INSERT I_EQUATE
*
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING CG.ChargeConfig
    $USING AC.AccountOpening
    $USING ST.CompanyCreation
*
    GOSUB INIT
    GOSUB OPENFILE
    GOSUB PROCESS
RETURN
************
INIT:
************
    FN.FTCT  = 'F.FT.COMMISSION.TYPE'
    F.FTCT = ''
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
RETURN
***********
OPENFILE:
***********
    EB.DataAccess.Opf(FN.FTCT, F.FTCT)
    EB.DataAccess.Opf(FN.ACC, F.ACC)
*
    EB.DataAccess.FRead(FN.FTCT, Y.COM.CODE, R.FTCT, F.FTCT, ERR.FTCT)
    Y.UPTO.AMT = R.FTCT<CG.ChargeConfig.FtCommissionType.FtFouUptoAmt>
    Y.MIN.AMT = R.FTCT<CG.ChargeConfig.FtCommissionType.FtFouMinimumAmt>
*
    BD.Soc.GetWBal(Y.ACCOUNTNO, Y.WRK.BLNC)
RETURN
*****************
PROCESS:
*****************
    CONVERT SM TO VM IN Y.UPTO.AMT
    CONVERT SM TO VM IN Y.MIN.AMT
*
    Y.DCOUNT = DCOUNT(Y.UPTO.AMT,VM)
    FOR I = 1 TO Y.DCOUNT
        Y.AMT = Y.UPTO.AMT<1,I>
        IF Y.BASE.BALANCE LE Y.AMT THEN
            BREAK
        END
    NEXT I
    Y.CHG.AMT = Y.MIN.AMT<1,I>
*
    IF Y.WRK.BLNC GE Y.CHG.AMT THEN
        Y.DUE.AMT = 0
    END
    ELSE
        Y.DUE.AMT = Y.CHG.AMT
        Y.CHG.AMT = 0
    END
RETURN
END
