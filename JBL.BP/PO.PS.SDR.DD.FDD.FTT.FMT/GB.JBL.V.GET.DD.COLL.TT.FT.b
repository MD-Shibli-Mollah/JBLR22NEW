
SUBROUTINE GB.JBL.V.GET.DD.COLL.TT.FT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Subroutine Description:
* THIS ROUTINE USE FOR GET PO COLLECTION INFORMATION FORM CHEQUE.REGISTER.SUPPLEMENT
* BASE ON GIVEN ISSUED PO ORDER NO
*Attached To    : VERSION(FUNDS.TRANSFER,JBL.PO.COLLECTION  FUNDS.TRANSFER,MBL.IW.PO.COLLECTION TELLER,MBL.PO.PAY.CASH)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 21/08/2022 - CREATED BY                         NEW - NILOY SARKAR
*                                                 NITSL

* UPDATE REQUIRED --TT -- LT.TT.ISS.DATE, LT.BRANCH, LT.TT.REF.NUM ; FT -- LT.FT.CONT.DATE, LT.ISSUE.BRANCH, LT.FT.REF.NO
* FROM CRS -- ISSUE.DATE, ORIGIN.REF, CO.CODE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING TT.Contract
    $USING CQ.ChqSubmit
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Foundation
    $USING EB.Updates
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
  
*** <desc> </desc>
    FN.CHQ.REG.SUP='F.CHEQUE.REGISTER.SUPPLEMENT'
    F.CHQ.REG.SUP=''
*  FN.TT = 'F.TELLER'
* F.TT = ''
    FN.TEL = 'F.TELLER' ; F.TEL = ''
    FN.FT='F.FUNDS.TRANSFER'
    F.FT=''
*------------------------------------
    Y.APP.NAME ="CHEQUE.REGISTER.SUPPLEMENT"
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = "LT.CRS.PUR.NAME"
    FLD.POS = ""
    
    EB.Foundation.MapLocalFields(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    FLD.POS = ""
    Y.CRS.PUR.NAME.POS=FLD.POS<1,1>
*
*----------------------------------------------------------------

    APPLICATION.NAMES = 'TELLER':FM:'FUNDS.TRANSFER':FM:'CHEQUE.REGISTER.SUPPLEMENT'
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = 'LT.TT.ISS.DATE':VM:'LT.BRANCH':VM:'LT.TT.REF.NUM':VM:'LT.PUR.NAME':VM:'LT.AMT.WORD':VM:'LT.CRS.ALL.COM':FM:'LT.FT.CONT.DATE':VM:'LT.ISSUE.BRANCH':VM:'LT.FT.REF.NO':VM:'LT.CHQ.COM.CODE':VM:'LT.CRS.ALL.COM':FM:'LT.CRS.PUR.NAME':VM:'LT.FT.CONT.DATE':VM:'LT.ISSUE.BRANCH':VM:'LT.FT.REF.NO':VM:'LT.CRS.ALL.COM'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(APPLICATION.NAMES, LOCAL.FIELDS, FLD.POS)
    Y.LT.TT.ISS.DATE.POS = FLD.POS<1,1>
    Y.TT.LT.BRANCH.POS = FLD.POS<1,2>
    Y.LT.TT.REF.NUM.POS = FLD.POS<1,3>
    Y.LT.PUR.NAME.POS = FLD.POS<1,4>
    Y.LT.AMT.WORD.POS = FLD.POS<1,5>
    Y.TT.LT.CRS.ALL.COM.POS = FLD.POS<1,6>
    Y.LT.FT.CONT.DAT.POS = FLD.POS<2,1>
    Y.LT.FT.ISSUE.BR.POS = FLD.POS<2,2>
    Y.LT.FT.REF.NO.POS = FLD.POS<2,3>
    Y.ISS.BR.CODE.POS = FLD.POS<2,4>
    Y.FT.LT.CRS.ALL.COM.POS = FLD.POS<2,5>
    Y.CRS.PUR.NAME.POS=FLD.POS<3,1>
    Y.LT.CQ.CONT.DATE.POS= FLD.POS<3,2>
    Y.LT.CQ.ISSUE.BRANCH.POS= FLD.POS<3,3>
    Y.LT.CQ.REF.NO.POS= FLD.POS<3,4>
    Y.LT.CRS.ALL.COM.POS = FLD.POS<3,5>
    
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
    
*** <desc> </desc>
    EB.DataAccess.Opf(FN.CHQ.REG.SUP, F.CHQ.REG.SUP)
    EB.DataAccess.Opf(FN.TEL, F.TEL)
    EB.DataAccess.Opf(FN.FT, F.FT)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
   
*** <desc> </desc>
    Y.ID.COMPANY = EB.SystemTables.getIdCompany()
    Y.VERSION = EB.SystemTables.getPgmVersion()
    BEGIN CASE
        CASE (Y.VERSION EQ ',JBL.DD.COLLECTION') OR  (Y.VERSION EQ ',JBL.FDD.COLLECTION') OR (Y.VERSION EQ ',JBL.FTT.COLLECTION') OR (Y.VERSION EQ ',JBL.DD.CANCELLATION')
            Y.FT.ISS.TYP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
            Y.PO.NO = EB.SystemTables.getComi()
        CASE (Y.VERSION EQ ',JBL.DD.PAY.CASH') OR (Y.VERSION EQ ',JBL.DD.CANCEL.CASH')
            Y.TT.ISS.TYP = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
            Y.PO.NO = EB.SystemTables.getComi()
    END CASE
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        SEL.CMD = "SELECT ":FN.CHQ.REG.SUP:" WITH @ID LIKE ":Y.FT.ISS.TYP:'...':Y.PO.NO
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    END
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        SEL.CMD = "SELECT ":FN.CHQ.REG.SUP:" WITH @ID LIKE ":Y.TT.ISS.TYP:'...':Y.PO.NO
        EB.DataAccess.Readlist(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)
    END
    
* EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.PO.ID, Rec.PO, F.CHQ.REG.SUP, Y.Err)
*--------------------------------CHQ REGISTER SUPPLIMENT------------------------*
    IF SEL.LIST THEN
        REMOVE Y.PO.ID FROM SEL.LIST SETTING Y.POS
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.PO.ID, Rec.PO, F.CHQ.REG.SUP, Y.Err)
        Y.PO.STATUS=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsStatus>
        Y.PO.CURRENCY=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCurrency>
        Y.PO.AMT=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsAmount>
        Y.PO.PAYEE.NAME=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsPayeeName>
        Y.PO.ISS.DATE=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIssueDate>
        Y.PO.ORGIN=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOrigin>
        Y.CRS.LOC.REF= Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.PO.ALLOW.COMP = Y.CRS.LOC.REF<1,Y.LT.CRS.ALL.COM.POS>
        Y.CRS.CO.CODE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCoCode>
  
        IF Y.PO.ORGIN EQ 'TELLER' THEN
            Y.ORG.TT.REF=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
        END
        EB.DataAccess.FRead(FN.TEL,Y.ORG.TT.REF, R.TT, F.TEL,Y.TT.ERR)
        Y.TT.LOC.REF= R.TT<TT.Contract.Teller.TeLocalRef>
