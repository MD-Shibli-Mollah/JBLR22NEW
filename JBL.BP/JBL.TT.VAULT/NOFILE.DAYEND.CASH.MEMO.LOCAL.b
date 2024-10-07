*-------------------------------------------------------------------------
* <Rating>-49</Rating>
*-------------------------------------------------------------------------
SUBROUTINE NOFILE.DAYEND.CASH.MEMO.LOCAL(Y.ARR)
*-------------------------------------------------------------------------
* Report is used for particular branches dayend cash position.
*
*-------------------------------------------------------------------------
* Modification History :  Retrofit from STANDARD.SELECTION>NOFILE.TT.VAULT - TTV.CCY
* 18/09/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* modification date -- 20150920
* modified by -- huraira
* until branch manually deposit cash to teller through cash deposit menu this report
* should not calculate opening and closing balance with the consideration of category
* '13501'.that's why category '13501' has been removed from select statement.
*
* Modification date--20180305
* Modified by--Fairooz
* Only transaction code 153 added for DD/TT/MT issue in debit side
*
* Modification date: 20190117
* by - Alin boby, Rashed
* only transaction code 160

*-------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    
    $USING AC.AccountOpening
    $USING FT.Contract
    $USING TT.Contract
    
    $USING EB.SystemTables
    $USING EB.Reports
    $USING EB.DataAccess
    $USING ST.Config
    

*-------------------------------------------------------------------------
* Main controlling section:
*-------------------------------------------------------------------------
    GOSUB INITIALISATION
    GOSUB MAIN.PROCESS

RETURN

*-------------------------------------------------------------------------
* Subroutine Section:
* File Opening and Variable set up

INITIALISATION:

*-------------------------------------------------------------------------
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    R.ACCOUNT = ""
* CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    EB.DataAccess.Opf(FN.ACCOUNT,F.ACCOUNT)

    FN.TELLER = "F.TELLER"
    F.TELLER = ""
    R.TELLER = ''
* CALL OPF(FN.TELLER, F.TELLER)
    EB.DataAccess.Opf(FN.TELLER, F.TELLER)
    Y.CREDIT = "4":@FM:"5":@FM:"14":@FM:"32":@FM:"110":@FM:"112":@FM:"114":@FM:"16":@FM:"157":@FM:"155":@FM:"23"
    !*****Modified by Fairooz****
    !   Y.DEBIT ="9":@FM:"10":@FM:"33":@FM:"109":@FM:"111 ":@FM:"113":@FM:"15":@FM:"151":@FM:"152"
    Y.DEBIT ="9":@FM:"10":@FM:"33":@FM:"109":@FM:"111 ":@FM:"113":@FM:"15":@FM:"151":@FM:"152":@FM:"153":@FM:"154":@FM:"156":@FM:"24":@FM:"160"
    !***************************
RETURN
*-------------------------------------------------------------------------
* Main Subroutine processing:
*
MAIN.PROCESS:
*
*-------------------------------------------------------------------------
*Opening Balance

    Y.COMPANY = EB.SystemTables.getIdCompany()
    Y.CURRENCY = 'BDT'

*SEL.CMD = "SELECT " : FN.ACCOUNT : " WITH CATEGORY EQ 10001 10011 13501 AND CO.CODE EQ ":Y.COMPANY
    SEL.CMD = "SELECT " : FN.ACCOUNT : " WITH CATEGORY EQ 10001 10011 AND CURRENCY EQ ":Y.CURRENCY : " AND CO.CODE EQ ":Y.COMPANY

* CALL EB.READLIST(SEL.CMD,SEL.LIST,"",NO.OF.RECORDS,RET.CODE)
    EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,"",NO.OF.RECORDS,RET.CODE)
    LOOP
        REMOVE TRAN.ID FROM SEL.LIST SETTING TXN.POS
    WHILE TRAN.ID:TXN.POS
