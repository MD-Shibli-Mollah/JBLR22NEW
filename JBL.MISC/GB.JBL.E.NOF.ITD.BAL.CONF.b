
*-----------------------------------------------------------------------------
* <Rating>-44</Rating>
*-----------------------------------------------------------------------------
* <Any Day Working Balance Routine>
* ------------------------------------------------------------
* <Parameter Description>
* <<< Y.RETURN = Y.T24.ID:"*":Y.ALT.ID:"*" -----
* ------------------------------------------------------------
* <No Subroutine Call>
* --------------------------------------------------------------
* <CREATED BY: APURBA KUMAR SARKER>
* <START DATE: 04/07/2015>
* <END DATE:   10/07/2015>
* ------------------------------------------------------------------
* <Modified date:> 12/02/2024           <Reason: > RETROFIT
* Modified by: MD Shibli Mollah
*
* -------------------------------------------------------------------

SUBROUTINE GB.JBL.E.NOF.ITD.BAL.CONF(Y.RETURN)

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*    $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
*    $INSERT GLOBUS.BP I_F.ACCOUNT.CLASS
    $USING AC.Config
*    $INSERT GLOBUS.BP I_F.ACCT.ACTIVITY
    $USING AC.BalanceUpdates
*    $INSERT GLOBUS.BP I_F.ALTERNATE.ACCOUNT
*    $INSERT GLOBUS.BP I_F.CUSTOMER
    $USING ST.Customer
    $USING EB.Reports
    $USING EB.DataAccess

    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*------
INIT:
*------
    LOCATE "ACCOUNT.NUMBER" IN EB.Reports.getEnqSelection()<2,1> SETTING ID.POS THEN
        Y.ID = EB.Reports.getEnqSelection()<4, ID.POS>
    END

    LOCATE "DATE" IN EB.Reports.getEnqSelection()<2,1> SETTING DATE.POS THEN
        Y.PASS.DATE = EB.Reports.getEnqSelection()<4,DATE.POS>
    END

    !Y.ID = "001234091515"
    Y.T24.ID = ""
    Y.ALT.ID = ""
    !Y.PASS.DATE ='20131106'
    Y.LEG.ID = ''
    Y.CUS.ID = ''
    Y.CUS.STRT = ''
    Y.CUS.NAME = ''
    Y.CUS.PRE.ADD = ''
    Y.CUS.TWN = ''
    Y.CUS.POST = ''
    Y.CUS.CNTRY = ''

    !--- customer
    FN.CUS = "F.CUSTOMER"
    F.CUS  = ""
    R.CUS = ""
    !--- ------------------------ customer END ---
    !-------------------------------ACCOUNT --- Find ALT id
    FN.AC = "F.ACCOUNT"
    F.AC = ""
    R.AC = ""
    !   ------      -----------------------ACCOUNT end
    !------- ALTERNAT ACCOUNT ---
    FN.ALT.AC = "F.ALTERNATE.ACCOUNT"
    F.ALT.AC = ""
    R.ALT.AC = ""

RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.CUS, F.CUS )
    EB.DataAccess.Opf(FN.AC, F.AC)
    EB.DataAccess.Opf(FN.ALT.AC, F.ALT.AC)

RETURN          ;!--- END OPENFILES

*--------
PROCESS:
*--------
    EB.DataAccess.FRead(FN.ALT.AC, Y.ID, R.ALT.AC, F.ALT.AC, ERR.ALT.AC)

    !---------- This is for -- USING ALT ID -- T24 id and ALT id
    IF R.ALT.AC THEN
* Y.T24.ID = R.ALT.AC<AAC.GLOBUS.ACCT.NUMBER>
        Y.T24.ID = R.ALT.AC<AC.AccountOpening.AlternateAccount.AacGlobusAcctNumber>
        Y.ALT.ID = Y.ID
    END
    ELSE

        !------------------------!This is for -- USING T24 ID --
        Y.T24.ID = Y.ID
        !-------------------------!Find ALT id ------------------
        EB.DataAccess.FRead(FN.AC, Y.ID, R.AC, F.AC, ERR.AC)
