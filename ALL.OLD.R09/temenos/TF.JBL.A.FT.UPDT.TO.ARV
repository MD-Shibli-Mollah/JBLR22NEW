SUBROUTINE TF.JBL.A.FT.UPDT.TO.ARV
*-----------------------------------------------------------------------------
*Subroutine Description:
*Subroutine Type:
*Attached To    : FUNDS.TRANSFER Version (FUNDS.TRANSFER,JBL.IT.FCYNOSTO.FTHP)
*Attached As    : AUTH ROUTINE

* Creation History :
* 08/12/2020 -                            CREATE   - SHAJJAD HOSSEN,
*                                                 FDS Bangladesh Limited

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.JBL.ARV
    $INSERT I_F.BD.LC.AD.CODE
    $INSERT I_F.BD.HS.CODE.LIST
*
    $USING LC.Contract
    $USING AC.AccountOpening
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING FT.Contract
    $USING ST.Customer
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING ST.CurrencyConfig
*-----------------------------------------------------------------------------
*
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN
*****
INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    FN.CUR = 'F.CURRENCY'
    F.CUR = ''
    FN.BD.LC.AD.CODE = 'F.BD.LC.AD.CODE'
    F.BD.LC.AD.CODE = ''
    FN.JBL.ARV = 'F.JBL.ARV'
    F.JBL.ARV = ''
    FN.CMDT.CD = 'F.BD.HS.CODE.LIST'
    F.CMDT.CD = ''
    Y.CUSTOMER = ''
    Y.CMDT.DES = ''
    
    APPLICATION.NAMES = 'CUSTOMER':FM:'FUNDS.TRANSFER':FM:'CURRENCY'
    LOCAL.FIELDS = 'LT.ERC.NO':VM:'LT.ERC.ISS.DT':FM:'LT.EXP.FORM.NO':VM:'LT.EXP.SECTOR':VM:'LT.BUYER.NAME':VM:'LT.BUYER.ADD':VM:'LT.TF.HS.CODE':VM:'LT.DESTINATION':VM:'LT.RECEIVE.DATE':VM:'LT.REP.PERIOD':VM:'LT.ARV.NUMBER':FM:'LT.BB.CCY.CODE'
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.ERC.NO.POS = FLD.POS<1,1>
    Y.LT.ERC.ISS.DT.POS = FLD.POS<1,2>
    
    Y.LT.EXP.FORM.NO.POS = FLD.POS<2,1>
    Y.LT.EXP.SECTOR.POS = FLD.POS<2,2>
    Y.LT.BUYER.NAME.POS = FLD.POS<2,3>
    Y.LT.BUYER.ADD.POS = FLD.POS<2,4>
    Y.LT.CMDITY.CODE.POS = FLD.POS<2,5>
    Y.LT.DESTINATION.POS = FLD.POS<2,6>
    Y.LT.RECEIVE.DATE.POS = FLD.POS<2,7>
    Y.LT.REP.PERIOD.POS = FLD.POS<2,8>
    Y.LT.ARV.NUMBER.POS = FLD.POS<2,9>
    Y.CUR.CODE.POS = FLD.POS<3,1>
    
    Y.BUYER.ADD = ''
    
RETURN
**********
OPENFILES:
**********
    EB.DataAccess.Opf(FN.CUSTOMER, F.CUSTOMER)
    EB.DataAccess.Opf(FN.CUR, F.CUR)
    EB.DataAccess.Opf(FN.ACCOUNT, F.ACCOUNT)
    EB.DataAccess.Opf(FN.BD.LC.AD.CODE, F.BD.LC.AD.CODE)
    EB.DataAccess.Opf(FN.JBL.ARV, F.JBL.ARV)
    EB.DataAccess.Opf(FN.CMDT.CD, F.CMDT.CD)
