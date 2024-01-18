SUBROUTINE BD.SOC.SOURCE.CAL(arrId,arrProp,arrCcy,arrRes,balanceAmount,perDat)
*-----------------------------------------------------------------------------
*Developer Info:
*    Date         : 20/02/2022
*    Description  : Calculation Charge Amount
*    Developed By : Md. Shafiul Azam
*    Designation  : Senior Technical Consultant
*    Email        : shafiul.ntl@nazihargroup.com
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.BD.SOC.PARAM
    
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.API
    $USING AA.Framework
    $USING BD.Soc
*-----------------------------------------------------------------------------

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.SOC.PARAM = 'F.BD.SOC.PARAM'
    F.SOC.PARAM = ''
    
    Y.CHG.AMT = 0
    Y.VAT.AMT = 0
    Y.REL.CHG = 0
    Y.REL.VAT = 0
    Y.DUE.AMT = 0
    Y.DUE.VAT = 0
RETURN

**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.SOC.PARAM, F.SOC.PARAM)
RETURN


********
PROCESS:
********
    AA.Framework.GetArrangementAccountId(arrId, accountId, Currency, ReturnError)   ;*To get Arrangement Account
    AA.Framework.GetArrangementProduct(arrId, EffDate, ArrRecord, ProductId, PropertyList)  ;*Arrangement record
    Y.PRODUCT.GROUP = ArrRecord<AA.Framework.Arrangement.ArrProductGroup>
    AA.Framework.GetBaseBalanceList(arrId, arrProp, ReqdDate, ProductId, BaseBalance)
    Y.BD.SOC.PARAM.GROUP.ID = Y.PRODUCT.GROUP-arrProp
    Y.BD.SOC.PARAM.PRODUCT.ID = ProductId-arrProp
    EB.DataAccess.FRead(FN.SOC.PARAM, Y.BD.SOC.PARAM.PRODUCT.ID, R.SOC.PARAM, F.SOC.PARAM, E.SOC.PARAM)
    IF R.SOC.PARAM EQ '' THEN
        EB.DataAccess.FRead(FN.SOC.PARAM, Y.BD.SOC.PARAM.GROUP.ID, R.SOC.PARAM, F.SOC.PARAM, E.SOC.PARAM)
    END
    Y.CHG.NAME=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.CHARGE.NAME>
    Y.CALC.TYPE=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.CALC.TYPE>
    Y.BALANCE=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.BALANCE>
    Y.SOURCE.BALANCE=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.SOURCE.BALANCE>
    Y.COM.CODE=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.CHARGE.CODE>
    Y.APPLIED.CHARGE=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.APPLIED.CHARGE>
    Y.RESTRICTION=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.RESTRICTION>
    Y.THRESHOLD.AMOUNT=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.THRESHOLD.CHARGE.AMOUNT>
    Y.PARTIAL.FLAG=R.SOC.PARAM<BD.Soc.BdSocPAram.SOC.PARAM.PARTIAL.FLAG>
    Y.SOC.INFO.ID = accountId-arrProp-perDat[1,4]
    IF arrProp = 'EDFEE' THEN
        Y.YEAR = EB.SystemTables.getToday()[1,4]
        BD.Soc.SocGetHighBal(accountId, Y.YEAR, Y.BALANCE)
        BD.Soc.SocGetEdChgAmt(accountId, Y.COM.CODE, Y.BALANCE, Y.CHG.AMT, Y.DUE.AMT)
        balanceAmount = Y.CHG.AMT
    END
    IF arrProp = 'AMCFEE' THEN
        BD.Soc.SocGetDate(accountId, Y.START.DATE, Y.END.DATE)
        BD.Soc.SocGetAvgBal(accountId, Y.START.DATE, Y.END.DATE, Y.SOURCE.BALANCE, arrProp, Y.AvgBal)
        BD.Soc.SocGetChgAmt(accountId, Y.COM.CODE, Y.SOURCE.BALANCE, Y.THRESHOLD.AMOUNT, Y.PARTIAL.FLAG, Y.APPLIED.CHARGE,Y.RESTRICTION, Y.CHG.AMT, Y.VAT.AMT, Y.REL.CHG, Y.REL.VAT, Y.DUE.AMT, Y.DUE.VAT)
        balanceAmount = Y.CHG.AMT
        Y.BALANCE = Y.AvgBal
    END
    BD.Soc.SocUPDATECHGINFO(Y.SOC.INFO.ID, Y.BALANCE, Y.CHG.AMT, Y.VAT.AMT, Y.REL.CHG, Y.REL.VAT, Y.DUE.AMT, Y.DUE.VAT)
RETURN