*-------------------------------purchaser Name for TT ------------------------*
        Y.TT.PUR.NAME = Y.TT.LOC.REF<1,Y.LT.PUR.NAME.POS>
        Y.TT.AMT.WORD = Y.TT.LOC.REF<1, Y.LT.AMT.WORD.POS>
        Y.PO.ORGIN.REF= Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
*-------------------------------------END--------------------------------------*
*----------------------------------purchaser name-------------------------------*
        EB.DataAccess.FRead(FN.FT, Y.PO.ORGIN.REF, R.FT, F.FT, Y.FT.Err)
        Y.PUR.NAME= R.FT<FT.Contract.FundsTransfer.PaymentDetails>
*-------------------------------------end--------------------------------
        Y.PO.CHQ.TYP=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIdCompOne>
*----PO FROM OTHER BRANCH--- ID COMP--ACC NUM---------*
        Y.PO.AC.NO=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIdCompTwo>
       
*Y.PUR.NAME=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef,Y.CRS.PUR.NAME.POS>

*-----------------ADD ISSUE.DATE, ORIGIN.REF & CO.CODE --------------*
        Y.ISSUE.DATE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIssueDate>
        Y.ORIGIN.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
        Y.CO.CODE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCoCode>
    END
*    ELSE
*        EB.SystemTables.setEtext('Payorder Is Not Issued/Wrong Issue Branch')
*        EB.ErrorProcessing.StoreEndError()
*    END
*---------------------------Allow Company Validation-----------------------*
    IF Y.PO.ALLOW.COMP EQ 'NO' AND (Y.CRS.CO.CODE NE Y.ID.COMPANY) THEN
        EB.SystemTables.setEtext('Payorder Is Not Issued/Wrong Issue Branch')
        EB.ErrorProcessing.StoreEndError()
    END
    
    BEGIN CASE
        CASE (Y.VERSION EQ ',JBL.PO.CANCELLATION') OR (Y.VERSION EQ ',JBL.PO.CANCEL.CASH')
            IF (Y.CRS.CO.CODE NE Y.ID.COMPANY) THEN
                EB.SystemTables.setEtext('Can not cancle from another Branch')
                EB.ErrorProcessing.StoreEndError()
            END
        CASE (Y.VERSION EQ ',JBL.DD.CANCELLATION') OR (Y.VERSION EQ ',JBL.DD.CANCEL.CASH')
            IF (Y.CRS.CO.CODE EQ Y.ID.COMPANY) THEN
                EB.SystemTables.setEtext('Can not cancle from Current Branch')
                EB.ErrorProcessing.StoreEndError()
            END
    END CASE
     