RETURN
********
PROCESS:
********
    Y.FT.ID = EB.SystemTables.getIdNew()
    Y.FT.DR.COMP.CODE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
    EB.DataAccess.FRead(FN.BD.LC.AD.CODE, Y.FT.DR.COMP.CODE, R.BD.LC.AD.CODE, F.BD.LC.AD.CODE, BD.LC.AD.CODE.ERR)
    IF R.BD.LC.AD.CODE THEN
        Y.DEALER.NAME = "MERCANTILE BANK LIMITED"
        Y.DEALER.ADDRESS = R.BD.LC.AD.CODE<AD.CODE.BRANCH.NAME>
        Y.DEALER.CODE = R.BD.LC.AD.CODE<AD.CODE.AD.CODE>
        
        Y.CR.ACCT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        EB.DataAccess.FRead(FN.ACCOUNT, Y.CR.ACCT, R.ACCOUNT, F.ACCOUNT, ACCOUNT.ERR)
        IF R.ACCOUNT THEN
            Y.CUSTOMER = R.ACCOUNT<AC.AccountOpening.Account.Customer>
        END
        
        EB.DataAccess.FRead(FN.CUSTOMER, Y.CUSTOMER, R.CUSTOMER, F.CUSTOMER, CUSTOMER.ERR)
        IF R.CUSTOMER THEN
            Y.EXPORTER.NAME = R.CUSTOMER<ST.Customer.Customer.EbCusNameOne>
            Y.EXPORTER.ADDRESS = R.CUSTOMER<ST.Customer.Customer.EbCusStreet>
            Y.CCIE.NUMBER = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, Y.LT.ERC.NO.POS>
            Y.CCIE.DATE = R.CUSTOMER<ST.Customer.Customer.EbCusLocalRef, Y.LT.ERC.ISS.DT.POS>
        END
        Y.ARV.NUMBER = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.ARV.NUMBER.POS>
        Y.EXP.FORM = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.EXP.FORM.NO.POS>
        Y.EXP.SECTOR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.EXP.SECTOR.POS>
        Y.BUYER.NAME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.BUYER.NAME.POS>
        Y.BUYER.ADDR = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.BUYER.ADD.POS>
        Y.CMDITY.CODE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.CMDITY.CODE.POS>
        Y.DESTNATION = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.DESTINATION.POS>
        Y.DES.LEN = LEN(Y.DESTINATION)
        IF Y.DES.LEN EQ '3' THEN
            Y.DESTINATION = '0': Y.DESTNATION
        END ELSE
            Y.DESTINATION = Y.DESTNATION
        END
        Y.RECEIVE.DATE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.RECEIVE.DATE.POS>
        Y.REP.PERIOD = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)<1, Y.LT.REP.PERIOD.POS>
        
        EB.DataAccess.FRead(FN.CMDT.CD, Y.CMDITY.CODE, R.CMDT.CD, F.CMDT.CD, CMDT.ERR)
        IF R.CMDT.CD NE '' THEN
            Y.CMDT.DESC = R.CMDT.CD<HS.CO.DESCRIPTION>
            CONVERT SM TO VM IN Y.CMDT.DESC
            Y.CMDT.DES = FIELD(Y.CMDT.DESC,VM,1)
        END
