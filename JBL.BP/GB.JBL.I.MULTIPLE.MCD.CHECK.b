* @ValidationCode : MjozNDkzNzkyMTA6Q3AxMjUyOjE2NjE1ODY0MzEwNTE6bmF6aWI6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfU1A5LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Aug 2022 13:47:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazib
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_SP9.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
SUBROUTINE GB.JBL.I.MULTIPLE.MCD.CHECK
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* Description :
    !!1) Check debit account is customer account,internal account or PL account.For customer and internal account check in ACCOUNT application and for PL check the CATEGORY file.
    !!2) If debit account internal account then Orderding Bank is mandatory
    !!3) If debit account PL category then Profit centre customer is mandatory
    !!4) If debit account PL category then Cheque field should be blank
    !!5) Unauthorise overdraft in case of customer account(unauthorise category should be parameterised)
    !!6) If cheque is input then check cheque issued,presented,stopped
    !!7) If debit account is customer account then check posting restriction(DEBIT,ALL)
    !!8) Debit amount must be equal to sum of credit amount.
    !!9) If credit account is customer account then check posting restriction(Credit,ALL)
    !!10)Check the SYSTEM parameter file(Where suspense category,unauthorise overdraft category)
    !!11)Check suspense account is define for the originating company or not

*-----------------------------------------------------------------------------

    $INSERT I_EQUATE
    $INSERT I_COMMON
    $INSERT I_F.JBL.H.MUL.MCD
    $INSERT I_F.JBL.H.MUL.PRM
    $INSERT I_GTS.COMMON

    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.LocalReferences
    $USING EB.ErrorProcessing
    $USING ST.Config
    $USING AC.AccountOpening
    $USING AC.Config
    $USING CQ.ChqSubmit
    $USING CQ.ChqPaymentStop
    $USING LI.Config


    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*******
INIT:
*******
  
    FN.CAT='F.CATEGORY'
    F.CAT=''
    REC.CAT=''
    Y.CAT.ID=''

    FN.AC='F.ACCOUNT'
    F.AC=''
    REC.AC=''
    Y.AC.ID=''

    FN.POS.RES='F.POSTING.RESTRICT'
    F.POS.RES=''
    REC.POS.RES=''

    FN.MUL.PARAM='FBNK.JBL.H.MUL.PRM'
    F.MUL.PARAM=''
    REC.MUL.PARAM=''
    Y.RES.OVERDRAFT.CATEG=''

    FN.CHEQUE.REGISTER = 'F.CHEQUE.REGISTER'
    F.CHEQUE.REGISTER = ''

    FN.CHEQUES.STOPPED = 'F.CHEQUES.STOPPED'
    F.CHEQUES.STOPPED = ''

    FN.CHEQUES.PRESENTED = 'F.CHEQUES.PRESENTED'
    F.CHEQUES.PRESENTED = ''

    FN.CHEQUE.TYPE.ACCOUNT = 'F.CHEQUE.TYPE.ACCOUNT'
    F.CHEQUE.TYPE.ACCOUNT = ''

    FN.LIMIT="F.LIMIT"
    F.LIMIT=''

    Y.DP.STOCK="DR.STOCK.VALUE"
    Y.DP.STOCK.POS=""
    EB.LocalReferences.GetLocRef("LIMIT",Y.DP.STOCK,Y.DP.STOCK.POS)
    Y.LIMIT.CK.CATEG=''
RETURN

***********
OPENFILES:
***********
    
    EB.DataAccess.Opf(FN.CAT,F.CAT)
    EB.DataAccess.Opf(FN.AC,F.AC)
    EB.DataAccess.Opf(FN.POS.RES,F.POS.RES)
    EB.DataAccess.Opf(FN.MUL.PARAM,F.MUL.PARAM)
    EB.DataAccess.Opf(FN.CHEQUE.REGISTER,F.CHEQUE.REGISTER)
    EB.DataAccess.Opf(FN.CHEQUES.STOPPED,F.CHEQUES.STOPPED)
    EB.DataAccess.Opf(FN.CHEQUES.PRESENTED,F.CHEQUES.PRESENTED)
    EB.DataAccess.Opf(FN.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT)
    EB.DataAccess.Opf(FN.LIMIT,F.LIMIT)

RETURN



**********
PROCESS:
**********