*------------------------------Allow Company validation End------------------*
*------------------TT---------------------*
    IF Y.PO.ALLOW.COMP EQ 'YES' OR (Y.VERSION EQ ',JBL.DD.COLLECTION') OR (Y.VERSION EQ ',JBL.DD.PAY.CASH') OR (Y.VERSION EQ ',JBL.FDD.COLLECTION') OR (Y.VERSION EQ ',JBL.FTT.COLLECTION') OR (Y.VERSION EQ ',JBL.DD.CANCELLATION') OR (Y.VERSION EQ ',JBL.DD.CANCEL.CASH') THEN
        IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TePayeeName, Y.PO.PAYEE.NAME)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeCurrencyOne, Y.PO.CURRENCY)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne, Y.PO.AMT)
*----PO FROM OTHER BRANCH--- ID COMP--ACC NUM--Y.PO.AC.NO-------modified on 24th feb 2021 - SHIBLI FDS-
* EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountTwo, Y.PO.AC.NO)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAccountOne, Y.PO.AC.NO)
* EB.SystemTables.setRNew(TT.Contract.Teller.TeIssueChequeType,Y.PO.CHQ.TYP)
        
*-----PO ISSUE DATE -- TT -- LT.TT.ISS.DATE, LT.BRANCH, LT.TT.REF.NUM, LT.PUR.NAME -------UPDATE for INVALID FUNC KEY-----
            Y.TEMP = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
            Y.TEMP<1,Y.LT.TT.ISS.DATE.POS> = Y.ISSUE.DATE
*-------LT TT BRANCH----------------------------------------*
            Y.TEMP<1,Y.TT.LT.BRANCH.POS> = Y.CO.CODE
*-------TT FT REF NO-----------------------------------------*
            Y.TEMP<1,Y.LT.TT.REF.NUM.POS> = Y.ORIGIN.REF
*-------PURCHASER NAME---------------------------------------*
            Y.TEMP<1,Y.LT.PUR.NAME.POS> = Y.TT.PUR.NAME
        
            Y.TEMP<1, Y.LT.AMT.WORD.POS> = Y.TT.AMT.WORD
            Y.TEMP<1,Y.TT.LT.CRS.ALL.COM.POS> = Y.PO.ALLOW.COMP
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.TEMP)
*--------------------UPDATE for INVALID FUNC KEY--END------------------------------------------*
        END
*---------------TT END---------------------------------------------------*
    
*    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' AND Y.PO.ORGIN EQ 'FUNDS.TRANSFER' THEN
 
        IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.PO.AC.NO)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditCurrency, Y.PO.CURRENCY)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAmount, Y.PO.AMT)
* EB.SystemTables.setRNew(FT.Contract.FundsTransfer.IssueChequeType, Y.PO.CHQ.TYP)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PayeeName, Y.PO.PAYEE.NAME)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.PUR.NAME)
*EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.PURCH.NAME)
*----------LT.FT.CONT.DATE, LT.ISSUE.BRANCH, LT.FT.REF.NO----------------------UPDATE for INVALID FUNC KEY----------------
            Y.FT.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
*-----------LT.ISSUE.DATE----------------------------------------------------------*
        
            Y.FT.TEMP<1,Y.LT.FT.CONT.DAT.POS> = Y.ISSUE.DATE
*-----------LT.ISSUE.BR----------------------------------------------------------*
    
            Y.FT.TEMP<1,Y.LT.FT.ISSUE.BR.POS> = Y.CO.CODE
*-----------LT.ISSUE.ORIGIN.REF----------------------------------------------------------*
            Y.FT.TEMP<1,Y.LT.FT.REF.NO.POS> = Y.ORIGIN.REF
            Y.FT.TEMP<1,Y.FT.LT.CRS.ALL.COM.POS> = Y.PO.ALLOW.COMP
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.FT.TEMP)
*-------------------------UPDATE for INVALID FUNC KEY-----END------------------------------------------*
        END
    END
****************************
RETURN
*** </region>
END
