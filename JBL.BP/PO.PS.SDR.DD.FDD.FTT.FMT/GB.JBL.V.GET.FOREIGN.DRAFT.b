
SUBROUTINE GB.JBL.V.GET.FOREIGN.DRAFT
*-----------------------------------------------------------------------------
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*Subroutine Description:
* THIS ROUTINE IS USED FOR GETTING FDD/FTT/FMT INFORMATION FROM CHEQUE.REGISTER.SUPPLEMENT
* BASE ON GIVEN ISSUED DRAFT ORDER NO
*Attached To    : VERSION(FUNDS.TRANSFER,JBL.FOREIGN.CANCELLATION)
*Attached As    : VALIDATION ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 11/06/2024 - CREATED BY                         NEW - MD Shibli Mollah
*                                                 NITSL

* UPDATE REQUIRED FT -- LT.FT.CONT.DATE, LT.BRANCH, LT.FT.REF.NO
* FROM CRS -- ISSUE.DATE, ORIGIN.REF, CO.CODE
* 01/07/2024 - CREATED BY                         Modification - MD Shibli Mollah
*                                                 NITSL
* Cancellation must be done from the HEAD OFFICE Branch.
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
    $USING CQ.ChqConfig
    $USING ST.CompanyCreation
*-----------------------------------------------------------------------------
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
*-----------------------------------------------------------------------------

*** <region name= INITIALISE>
INITIALISE:
  
*** <desc> </desc>
    FN.CHQ.REG.SUP = "F.CHEQUE.REGISTER.SUPPLEMENT"
    F.CHQ.REG.SUP = ""
    
    FN.CHEQUE.TYPE = "F.CHEQUE.TYPE"
    F.CHEQUE.TYPE = ""
    
    FN.COM = "F.COMPANY"
    F.COM = ""
    
    FN.TT = "F.TELLER"
    F.TT = ""
    
    FN.FT = "F.FUNDS.TRANSFER"
    F.FT = ""
*------------------------------------
    Y.APP.NAME = "CHEQUE.REGISTER.SUPPLEMENT"
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = "LT.CRS.PUR.NAME"
    FLD.POS = ""
    
    EB.Foundation.MapLocalFields(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    FLD.POS = ""
    Y.CRS.PUR.NAME.POS = FLD.POS<1,1>
*
*----------------------------------------------------------------

    APPLICATION.NAMES = "TELLER":@FM:"FUNDS.TRANSFER":@FM:"CHEQUE.REGISTER.SUPPLEMENT"
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = "LT.TT.ISS.DATE":@VM:"LT.BRANCH":@VM:"LT.TT.REF.NUM":@VM:"LT.PUR.NAME":@VM:"LT.AMT.WORD":@VM:"LT.CRS.ALL.COM":@FM:"LT.FT.CONT.DATE":@VM:"LT.BRANCH":@VM:"LT.FT.REF.NO":@VM:"LT.CHQ.COM.CODE":@VM:"LT.CRS.ALL.COM":@FM:"LT.CRS.PUR.NAME":@VM:"LT.FT.CONT.DATE":@VM:"LT.BRANCH":@VM:"LT.FT.REF.NO":@VM:"LT.CRS.ALL.COM"
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
    EB.DataAccess.Opf(FN.CHEQUE.TYPE, F.CHEQUE.TYPE)
    EB.DataAccess.Opf(FN.COM, F.COM)
    EB.DataAccess.Opf(FN.TT, F.TT)
    EB.DataAccess.Opf(FN.FT, F.FT)
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
   
*** <desc> </desc>
    Y.COM = EB.SystemTables.getIdCompany()

    EB.DataAccess.FRead(FN.COM, Y.COM, Rec.Com, F.COM, Y.ERR)
    Y.FIN.CODE = Rec.Com<ST.CompanyCreation.Company.EbComFinanFinanCom>
    Y.HO.CODE = Y.FIN.CODE[6,4]
    Y.ID.COMPANY = Y.HO.CODE
    
    Y.VERSION = EB.SystemTables.getPgmVersion()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.DRAFT.NO = EB.SystemTables.getComi()

    IF Y.APPLICATION EQ "FUNDS.TRANSFER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.CURRENCY = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitCurrency)
    
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, Y.ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        Y.DRAFT.ID = Y.ISS.CHQ.TYPE:".":Y.CURRENCY:Y.CAT:"0001":Y.ID.COMPANY:".":Y.DRAFT.NO
    END

    IF Y.APPLICATION EQ "TELLER" THEN
        Y.ISS.CHQ.TYPE = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.CURRENCY = EB.SystemTables.getRNew(TT.Contract.Teller.TeCurrencyTwo)
        
        EB.DataAccess.FRead(FN.CHEQUE.TYPE, Y.ISS.CHQ.TYPE, REC.CHQ.TYPE, F.CHEQUE.TYPE, Y.ERR)
        Y.CAT = REC.CHQ.TYPE<CQ.ChqConfig.ChequeType.ChequeTypeAssignedCategory>
        Y.DRAFT.ID = Y.ISS.CHQ.TYPE:".":Y.CURRENCY:Y.CAT:"0001":Y.ID.COMPANY:".":Y.DRAFT.NO
    END
    
*--------------------------------CHQ REGISTER SUPPLIMENT------------------------*
    EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.DRAFT.ID, Rec.PO, F.CHQ.REG.SUP, Y.Err)
    Y.PO.STATUS = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsStatus>
    Y.PO.CURRENCY = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCurrency>
    Y.PO.AMT = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsAmount>
    Y.PO.PAYEE.NAME = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsPayeeName>
    Y.PO.ISS.DATE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIssueDate>
    Y.PO.ORGIN = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOrigin>
    Y.CRS.LOC.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
    Y.PO.ALLOW.COMP = Y.CRS.LOC.REF<1,Y.LT.CRS.ALL.COM.POS>
    Y.CRS.CO.CODE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCoCode>
    Y.PO.CHQ.TYP = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIdCompOne>