*        Y.ALT.ID = R.AC<AC.ALT.ACCT.ID>
        Y.ALT.ID = R.AC<AC.AccountOpening.Account.AltAcctId>
*        Y.CUS.ID = R.AC<AC.CUSTOMER>
        Y.CUS.ID = R.AC<AC.AccountOpening.Account.Customer>
    END
    !CRT "T24 ID: ":Y.T24.ID

    !---------------------------------------- CUSTOMER ID NULL --
    IF Y.CUS.ID EQ "" THEN
        EB.DataAccess.FRead(FN.AC, Y.T24.ID, R.AC, F.AC, ERR.AC)
* Y.CUS.ID = R.AC<AC.CUSTOMER>
        Y.CUS.ID = R.AC<AC.AccountOpening.Account.Customer>
    END

    !-------------------------- READ CUSTOMER FILE ----
    EB.DataAccess.FRead( FN.CUS, Y.CUS.ID, R.CUS, F.CUS, ERR.CUS )
    IF R.CUS THEN
*        Y.CUS.STRT = R.CUS<EB.CUS.STREET>
        Y.CUS.STRT = R.CUS<ST.Customer.Customer.EbCusStreet>
*        Y.CUS.NAME = R.CUS<EB.CUS.SHORT.NAME>
        Y.CUS.NAME = R.CUS<ST.Customer.Customer.EbCusShortName>
*        Y.CUS.PRE.ADD = R.CUS<EB.CUS.ADDRESS>
        Y.CUS.PRE.ADD = R.CUS<ST.Customer.Customer.EbCusAddress>
*        Y.CUS.TWN = R.CUS<EB.CUS.TOWN.COUNTRY>
        Y.CUS.TWN = R.CUS<ST.Customer.Customer.EbCusTownCountry>
*        Y.CUS.POST = R.CUS<EB.CUS.POST.CODE>
        Y.CUS.POST = R.CUS<ST.Customer.Customer.EbCusPostCode>
*        Y.CUS.CNTRY = R.CUS<EB.CUS.COUNTRY>
        Y.CUS.CNTRY = R.CUS<ST.Customer.Customer.EbCusCountry>
    END
    !------------------------------- PROCESS  -- END ---

    !CRT "CID : ":Y.CUS.ID
    !CRT "C NAME : ":Y.CUS.NAME
    !CRT "STRT : ":Y.CUS.STRT
    !CRT "ADDRESS : ":Y.CUS.PRE.ADD
    !CRT "TWN : ":Y.CUS.TWN
    !CRT "POST : ":Y.CUS.POST
    !CRT "CNTRY : ":Y.CUS.CNTRY

    CALL EB.GET.ACCT.BALANCE(Y.T24.ID, Y.ACCT.REC, Y.BALANCE.TYPE, Y.PASS.DATE, Y.SYSTEM.DATE, Y.BALANCE, Y.CREDIT.MVMT, Y.DEBIT.MVMT, Y.ERR.MSG)

    !CRT 'ACCOUNT ID: ': Y.T24.ID
    !CRT 'REC ARRAY: ':Y.ACCT.REC
    !CRT 'BAL TYPE: ':Y.BALANCE.TYPE
    !CRT 'PASS DATE: ':Y.PASS.DATE
    !CRT 'SYS DATE: ':Y.SYSTEM.DATE
    !CRT 'BAL: ':Y.BALANCE
    !CRT 'CR MVT: ':Y.CREDIT.MVMT
    !CRT 'DR MVT: ':Y.DEBIT.MVMT
    !CRT 'ER MSG: ':Y.ERR.MSG

    Y.RESULT = Y.T24.ID:"*":Y.ALT.ID:"*":Y.CUS.ID:"*":Y.CUS.NAME:"*":Y.CUS.STRT:"*":Y.CUS.PRE.ADD:"*":Y.CUS.TWN:"*":Y.CUS.POST:"*":Y.CUS.CNTRY:"*":Y.PASS.DATE:"*":Y.BALANCE

    Y.RETURN <-1> = Y.RESULT
    !CRT Y.RESULT

RETURN
END