* IF V$FUNCTION EQ 'I' OR V$FUNCTION EQ 'A' OR V$FUNCTION EQ 'V' THEN
    Y.ID.COM = EB.SystemTables.getIdCompany()
    Y.TODAY = EB.SystemTables.getToday()
    IF EB.SystemTables.getVFunction() EQ 'I' OR EB.SystemTables.getVFunction() EQ 'A' OR EB.SystemTables.getVFunction() EQ 'V' THEN
        EB.DataAccess.FRead(FN.MUL.PARAM,'SYSTEM',REC.MUL.PARAM,F.MUL.PARAM,ERR.MUL.PARAM)
        IF REC.MUL.PARAM EQ '' THEN
            EB.SystemTables.setEtext("Parameter File Missing For Multiple Debit/Credit")
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
        ELSE
            Y.RES.OVERDRAFT.CATEG=REC.MUL.PARAM<MPM.OVERDRAFT.RES.CATEG>
            Y.LIMIT.CK.CATEG=REC.MUL.PARAM<MPM.LIMIT.CHK.CATEG>
            Y.SUS.AC=''
            Y.SUS.AC=EB.SystemTables.getLccy():REC.MUL.PARAM<MPM.SUS.CATEG>:"0001":RIGHT(Y.ID.COM,4)
            EB.DataAccess.FRead(FN.AC,Y.SUS.AC,REC.AC,F.AC,ERR.AC)
            IF REC.AC EQ '' THEN
                EB.SystemTables.setEtext("Suspense Account Missing For Multiple Debit/Credit")
                EB.ErrorProcessing.StoreEndError()
                RETURN
            END

        END

        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         
        IF EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO) NE '' THEN
            CR.AC.CNT=DCOUNT(EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO),VM)
            FOR M=1 TO CR.AC.CNT
                Y.TOT.CR.AMT=Y.TOT.CR.AMT+EB.SystemTables.getRNew(MCD.CREDIT.AMOUNT)<1,M>
                Y.CR.AC.ID=EB.SystemTables.getRNew(MCD.CREDIT.ACCT.NO)<1,M>
                BEGIN CASE
                    CASE  Y.CR.AC.ID[1,2] EQ 'PL'
                        Y.CAT.ID=Y.CR.AC.ID[3,99]
                        IF NOT(Y.CAT.ID GE 50000 AND Y.CAT.ID LE 69999) THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Invalid PL Category Range")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        EB.DataAccess.FRead(FN.CAT,Y.CAT.ID,REC.CAT,F.CAT,ERR.CAT)
                        IF REC.CAT EQ '' THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Invalid PL Category")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.CR.AC.TITLE)<1,M>,REC.CAT<ST.Config.Category.EbCatDescription>)
                        END

                    CASE Y.CR.AC.ID MATCHES '3A...'
                        EB.DataAccess.FRead(FN.AC,Y.CR.AC.ID,REC.AC,F.AC,ERR.AC)
                        IF REC.AC EQ '' THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Invalid Internal Account")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.AC<AC.AccountOpening.Account.CoCode> NE Y.ID.COM THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Internal Account Does Not Belongs to this Company ":Y.ID.COM)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.CR.AC.TITLE)<1,M>,REC.AC<AC.AccountOpening.Account.AccountTitleOne>)
                        END

                    CASE OTHERWISE
                        EB.DataAccess.FRead(FN.AC,Y.CR.AC.ID,REC.CR.AC,F.AC,ERR.AC)
                        IF REC.CR.AC EQ '' THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Invalid Account Number")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.CR.AC<AC.AccountOpening.Account.CoCode> NE Y.ID.COM THEN
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("Account Does Not Belongs to this Company ":Y.ID.COM)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.CR.AC<AC.AccountOpening.Account.AllInOneProduct> NE "" THEN          ;* S/Restrict AZ.ACCOUNT Transaction
                            EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                            EB.SystemTables.setAv(M)
                            EB.SystemTables.setEtext("AZ Account not Possible To Credit ":Y.CR.AC.ID)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END   ;*E/Restrict AZ.ACCOUNT Transaction
                        IF REC.CR.AC<AC.AccountOpening.Account.PostingRestrict> NE '' THEN
                            EB.DataAccess.FRead(FN.POS.RES,REC.CR.AC<AC.AccountOpening.Account.PostingRestrict>,REC.POS.RES,F.POS.RES,ERR.POS.RES)
                            IF ( REC.POS.RES<AC.Config.PostingRestrict.PosRestrictionType> EQ 'CREDIT') OR ( REC.POS.RES<AC.Config.PostingRestrict.PosRestrictionType> EQ 'ALL') THEN
                                EB.SystemTables.setAf(MCD.CREDIT.ACCT.NO)
                                EB.SystemTables.setAv(M)
                                EB.SystemTables.setEtext("Posting Restrict In ":Y.CR.AC.ID)
                                EB.ErrorProcessing.StoreEndError()
                                RETURN
                            END
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.CR.AC.TITLE)<1,M>,REC.CR.AC<AC.AccountOpening.Account.AccountTitleOne>)
                        END
                END CASE
            NEXT M
        END
        !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

        !-----5/8/9----!
        IF EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO) NE '' THEN
            DR.AC.CNT=DCOUNT(EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO),VM)
            FOR I=1 TO DR.AC.CNT
                Y.TOT.DR.AMT=Y.TOT.DR.AMT+EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>
                Y.DR.AC.ID=EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO)<1,I>
                BEGIN CASE
                    CASE  Y.DR.AC.ID[1,2] EQ 'PL'
                        Y.CAT.ID=Y.DR.AC.ID[3,99]
                        IF NOT(Y.CAT.ID GE 50000 AND Y.CAT.ID LE 69999) THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Invalid PL Category Range")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        EB.DataAccess.FRead(FN.CAT,Y.CAT.ID,REC.CAT,F.CAT,ERR.CAT)
                        IF REC.CAT EQ '' THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Invalid PL Category")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,I> NE '' THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Cheque Number Should be Null For PL Category")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.DR.AC.TITLE)<1,I>,REC.CAT<ST.Config.Category.EbCatDescription>)
                        
                        END

                    CASE Y.DR.AC.ID MATCHES '3A...'
                        EB.DataAccess.FRead(FN.AC,Y.DR.AC.ID,REC.AC,F.AC,ERR.AC)
                        IF REC.AC EQ '' THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Invalid Internal Account")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.AC<AC.AccountOpening.Account.CoCode> NE Y.ID.COM THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Internal Account Does Not Belongs to this Company ":Y.ID.COM)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,I> NE '' THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Cheque Number Should be Null For Internal Account")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.DR.AC.TITLE)<1,I>,REC.AC<AC.AccountOpening.Account.AccountTitleOne>)
                        END
                    
                    CASE OTHERWISE
                        EB.DataAccess.FRead(FN.AC,Y.DR.AC.ID,REC.DR.AC,F.AC,ERR.AC)
                        IF REC.DR.AC EQ '' THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Invalid Account Number")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.DR.AC<AC.AccountOpening.Account.CoCode> NE Y.ID.COM THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Account Does Not Belongs to this Company ":Y.ID.COM)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        IF REC.DR.AC<AC.AccountOpening.Account.AllInOneProduct> NE "" THEN          ;* S/Restrict AZ.ACCOUNT Transaction
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("AZ Account not Possible To Debit ":Y.DR.AC.ID)
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END   ;*E/Restrict AZ.ACCOUNT Transaction
                        IF REC.DR.AC<AC.AccountOpening.Account.PostingRestrict> NE '' THEN
                            EB.DataAccess.FRead(FN.POS.RES,REC.DR.AC<AC.AccountOpening.Account.PostingRestrict>,REC.POS.RES,F.POS.RES,ERR.POS.RES)
                            IF ( REC.POS.RES<AC.Config.PostingRestrict.PosRestrictionType> EQ 'DEBIT') OR ( REC.POS.RES<AC.Config.PostingRestrict.PosRestrictionType> EQ 'ALL') THEN
                                EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                EB.SystemTables.setAv(I)
                                EB.SystemTables.setEtext("Posting Restrict In ":Y.DR.AC.ID)
                                EB.ErrorProcessing.StoreEndError()
                                RETURN
                            END
                        END

                        !----------------------------AMOUNT BLOCK-----------------!
                        IF REC.DR.AC<AC.AccountOpening.Account.LockedAmount> NE '' THEN
                            Y.BLOCK.AMT=""
                            Y.BLOCK.AMT=REC.DR.AC<AC.AccountOpening.Account.WorkingBalance>-SUM(REC.DR.AC<AC.AccountOpening.Account.LockedAmount>)
                            IF EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I> GT Y.BLOCK.AMT THEN
                                EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                EB.SystemTables.setAv(I)
                                EB.SystemTables.setEtext("Amount Blocked ":Y.DR.AC.ID)
                                EB.ErrorProcessing.StoreEndError()
                            END
                        END
                        !---------------------------AMOUNT BLOCK------------------!
                        IF NOT(Y.DR.AC.ID MATCHES '3A...') AND Y.DR.AC.ID[1,2] NE 'PL' THEN
                            LOCATE REC.DR.AC<AC.AccountOpening.Account.Category> IN  Y.RES.OVERDRAFT.CATEG<1,1> SETTING Y.POS ELSE NULL
                            IF Y.POS THEN
                                IF  REC.DR.AC<AC.AccountOpening.Account.WorkingBalance> LT EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I> THEN
                                    EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("Debit A/c ":EB.SystemTables.getRNew(MCD.DEBIT.ACCT.NO)<1,I>:" Doesn't Have Sufficient Balance")
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END
                                IF REC.DR.AC<AC.AccountOpening.Account.LockedAmount> NE '' THEN
                                    Y.AFTER.BLK.AMT = REC.DR.AC<AC.AccountOpening.Account.WorkingBalance> - REC.DR.AC<AC.AccountOpening.Account.LockedAmount>
                                    IF Y.AFTER.BLK.AMT LT EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I> THEN
                                        EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                        EB.SystemTables.setAv(I)
                                        EB.SystemTables.setEtext("Debit A/c ":EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>:" Blocked Amount ":REC.DR.AC<AC.AccountOpening.Account.LockedAmount>)
                                        EB.ErrorProcessing.StoreEndError()
                                        RETURN
                                    END
                                END
                            END
                        END
                        !---S/CC,OD Limit and Drawing Power Check--------!
                        IF REC.DR.AC<AC.AccountOpening.Account.LimitRef> NE '' THEN
                            AC.LIMIT.ID=REC.DR.AC<AC.AccountOpening.Account.Customer>:".":FMT(FIELD(REC.DR.AC<AC.AccountOpening.Account.LimitRef>,".",1,1),"R%7"):".":FMT(FIELD(REC.DR.AC<AC.AccountOpening.Account.LimitRef>,".",2,1),"R%2")
                            EB.DataAccess.FRead(FN.LIMIT,AC.LIMIT.ID,R.LIMIT,F.LIMIT,ERR.LIM)
                            IF R.LIMIT<LI.Config.LiExpiryDate> LT Y.TODAY THEN
                                EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                EB.SystemTables.setAv(I)
                                EB.SystemTables.setEtext("Limit Already Expired on =":R.LIMIT<LI.EXPIRY.DATE>)
                                EB.ErrorProcessing.StoreEndError()
                                RETURN
                            END
                            Y.DP.AMT = R.LIMIT<LI.Config.Limit.LocalRef,Y.DP.STOCK.POS>
                            IF Y.DP.AMT THEN
                                IF Y.DP.AMT LT ( ABS(REC.DR.AC<AC.AccountOpening.Account.WorkingBalance>) + EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>) THEN
                                    EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("Drawing Power Exceed By Amount = ":(Y.DP.AMT - (ABS(REC.DR.AC<AC.WORKING.BALANCE>) + EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>)))
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END
                            END
                        END
                        IF R.LIMIT<LI.Config.LiInternalAmount> LT (ABS(REC.DR.AC<AC.AccountOpening.Account.WorkingBalance>) + EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>) THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Limt Exceed By Amount = ":(R.LIMIT<LI.Config.LiInternalAmount> - (ABS(REC.DR.AC<AC.AccountOpening.Account.WorkingBalance>) + EB.SystemTables.getRNew(MCD.DEBIT.AMOUNT)<1,I>)))
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                    
                        !---S/CC,OD Limit Input Check--------------------!
                        LOCATE REC.DR.AC<AC.AccountOpening.Account.Category> IN  Y.LIMIT.CK.CATEG<1,1> SETTING Y.LIMIT.POS THEN
                            EB.SystemTables.setAf(MCD.DEBIT.ACCT.NO)
                            EB.SystemTables.setAv(I)
                            EB.SystemTables.setEtext("Limit Not Attached")
                            EB.ErrorProcessing.StoreEndError()
                            RETURN
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.DR.AC.TITLE)<1,I>,REC.AC<AC.AccountOpening.Account.AccountTitleOne>)
                        END
                        !---E/CC,OD Limit Input Check--------------------!

                        !---E/CC,OD Limit and Drawing Power Check--------!
                        IF EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,I> NE '' THEN
                            Y.CHEQUE.NO=EB.SystemTables.getRNew(MCD.CHEQUE.NUMBER)<1,I>
                            EB.DataAccess.FRead(FN.CHEQUE.TYPE.ACCOUNT,Y.DR.AC.ID,R.CHEQUE.TYPE.ACCOUNT,F.CHEQUE.TYPE.ACCOUNT,CTA.READ.ERR)
                            IF NOT(R.CHEQUE.TYPE.ACCOUNT) THEN
                                EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                EB.SystemTables.setAv(I)
                                EB.SystemTables.setEtext('MISSING CHEQUE TYPE')
                                EB.ErrorProcessing.StoreEndError()
                                RETURN
                            END ELSE
                                Y.CHEQUE.TYPE = R.CHEQUE.TYPE.ACCOUNT<CQ.ChqSubmit.ChequeType,1>
                            END
                            Y.CHQ.REG.ID = Y.CHEQUE.TYPE:'.':Y.DR.AC.ID
                            EB.DataAccess.FRead(FN.CHEQUE.REGISTER,Y.CHQ.REG.ID,R.CHEQUE.REGISTER,F.CHEQUE.REGISTER,CR.READ.ERR)
                            IF NOT(CR.READ.ERR) THEN
                                CR.ISSUE.RANGE = R.CHEQUE.REGISTER<CQ.ChqSubmit.ChequeRegister.ChequeRegChequeNos>
                                CR.ISSUE.RANGE.CNT = DCOUNT(CR.ISSUE.RANGE,@VM)
                                Y.START.NO = ''
                                FOR K = 1 TO CR.ISSUE.RANGE.CNT
                                    Y.RANGE.FLD = ''
                                    Y.RANGE.FLD = CR.ISSUE.RANGE<1,K>
                                    Y.START.NO = Y.CHEQUE.NO
                                    Y.END.NO = ''
                                    Y.RESULT = ''
                                    Y.ERROR = ''
                                    CALL EB.MAINTAIN.RANGES(Y.RANGE.FLD,Y.START.NO,Y.END.NO,'ENQ',Y.RESULT,Y.ERROR)
                                    IF Y.RESULT EQ 1 THEN EXIT
                                NEXT K
                                IF NOT(Y.RESULT) THEN
                                    EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("CHEQUE NUMBER ":Y.CHEQUE.NO:" NOT ISSUED TO THE ACCOUNT ":Y.DR.AC.ID)
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END
                                CR.RET.RANGE = R.CHEQUE.REGISTER<CQ.ChqSubmit.ChequeRegister.ChequeRegReturnedChqs>
                                LOCATE Y.CHEQUE.NO IN CR.RET.RANGE<1,1> SETTING Y.RET.RG.POS THEN
                                    EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY CANCELLED")
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END

                                Y.CHQ.PRESENTED.ID = Y.CHEQUE.TYPE:'.':Y.DR.AC.ID:'-':Y.CHEQUE.NO
                                EB.DataAccess.FRead(FN.CHEQUES.PRESENTED,Y.CHQ.PRESENTED.ID,R.CHQ.PRESENT,F.CHEQUES.PRESENTED,CHQ.PRESENT.READ.ERR)
                                IF R.CHQ.PRESENT THEN
                                    EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY PRESENTED ON ":R.CHQ.PRESENT<CQ.ChqSubmit.ChequesPresented.ChqPreDatePresented,1>)
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END
                                Y.CHQ.STOPPED.ID = Y.DR.AC.ID:'*':Y.CHEQUE.NO
                                EB.DataAccess.FRead(FN.CHEQUES.STOPPED,Y.CHQ.STOPPED.ID,R.CHQ.STOPPED,F.CHEQUES.STOPPED,CHQ.STOP.READ.ERR)
                                IF R.CHQ.STOPPED THEN
                                    EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                    EB.SystemTables.setAv(I)
                                    EB.SystemTables.setEtext("CHEQUE NUMBER ":Y.CHEQUE.NO:" ALREADY STOPPED")
                                    EB.ErrorProcessing.StoreEndError()
                                    RETURN
                                END
                            END ELSE
                                EB.SystemTables.setAf(MCD.CHEQUE.NUMBER)
                                EB.SystemTables.setAv(I)
                                EB.SystemTables.setEtext("CHEQUE REGISTER NOT AVAILABLE FOR ACCOUNT NUMBER ":Y.DR.AC.ID)
                                EB.ErrorProcessing.StoreEndError()
                                RETURN
                            END
                        END
                        ELSE
                            EB.SystemTables.setRNew(EB.SystemTables.getRNew(MCD.DR.AC.TITLE)<1,I>,REC.AC<AC.AccountOpening.Account.AccountTitleOne>)
                        END
                END CASE
            NEXT I
        END

        IF Y.TOT.CR.AMT NE Y.TOT.DR.AMT THEN
            EB.SystemTables.setEtext("Total Debit = ":Y.TOT.DR.AMT:" And Total Credit =":Y.TOT.CR.AMT:" Differ = ":(Y.TOT.DR.AMT-Y.TOT.CR.AMT))
            EB.ErrorProcessing.StoreEndError()
            RETURN
        END
    END
RETURN
END