*----PO FROM OTHER BRANCH--- ID COMP--ACC NUM---------*
    Y.PO.AC.NO = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIdCompTwo>
  
    IF Y.PO.ORGIN EQ "TELLER" THEN
        Y.ORG.TT.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
    END
    
    EB.DataAccess.FRead(FN.TT,Y.ORG.TT.REF, R.TT, F.TT,Y.TT.ERR)
    Y.TT.LOC.REF = R.TT<TT.Contract.Teller.TeLocalRef>
*-------------------------------purchaser Name for TT ------------------------*
    Y.TT.PUR.NAME = Y.TT.LOC.REF<1,Y.LT.PUR.NAME.POS>
    Y.TT.AMT.WORD = Y.TT.LOC.REF<1, Y.LT.AMT.WORD.POS>
*-------------------------------------END--------------------------------------*

*----------------------------------purchaser name for FT-------------------------------*
    Y.PO.ORGIN.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
    EB.DataAccess.FRead(FN.FT, Y.PO.ORGIN.REF, R.FT, F.FT, Y.FT.Err)
    Y.PUR.NAME = R.FT<FT.Contract.FundsTransfer.PaymentDetails>
*-------------------------------------end---------------------------------------*

*-----------------ADD ISSUE.DATE, ORIGIN.REF & CO.CODE --------------*
    Y.ISSUE.DATE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsIssueDate>
    Y.ORIGIN.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
    Y.CO.CODE = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsCoCode>
    
*---------------------------Allow Company Validation-----------------------*
    IF (Y.CO.CODE NE "") AND (Y.COM NE Y.CO.CODE) THEN
        EB.SystemTables.setEtext("Instrument can NOT be CANCELLED from another Branch")
        EB.ErrorProcessing.StoreEndError()
    END
*---------------------------Allow Company Validation--- END --------------------*

*------------------TT---------------------*

    IF Y.APPLICATION EQ "TELLER" THEN
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

    IF Y.APPLICATION EQ "FUNDS.TRANSFER" THEN
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAcctNo, Y.PO.AC.NO)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitCurrency, Y.PO.CURRENCY)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.DebitAmount, Y.PO.AMT)
* EB.SystemTables.setRNew(FT.Contract.FundsTransfer.IssueChequeType, Y.PO.CHQ.TYP)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PayeeName, Y.PO.PAYEE.NAME)
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.PUR.NAME)
        
*----------LT.FT.CONT.DATE, LT.BRANCH, LT.FT.REF.NO----------------------UPDATE for INVALID FUNC KEY----------------
        Y.FT.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
*--------------------LT.ISSUE.DATE----------------------------------------------------------*
        Y.FT.TEMP<1,Y.LT.FT.CONT.DAT.POS> = Y.ISSUE.DATE
*--------------------LT.ISSUE.BR----------------------------------------------------------*
        Y.FT.TEMP<1,Y.LT.FT.ISSUE.BR.POS> = Y.CO.CODE
*--------------------LT.ISSUE.ORIGIN.REF----------------------------------------------------------*
        Y.FT.TEMP<1,Y.LT.FT.REF.NO.POS> = Y.ORIGIN.REF
        Y.FT.TEMP<1,Y.FT.LT.CRS.ALL.COM.POS> = Y.PO.ALLOW.COMP
        EB.SystemTables.setRNew(FT.Contract.FundsTransfer.LocalRef, Y.FT.TEMP)
*-------------------------UPDATE for INVALID FUNC KEY-----END------------------------------------------*
    END
* END
****************************
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.ISS.CHQ.TYPE: ": Y.ISS.CHQ.TYPE:" Y.CO.CODE: ":Y.CO.CODE:" Y.DRAFT.ID : ":Y.DRAFT.ID
    FileName = "SHIBLI_FDD_CANCEL_24.txt"
    FilePath = "DL.BP"
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

RETURN
*** </region>
END
