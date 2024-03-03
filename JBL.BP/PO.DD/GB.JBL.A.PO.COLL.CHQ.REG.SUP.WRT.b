SUBROUTINE GB.JBL.A.PO.COLL.CHQ.REG.SUP.WRT

*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $USING FT.Contract
    $USING TT.Contract
    $USING CQ.ChqSubmit
    $USING EB.DataAccess
    $USING EB.SystemTables
    $USING EB.ErrorProcessing
    $USING EB.Updates
    $USING EB.TransactionControl
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
    FN.FT='F.FUNDS.TRANSFER'
    F.FT=''
    FN.TEL = 'F.TELLER' ; F.TEL = ''
RETURN
*** </region>


*-----------------------------------------------------------------------------

*** <region name= OPENFILE>
OPENFILE:
*** <desc> </desc>
    EB.DataAccess.Opf(FN.CHQ.REG.SUP, F.CHQ.REG.SUP)
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.TEL, F.TEL)
RETURN
*** </region>

*-----------------------------------------------------------------------------

*** <region name= PROCESS>
PROCESS:
*** <desc> </desc>
    Y.APP.NAME ="CHEQUE.REGISTER.SUPPLEMENT" :FM: 'TELLER':FM:'FUNDS.TRANSFER'
    LOCAL.FIELDS = "LT.CRS.COLL.DAT":VM:"LT.CRS.COLL.REF":VM:"LT.CRS.COLL.CO":VM:"LT.CRS.PUR.NAME":VM:'NEW.STATUS':VM:'LT.CRS.OLD.PO':VM:'LT.CRS.ALL.COM':FM:'LT.PUR.NAME':FM:'LT.TT.PO.CANCEL':VM:'LT.OLD.PO.NO'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.CRS.COLL.DAT.POS=FLD.POS<1,1>
    Y.CRS.COLL.REF.POS=FLD.POS<1,2>
    Y.CRS.COLL.CO.POS=FLD.POS<1,3>
    Y.CRS.PUR.NAME.POS=FLD.POS<1,4>
    Y.CRS.NEW.STATUS.POS=FLD.POS<1,5>
    Y.LT.CRS.OLD.PO.POS=FLD.POS<1,6>
    Y.LT.CRS.ALL.COM.POS=FLD.POS<1,7>
    Y.LT.PUR.NAME.POS =FLD.POS<2,1>
    Y.FT.LT.OLD.PO.NO.POS=FLD.POS<3,1>
    Y.FT.LT.TT.PO.CANCEL.POS=FLD.POS<3,2>

    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.PO.COLL.DATE=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
        Y.PO.AC=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        Y.PO.NO=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.StockNumber)
        Y.PURCH.NAME= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
        Y.ISSUE.CQ.TYP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.PO.COLL.REF=EB.SystemTables.getIdNew()
        Y.PO.COLL.CO=EB.SystemTables.getIdCompany()
        
*        Y.FT.LOC.REF= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
*        Y.FT.OLD.PO.NO = Y.FT.LOC.REF<1,Y.FT.LT.OLD.PO.NO.POS>
*        Y.FT.TT.PO.STATUS = Y.FT.LOC.REF<1,Y.FT.LT.TT.PO.CANCEL.POS>

* Y.ID='PO.':Y.PO.AC:".":Y.PO.NO
        Y.ID = Y.ISSUE.CQ.TYP:'.':Y.PO.AC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.FT.PO.STATUS = Y.LOC.CHQ<1,Y.CRS.NEW.STATUS.POS>
        Y.FT.OLD.PO.NO = Y.LOC.CHQ<1,Y.LT.CRS.OLD.PO.POS>
* Y.PO.ALL.COMPANY = Y.LOC.CHQ<1,Y.LT.CRS.ALL.COM.POS>
        Y.PO.ALL.COMPANY = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef,Y.LT.CRS.ALL.COM.POS>
 
        Y.CQ.TEMP = EB.SystemTables.getRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef)
        Y.CQ.TEMP<1,Y.CRS.COLL.DAT.POS> = Y.PO.COLL.DATE
        Y.CQ.TEMP<1,Y.CRS.COLL.REF.POS> = Y.PO.COLL.REF
        Y.CQ.TEMP<1,Y.CRS.COLL.CO.POS> = Y.PO.COLL.CO
        Y.CQ.TEMP<1,Y.CRS.PUR.NAME.POS> = Y.PURCH.NAME
        Y.CQ.TEMP<1,Y.CRS.NEW.STATUS.POS> = Y.FT.PO.STATUS
        Y.CQ.TEMP<1,Y.LT.CRS.OLD.PO.POS> = Y.FT.OLD.PO.NO
        Y.CQ.TEMP<1,Y.LT.CRS.ALL.COM.POS> = Y.PO.ALL.COMPANY
  
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.CQ.TEMP
        !EB.SystemTables.setRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef, Y.CQ.TEMP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.ID
    END

    
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.PO.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeStockNumber)
        Y.PO.ACC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountTwo)
        Y.PO.TT.COLL.DAT = EB.SystemTables.getRNew(TT.Contract.Teller.TeValueDateOne)
        Y.TT.ISS.CHQ = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.PO.COLL.REF.TT = EB.SystemTables.getIdNew()
        Y.PO.COLL.CO.CODE = EB.SystemTables.getIdCompany()
*--------------------------------PUR NAME ------------------------------
        Y.TT.LOC.REF= EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.TT.PUR.NAME = Y.TT.LOC.REF<1,Y.LT.PUR.NAME.POS>
        
*------------------------------------------------------------------------
* Y.ID='PO.':Y.PO.ACC:'.':Y.PO.NO
        Y.ID = Y.TT.ISS.CHQ:'.':Y.PO.ACC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
   
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.PO.ALL.COMPANY = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef,Y.LT.CRS.ALL.COM.POS>
        
 
        Y.CQ.TEMP = EB.SystemTables.getRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef)
        Y.CQ.TEMP<1,Y.CRS.COLL.DAT.POS> = Y.PO.TT.COLL.DAT
        Y.CQ.TEMP<1,Y.CRS.COLL.REF.POS> = Y.PO.COLL.REF.TT
        Y.CQ.TEMP<1,Y.CRS.COLL.CO.POS> = Y.PO.COLL.CO.CODE
        Y.CQ.TEMP<1,Y.CRS.PUR.NAME.POS> = Y.TT.PUR.NAME
        Y.CQ.TEMP<1,Y.LT.CRS.ALL.COM.POS> = Y.PO.ALL.COMPANY
  
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.CQ.TEMP
        !EB.SystemTables.setRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef, Y.CQ.TEMP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.ID
    END
    
RETURN
END