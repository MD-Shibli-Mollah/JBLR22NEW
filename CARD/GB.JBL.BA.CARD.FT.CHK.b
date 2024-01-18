* @ValidationCode : MjotMjA0MDI5MDQ0NjpDcDEyNTI6MTcwNTIzNDE1MzExMTpuYXppaGFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMTcxMC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 14 Jan 2024 18:09:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : nazihar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_201710.0
*-----------------------------------------------------------------------------

SUBROUTINE GB.JBL.BA.CARD.FT.CHK

*-----------------------------------------------------------------------------
* Modification History :
* 1)
* Deploy Date: 12 JAN 2019
* Date :31/12/2023
* Modification Description : RETROFIT from TAFC to TAFJ
* Modified By : MD Shibli Mollah - NITSL
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
* Subroutine Description: THIS ROUTINE IS USED FOR CRMS -CHECK FT BEFORE AUTHRISED THE REQUEST
* Subroutine Type: BEFORE AUTH
* Attached To    : EB.JBL.ATM.CARD.MGT
* Attached As    : BEFORE AUTH ROUTINE
* TAFC Routine Name : JBL.CARD.FT.CHK - R09
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
* $INSERT GLOBUS.BP I_F.ACCOUNT
    $USING AC.AccountOpening
* $INSERT BP I_F.ATM.CARD.MGT
    $INSERT I_F.EB.JBL.ATM.CARD.MGT
*    $INSERT GLOBUS.BP I_F.FUNDS.TRANSFER
    $USING FT.Contract
*    $INSERT BP I_F.JBL.ATM.MAINT.CALC
    $INSERT I_F.EB.JBL.ATM.MAINT.CALC
*    $INSERT GLOBUS.BP I_F.FT.COMMISSION.TYPE
    $USING CG.ChargeConfig
*    $INCLUDE BP I_F.JBL.CARD.OFF.INFO
    $INSERT I_F.EB.JBL.CARD.OFF.INFO
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    $USING EB.ErrorProcessing
    $USING EB.TransactionControl
    $USING EB.API
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "GB.JBL.BA.CARD.FT.CHK Routine is found Successfully"
    FileName = 'SHIBLI_ATM.txt'
    FilePath = 'D:/Temenos/t24home/default/DL.BP'
    OPENSEQ FilePath,FileName TO FileOutput THEN NULL
    ELSE
        CREATE FileOutput ELSE
        END
    END
    WRITESEQ WriteData APPEND TO FileOutput ELSE
        CLOSESEQ FileOutput
    END
    CLOSESEQ FileOutput
*******--------------------------TRACER-END--------------------------------------------------------*********************

    FN.ATM.NAU = "F.EB.JBL.ATM.CARD.MGT$NAU"
    F.ATM.NAU = ""
    FN.JBL.ATM = 'F.EB.JBL.ATM.MAINT.CALC'
    F.JBL.ATM = ''
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""
    FN.FT.NAU = "F.FUNDS.TRANSFER$NAU"
    F.FT.NAU = ""
    FN.FT.HIS = "F.FUNDS.TRANSFER$HIS"
    F.FT.HIS = ""
    FN.COMM = "F.FT.COMMISSION.TYPE"
    F.COMM = ''
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    FN.CARD.OFF = "F.EB.JBL.CARD.OFF.INFO"
    F.CARD.OFF = ""
    
* EB.DataAccess.Opf(YnameIn, YnameOut)
    EB.DataAccess.Opf(FN.FT,F.FT)
    EB.DataAccess.Opf(FN.FT.NAU,F.FT.NAU)
    EB.DataAccess.Opf(FN.FT.HIS,F.FT.HIS)
    EB.DataAccess.Opf(FN.JBL.ATM,F.JBL.ATM)
    EB.DataAccess.Opf(FN.ACC,F.ACC)
    EB.DataAccess.Opf(FN.COMM,F.COMM)
    EB.DataAccess.Opf(FN.CARD.OFF, F.CARD.OFF)
    
*-------init VAR--------------------------------------*
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.CARD.STATUS = EB.SystemTables.getRNew(EB.ATM19.CARD.STATUS)
    Y.ATTR = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE5)
    Y.ISS.WAIVE = EB.SystemTables.getRNew(EB.ATM19.ISSUE.WAIVE.CHARGE)
    Y.ATM.REQ.TYPE = EB.SystemTables.getRNew(EB.ATM19.REQUEST.TYPE)
    Y.REISSUE.REASON = EB.SystemTables.getRNew(EB.ATM19.REISSUE.REASON)
    