*        IF Y.CMDT.DESC NE '' THEN
*            Y.CMDT.DESC.LIST = DCOUNT(Y.CMDT.DESC, @VM)
*            FOR J = 1 TO Y.CMDT.DESC.LIST
*                Y.CMDT.DESC1 = Y.CMDT.DESC<1,J>
*                Y.CMDT.DES = Y.CMDT.DES : Y.CMDT.DESC1
*                Y.CMDT.DES.LEN = LEN(Y.CMDT.DE)
*                IF Y.CMDT.DES.LEN GT 30 THEN
*                    Y.CMDT.DES = Y.CMDT.DES[1,30] : '...'
*                END
*            NEXT J
*        END

        IF Y.BUYER.ADDR NE '' THEN
            Y.BUYER.ADDR.LIST = DCOUNT(Y.BUYER.ADDR, @VM)
            FOR J = 1 TO Y.BUYER.ADDR.LIST
                Y.BUYER.ADDR1 = Y.BUYER.ADDR<1,J>
                Y.BUYER.ADD = Y.BUYER.ADD : Y.BUYER.ADDR1
            NEXT J
        END


        IF Y.REP.PERIOD EQ "Y." THEN
            Y.REP.PERIOD = "Y"
            Y.RETURN = "JANUARY"
        END ELSE IF Y.REP.PERIOD EQ "X." THEN
            Y.REP.PERIOD = "X"
            Y.RETURN = "FEBRUARY"
        END ELSE IF Y.REP.PERIOD EQ "0" THEN
            Y.RETURN = "MARCH"
        END ELSE IF Y.REP.PERIOD EQ "1" THEN
            Y.RETURN = "APRIL"
        END ELSE IF Y.REP.PERIOD EQ "2" THEN
            Y.RETURN = "MAY"
        END ELSE IF Y.REP.PERIOD EQ "3" THEN
            Y.RETURN = "JUNE"
        END ELSE IF Y.REP.PERIOD EQ "4" THEN
            Y.RETURN = "JULY"
        END ELSE IF Y.REP.PERIOD EQ "5" THEN
            Y.RETURN = "AUGUST"
        END ELSE IF Y.REP.PERIOD EQ "6" THEN
            Y.RETURN = "SEPTEMBER"
        END ELSE IF Y.REP.PERIOD EQ "7" THEN
            Y.RETURN = "OCTOBER"
        END ELSE IF Y.REP.PERIOD EQ "8" THEN
            Y.RETURN = "NOVEMBER"
        END ELSE IF Y.REP.PERIOD EQ "9" THEN
            Y.RETURN = "DECEMBER"
        END
    

        Y.RECEIVED.CCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
        EB.DataAccess.FRead(FN.CUR, Y.RECEIVED.CCY, R.CUR, F.CUR, CUR.ERR)
        IF R.CUR NE '' THEN
            Y.RECEIVED.CCY.CODE = R.CUR<ST.CurrencyConfig.Currency.EbCurLocalRef, Y.CUR.CODE.POS>
            Y.RECEIVED.AMT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
        END

    
*    RECORD WRITE IN JBL.ARV APPLICATION
        R.JBL.ARV<ARV.ARV.NUMBER> = Y.ARV.NUMBER
        R.JBL.ARV<ARV.DEALER.NAME> = Y.DEALER.NAME
        R.JBL.ARV<ARV.DEALER.ADDRESS> = Y.DEALER.ADDRESS
        R.JBL.ARV<ARV.DEALER.CODE> = Y.DEALER.CODE
        
        R.JBL.ARV<ARV.EXPORTER.ID> = Y.CUSTOMER
        R.JBL.ARV<ARV.EXPORTER.NAME> = Y.EXPORTER.NAME
        R.JBL.ARV<ARV.EXPORTER.ADD> = Y.EXPORTER.ADDRESS
        R.JBL.ARV<ARV.CCIE.NUMBER> = Y.CCIE.NUMBER
        R.JBL.ARV<ARV.CCIE.DATE> = Y.CCIE.DATE
        
        R.JBL.ARV<ARV.EXP.FORM.NO> = Y.EXP.FORM
        R.JBL.ARV<ARV.EXPORTER.SECTOR> = Y.EXP.SECTOR
        R.JBL.ARV<ARV.BUYER.NAME> = Y.BUYER.NAME
        R.JBL.ARV<ARV.BUYER.ADD> = Y.BUYER.ADD
        R.JBL.ARV<ARV.COMMODITY.CODE> = Y.CMDITY.CODE
        R.JBL.ARV<ARV.COMMODITY.CODE.DES> = Y.CMDT.DES
        R.JBL.ARV<ARV.DESTINATION> = Y.DESTINATION
        
        
        R.JBL.ARV<ARV.RECEIVED.CCY> = Y.RECEIVED.CCY
        R.JBL.ARV<ARV.RECEIVED.CCY.CODE> = Y.RECEIVED.CCY.CODE
        R.JBL.ARV<ARV.RECEIVED.AMOUT> = Y.RECEIVED.AMT
        R.JBL.ARV<ARV.RECEIVED.DATE> = Y.RECEIVE.DATE
        R.JBL.ARV<ARV.REPORTING.PERIOD> = Y.REP.PERIOD
        R.JBL.ARV<ARV.REPORTING.PERIOD.DES> = Y.RETURN
        EB.DataAccess.FWrite(FN.JBL.ARV, Y.FT.ID, R.JBL.ARV)
    END ELSE
        EB.SystemTables.setAf(FT.Contract.FundsTransfer.DebitCompCode)
        EB.SystemTables.setEtext("Not an AD Branch")
        EB.ErrorProcessing.StoreEndError()
              
    END
       
RETURN
END