* CALL F.READ(FN.ACCOUNT,TRAN.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
        EB.DataAccess.FRead(FN.ACCOUNT,TRAN.ID,R.ACCOUNT,F.ACCOUNT,Y.ERR)
* Y.OPEN.BAL = R.ACCOUNT<AC.OPEN.ACTUAL.BAL>
        Y.OPEN.BAL = R.ACCOUNT<AC.AccountOpening.Account.OpenActualBal>
        Y.TOT.OPEN.BAL = Y.TOT.OPEN.BAL + Y.OPEN.BAL
    REPEAT
    Y.FINAL.TXT<-1> = "Opening Balance":"*":ABS(Y.TOT.OPEN.BAL) :"*":"0"
*-------------------------------------------------------------------------
*Received from Bank
    SEL.CMD1 = "SELECT ":FN.TELLER: " WITH CO.CODE EQ ":Y.COMPANY:" AND (CURRENCY.1 EQ ":Y.CURRENCY:" OR CURRENCY.2 EQ ":Y.CURRENCY:")"
* CALL EB.READLIST(SEL.CMD1,SEL.LIST1,"",NO.OF.RECORDS,RET.CODE)
    EB.DataAccess.Readlist(SEL.CMD1,SEL.LIST1,"",NO.OF.RECORDS,RET.CODE)

    LOOP
        REMOVE TRAN.ID FROM SEL.LIST1 SETTING TXN.POS
    WHILE TRAN.ID:TXN.POS
* CALL F.READ(FN.TELLER,TRAN.ID,R.TELLER,F.TELLER,Y.ERR)
        EB.DataAccess.FRead(FN.TELLER,TRAN.ID,R.TELLER,F.TELLER,Y.ERR)
* Y.TRANS.CODE = R.TELLER<TT.TE.TRANSACTION.CODE>
        Y.TRANS.CODE = R.TELLER<TT.Contract.Teller.TeTransactionCode>
    
        LOCATE Y.TRANS.CODE IN  Y.DEBIT SETTING POS THEN
* Y.ACC2 = R.TELLER<TT.TE.ACCOUNT.2>
            Y.ACC2 = R.TELLER<TT.Contract.Teller.TeAccountTwo>
* Y.DR.CR.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
            Y.DR.CR.MARKER = R.TELLER<TT.Contract.Teller.TeDrCrMarker>
* CALL F.READ(FN.ACCOUNT,Y.ACC2,R.ACCOUNT,F.ACCOUNT,Y.ERR)
            EB.DataAccess.FRead(FN.ACCOUNT,Y.ACC2,R.ACCOUNT,F.ACCOUNT,Y.ERR)
* Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
            Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
            IF (Y.CATEGORY EQ '5012' OR Y.CATEGORY EQ 17451 OR Y.CATEGORY EQ 5011 OR Y.CATEGORY EQ 17454 OR Y.CATEGORY EQ 5021 OR Y.CATEGORY EQ 17455 OR Y.CATEGORY EQ 14018 OR Y.CATEGORY EQ 13062) THEN
* Y.AMT = R.TELLER<TT.TE.NET.AMOUNT>
                Y.AMT = R.TELLER<TT.Contract.Teller.TeNetAmount>
                Y.REV.BANK.AMT = Y.REV.BANK.AMT + ABS(Y.AMT)
                Y.R.VOUCHER = Y.R.VOUCHER + 1
            END
        
            ELSE
* Y.AMT = R.TELLER<TT.TE.NET.AMOUNT>
                Y.AMT = R.TELLER<TT.Contract.Teller.TeNetAmount>
*------------ ADDED ON 20181021 BY RASHED------------------
* Y.FCY.2 = R.TELLER<TT.TE.AMOUNT.FCY.2>
                Y.FCY.2 = R.TELLER<TT.Contract.Teller.TeAmountFcyTwo>
                IF Y.FCY.2<>'' THEN
* Y.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
                    Y.AMT = R.TELLER<TT.Contract.Teller.TeAmountLocalOne>
                END
*----------------------------------------------------------
                Y.REV.CUS.AMT = Y.REV.CUS.AMT + ABS(Y.AMT)
                Y.R.VOUCHER = Y.R.VOUCHER + 1
            END
        END
        ELSE
            LOCATE  Y.TRANS.CODE IN Y.CREDIT SETTING POS1 THEN
* Y.ACC2 = R.TELLER<TT.TE.ACCOUNT.2>
                Y.ACC2 = R.TELLER<TT.Contract.Teller.TeAccountTwo>
* Y.DR.CR.MARKER = R.TELLER<TT.TE.DR.CR.MARKER>
                Y.DR.CR.MARKER = R.TELLER<TT.Contract.Teller.TeDrCrMarker>
                EB.DataAccess.FRead(FN.ACCOUNT,Y.ACC2,R.ACCOUNT,F.ACCOUNT,Y.ERR)
* Y.CATEGORY = R.ACCOUNT<AC.CATEGORY>
                Y.CATEGORY = R.ACCOUNT<AC.AccountOpening.Account.Category>
            
                IF (Y.CATEGORY EQ '5012' OR Y.CATEGORY EQ 17451 OR Y.CATEGORY EQ 5011 OR Y.CATEGORY EQ 17454 OR Y.CATEGORY EQ 5021 OR Y.CATEGORY EQ 17455 OR Y.CATEGORY EQ 14018 OR Y.CATEGORY EQ 13062) THEN
                    EB.DataAccess.FRead(FN.TELLER,TRAN.ID,R.TELLER,F.TELLER,Y.ERR)
* Y.AMT = R.TELLER<TT.TE.NET.AMOUNT>
                    Y.AMT = R.TELLER<TT.Contract.Teller.TeNetAmount>
                    Y.PTB.AMT = Y.PTB.AMT + Y.AMT
                    Y.P.VOUCHER = Y.P.VOUCHER + 1
                END
                ELSE
                    EB.DataAccess.FRead(FN.TELLER,TRAN.ID,R.TELLER,F.TELLER,Y.ERR)
* Y.AMT = R.TELLER<TT.TE.NET.AMOUNT>
                    Y.AMT = R.TELLER<TT.Contract.Teller.TeNetAmount>
*------------ ADDED ON 20181021 BY RASHED-------------------------
* Y.FCY.2 = R.TELLER<TT.TE.AMOUNT.FCY.2>
                    Y.FCY.2 = R.TELLER<TT.Contract.Teller.TeAmountFcyTwo>
                    IF Y.FCY.2<>'' THEN
* Y.AMT = R.TELLER<TT.TE.AMOUNT.LOCAL.1>
                        Y.AMT = R.TELLER<TT.Contract.Teller.TeAmountLocalOne>
                    END
*-----------------------------------------------------------------
                    Y.PTC.AMT = Y.PTC.AMT + Y.AMT
                    Y.P.VOUCHER = Y.P.VOUCHER + 1
                END
            END
        END


    REPEAT

    Y.FINAL.TXT<-1> = "Received from Bank":"*": Y.REV.BANK.AMT:"*":"0"
    Y.FINAL.TXT<-1> = "Received from Customers":"*": Y.REV.CUS.AMT:"*":"0"
    Y.FINAL.TT.REC = ABS(Y.REV.BANK.AMT) + ABS(Y.REV.CUS.AMT)
    Y.FINAL.TXT<-1> = "Total Received ":"*":Y.FINAL.TT.REC :"*":"0"

    Y.FINAL.TT.BAL= ABS(Y.TOT.OPEN.BAL) + ABS(Y.FINAL.TT.REC)

    Y.FINAL.TXT<-1> = "SUB TOTAL" :"*": Y.FINAL.TT.BAL:"*":"0"

    Y.FINAL.TXT<-1> = "Paid to Bank" :"*": Y.PTB.AMT:"*":"0"

    Y.FINAL.TXT<-1> = "Paid to Customers":"*":  Y.PTC.AMT :"*":"0"
    Y.FINAL.TTP = ABS(Y.PTB.AMT) + ABS(Y.PTC.AMT)
    Y.FINAL.TXT<-1> = "Total Paid":"*":Y.FINAL.TTP :"*":"0"

    Y.FINAL.C.BAL = ABS(Y.FINAL.TT.BAL) - ABS(Y.FINAL.TTP)
    Y.FINAL.TXT<-1> = "Closing Balance":"*": Y.FINAL.C.BAL  :"*":"0"

    Y.R.AMT = ''
    Y.AMT = ''

*-------------------------------------------------------------------------
*Total Paid Voucher
    Y.FINAL.TXT<-1> = "Total Paid Voucher":"*":Y.P.VOUCHER :"*":"0"
*Total Received Voucher
    Y.FINAL.TXT<-1> = "Total Received Voucher":"*":Y.R.VOUCHER:"*":Y.FINAL.C.BAL
*-------------------------------------------------------------------------
*Total voucher
    Y.TT.VOCH=Y.P.VOUCHER + Y.R.VOUCHER
    Y.FINAL.TXT<-1> = "Total Voucher":"*": Y.TT.VOCH:"*":Y.FINAL.C.BAL
*-------------------------------------------------------------------------

*Final array to displaying the data

    Y.ARR = Y.FINAL.TXT

RETURN
END