* IF V$FUNCTION EQ 'A' AND  R.NEW(EB.ATM19.CARD.STATUS) EQ "PENDING" AND R.NEW(EB.ATM19.ATTRIBUTE5) EQ "" AND R.NEW(EB.ATM19.ISSUE.WAIVE.CHARGE) EQ 'NO'   THEN
    IF Y.VFUNCTION EQ 'A' AND  Y.CARD.STATUS EQ "PENDING" AND Y.ATTR EQ "" AND Y.ISS.WAIVE EQ 'NO' THEN
* IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "REISSUE" AND R.NEW(EB.ATM19.REISSUE.REASON) EQ 5 THEN
        IF Y.ATM.REQ.TYPE EQ "REISSUE" AND Y.REISSUE.REASON EQ 5 THEN

        END
* ELSE IF R.NEW(EB.ATM19.REQUEST.TYPE) EQ "PINREISSUE" AND R.NEW(EB.ATM19.REISSUE.REASON) EQ 7 THEN
        ELSE IF Y.ATM.REQ.TYPE EQ "PINREISSUE" AND Y.REISSUE.REASON EQ 7 THEN

        END
    
        ELSE
* ETEXT ="PLEASE FIRST DEDUCT ":R.NEW(EB.ATM19.REQUEST.TYPE) :" FEE BY USING ATM Card Related Fee Deduction MENU THIS REQUEST"
            EB.SystemTables.setEtext("PLEASE FIRST DEDUCT ":Y.ATM.REQ.TYPE:" FEE BY USING ATM Card Related Fee Deduction MENU for this REQUEST")
* EB.ErrorProcessing.StoreEndError()
            EB.ErrorProcessing.StoreEndError()
        END
    END
*    Y.REQUEST.TYPE=R.NEW(EB.ATM19.REQUEST.TYPE)
    Y.REQUEST.TYPE = Y.ATM.REQ.TYPE
*    Y.AC.ID=R.NEW(EB.ATM19.ACCT.NO)
    Y.AC.ID = EB.SystemTables.getRNew(EB.ATM19.ACCT.NO)
*    EB.DataAccess.FRead(FN.ACC,Y.AC.ID,REC.ACC,F.ACC,ERR.ACC)
    EB.DataAccess.FRead(FN.ACC, Y.AC.ID, REC.ACC, F.ACC, ERR.ACC)
*    Y.CATEGORY=REC.ACC<AC.CATEGORY>
    Y.CATEGORY = REC.ACC<AC.AccountOpening.Account.Category>

    EB.DataAccess.FRead(FN.CARD.OFF, Y.AC.ID,REC.OPP, F.CARD.OFF, ERR.OPP)
    Y.CARD.OFFER.VAL = REC.OPP<EB.JBL.CARD.OFF.CARD.OFFER>

    EB.DataAccess.FRead(FN.JBL.ATM, Y.REQUEST.TYPE, REC.ATM.CHRG, F.JBL.ATM, ERR.CDSTD.HF)
    IF REC.ATM.CHRG EQ '' THEN
* ETEXT="There must be a record ": Y.REQUEST.TYPE :" in JBL.ATM.MAINT.CALC"
        EB.SystemTables.setEtext("There must be a record ": Y.REQUEST.TYPE :" in EB.JBL.ATM.MAINT.CALC")
        EB.ErrorProcessing.StoreEndError()
        RETURN
    END
    Y.INCLUDE.CATEGORY = REC.ATM.CHRG<EB.ATM.MAINT.INCLUDE.CATEGORY>

    FIND Y.CATEGORY IN Y.INCLUDE.CATEGORY SETTING Ap, Vp THEN
        Y.TRN.TYPE= REC.ATM.CHRG<EB.ATM.MAINT.TRANSACTION.TYPE>
        Y.VEN.ACT = REC.ATM.CHRG<EB.ATM.MAINT.VEN.ACCT,Vp>
        Y.VEN.AMT = REC.ATM.CHRG<EB.ATM.MAINT.VEN.CHARGE.AMT,Vp>
        IF Y.CARD.OFFER.VAL NE "50Percent" THEN
            Y.CHRG.TYPE = REC.ATM.CHRG<EB.ATM.MAINT.CHARGE.TYPE,Vp>
            Y.BR.CHRG.AMT = REC.ATM.CHRG<EB.ATM.MAINT.BRANCH.CHARGE.AMT,Vp>
            Y.FT.COMM = REC.ATM.CHRG<EB.ATM.MAINT.FT.COMM.TYPE,Vp>
            Y.FT.COM.AMT = REC.ATM.CHRG<EB.ATM.MAINT.FT.COMM.AMT,Vp>
            Y.VAT.PER = REC.ATM.CHRG<EB.ATM.MAINT.VAT.PERCENT,Vp>
        END
    END
* Y.FT.ID = R.NEW(EB.ATM19.ATTRIBUTE5)
    Y.FT.ID = EB.SystemTables.getRNew(EB.ATM19.ATTRIBUTE5)

    IF Y.FT.ID NE "" THEN
        EB.DataAccess.FRead(FN.FT.NAU, Y.FT.ID, REC.FT.CHK, F.FT.NAU,ERR.FT)

        IF REC.FT.CHK NE "" THEN
* ETEXT ="CRMS-FUNDS TRANSFER UNAUTHRISED STAGE"
            EB.SystemTables.setEtext("CRMS-FUNDS TRANSFER UNAUTHRISED STAGE")
            EB.ErrorProcessing.StoreEndError()
        END
        IF REC.FT.CHK EQ "" THEN
            EB.DataAccess.FRead(FN.FT, Y.FT.ID, REC.FT.CHK, F.FT, ERR.FT.LIVE)
            IF REC.FT.CHK EQ "" THEN
* CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.FT.ID,REC.FT.CHK,Y.ERR.FT.HIS)
                EB.DataAccess.ReadHistoryRec(F.FT.HIS,Y.FT.ID,REC.FT.CHK,Y.ERR.FT.HIS)
                Y.FT.REC.STATUS = REC.FT.CHK<FT.Contract.FundsTransfer.RecordStatus>
* IF REC.FT.CHK<FT.RECORD.STATUS> EQ "REVE" THEN
                IF Y.FT.REC.STATUS EQ "REVE" THEN
* ETEXT ="CRMS-FUNDS TRANSFER ALREADY REVERSED"
                    EB.SystemTables.setEtext("CRMS-FUNDS TRANSFER ALREADY REVERSED")
                    EB.ErrorProcessing.StoreEndError()
                END
            END
        END

*------------------INIT VER ----FT----------------------------------------*
        Y.FT.TRN.TYPE = REC.FT.CHK<FT.Contract.FundsTransfer.TransactionType>
        Y.FT.CR.AC = REC.FT.CHK<FT.Contract.FundsTransfer.CreditAcctNo>
        Y.FT.DR.AC = REC.FT.CHK<FT.Contract.FundsTransfer.DebitAcctNo>
        Y.FT.DR.AMT = REC.FT.CHK<FT.Contract.FundsTransfer.DebitAmount>
        Y.FT.COM.TYPE = REC.FT.CHK<FT.Contract.FundsTransfer.CommissionType>
        Y.FT.COM.AMT = REC.FT.CHK<FT.Contract.FundsTransfer.CommissionAmt>
        Y.FT.TAX.AMT = REC.FT.CHK<FT.Contract.FundsTransfer.TaxAmt>

        IF REC.FT.CHK NE "" THEN
* IF Y.TRN.TYPE NE REC.FT.CHK<FT.TRANSACTION.TYPE> THEN
            IF Y.TRN.TYPE NE Y.FT.TRN.TYPE THEN
* ETEXT ="CRMS-INVALID TRANSACTION TYPE"
                EB.SystemTables.setEtext("CRMS-INVALID TRANSACTION TYPE")
                EB.ErrorProcessing.StoreEndError()
            END

* IF  Y.VEN.ACT NE REC.FT.CHK<FT.CREDIT.ACCT.NO> THEN
            IF  Y.VEN.ACT NE Y.FT.CR.AC THEN
* ETEXT ="CRMS-INVALID CREDIT ACCOUNT"
                EB.SystemTables.setEtext("CRMS-INVALID CREDIT ACCOUNT")
                EB.ErrorProcessing.StoreEndError()
            END
* IF  Y.VEN.AMT NE REC.FT.CHK<FT.DEBIT.AMOUNT> THEN
            IF  Y.VEN.AMT NE Y.FT.DR.AMT THEN
* ETEXT ="CRMS-INVALID DEBIT AMOUNT"
                EB.SystemTables.setEtext("CRMS-INVALID DEBIT ACCOUNT")
                EB.ErrorProcessing.StoreEndError()
            END
* IF  Y.AC.ID NE REC.FT.CHK<FT.DEBIT.ACCT.NO> THEN
            IF  Y.AC.ID NE Y.FT.DR.AC THEN
* ETEXT ="CRMS-INVALID DEBIT ACCOUNT"
                EB.SystemTables.setEtext("CRMS-INVALID DEBIT ACCOUNT")
                EB.ErrorProcessing.StoreEndError()
            END

            IF Y.FT.COM.AMT NE "" THEN
* IF  Y.FT.COMM NE REC.FT.CHK<FT.COMMISSION.TYPE> THEN
                IF  Y.FT.COMM NE Y.FT.COM.TYPE THEN
* ETEXT ="CRMS-INVALID FT COMMISSION"
                    EB.SystemTables.setEtext("CRMS-INVALID FT COMMISSION")
                    EB.ErrorProcessing.StoreEndError()
                END

                EB.DataAccess.FRead(FN.COMM, Y.FT.COMM, REC.COMM, F.COMM, ERR.COMM)
* Y.TAX.CODE=REC.COMM<FT4.TAX.CODE>
                Y.TAX.CODE = REC.COMM<CG.ChargeConfig.FtCommissionType.FtFouTaxCode>
                Y.LCCY = REC.COMM<CG.ChargeConfig.FtCommissionType.FtFouCurrency>
* CALL EB.ROUND.AMOUNT(LCCY,Y.FT.COM.AMT,"","")
                EB.API.RoundAmount(Y.LCCY, Y.FT.COM.AMT, "", "")
        
* Y.LIVE.AMT=OCONV(REC.FT.CHK<FT.COMMISSION.AMT>,"MC/A")
                Y.LIVE.AMT = OCONV(Y.FT.COM.AMT,"MC/A")

                IF Y.FT.COM.AMT NE Y.LIVE.AMT THEN
* ETEXT ="CRMS-INVALID FT COMMISSION AMT"
                    EB.SystemTables.setEtext("CRMS-INVALID FT COMMISSION AMT")
                    EB.ErrorProcessing.StoreEndError()
                END

                Y.TAX.AMT = (Y.FT.COM.AMT*15)/100
* CALL EB.ROUND.AMOUNT(LCCY,Y.TAX.AMT,"","")
                EB.API.RoundAmount(Y.LCCY, Y.TAX.AMT, "", "")
            
                Y.TAX.AMT = "BDT":Y.TAX.AMT
                
* IF Y.TAX.CODE NE "" AND REC.FT.CHK<FT.TAX.AMT> NE Y.TAX.AMT THEN
                IF Y.TAX.CODE NE "" AND Y.FT.TAX.AMT NE Y.TAX.AMT THEN
* ETEXT ="CRMS-INVALID TAX AMT"
                    EB.SystemTables.setEtext("CRMS-INVALID TAX AMT")
                    EB.ErrorProcessing.StoreEndError()
                END
            END

            IF Y.REQUEST.TYPE EQ "PINREISSUE" OR Y.REQUEST.TYPE EQ "CLOSE" THEN
* IF Y.FT.COMM NE REC.FT.CHK<FT.COMMISSION.TYPE> THEN
                IF Y.FT.COMM NE Y.FT.COM.TYPE THEN
* ETEXT ="CRMS-INVALID FT COMMISSION"
                    EB.SystemTables.setEtext("CRMS-INVALID FT COMMISSION")
                    EB.ErrorProcessing.StoreEndError()
                END

* Y.FT.AMT=(REC.FT.CHK<FT.DEBIT.AMOUNT>*15)/100
                Y.FT.AMT = (Y.FT.DR.AMT*15)/100
            
* CALL EB.ROUND.AMOUNT(LCCY,Y.FT.AMT,"","")
                EB.API.RoundAmount(Y.LCCY, Y.FT.AMT, "", "")
                Y.FT.AMT = "BDT":Y.FT.AMT

* IF REC.FT.CHK<FT.COMMISSION.AMT> NE Y.FT.AMT  THEN
* ETEXT ="CRMS-INVALID COMMISSION AMT"
                EB.SystemTables.setEtext("CRMS-INVALID COMMISSION AMT")
                EB.ErrorProcessing.StoreEndError()
            END
        END

    END

RETURN

END

