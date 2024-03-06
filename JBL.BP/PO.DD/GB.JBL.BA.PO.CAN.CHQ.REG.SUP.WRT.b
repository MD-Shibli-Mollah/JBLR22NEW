SUBROUTINE GB.JBL.BA.PO.CAN.CHQ.REG.SUP.WRT
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------

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
    FN.TEL= 'F.TELLER' ; F.TEL =''
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
     
    Y.APP.NAME ="CHEQUE.REGISTER.SUPPLEMENT": FM:'FUNDS.TRANSFER':FM:'TELLER'
    LOCAL.FIELDS = "LT.CRS.COLL.DAT":VM:"LT.CRS.COLL.REF":VM:"LT.CRS.COLL.CO":VM:'LT.CRS.PUR.NAME':VM:'NEW.STATUS':FM:'LT.TT.PO.CANCEL':FM:'LT.PUR.NAME':VM:'LT.TT.PO.CANCEL'
    FLD.POS = ""
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.CRS.COLL.DAT.POS=FLD.POS<1,1>
    Y.CRS.COLL.REF.POS=FLD.POS<1,2>
    Y.CRS.COLL.CO.POS=FLD.POS<1,3>
    Y.CRS.PUR.NAME.POS=FLD.POS<1,4>
    Y.NEW.STATUS.POS=FLD.POS<1,5>
    LT.TT.PO.CANCEL.POS = FLD.POS<2,1>
    Y.LT.TT.PUR.NAME.POS = FLD.POS<3,1>
    Y.LT.TT.POS.STATUS.POS = FLD.POS<3,2>
    

    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.PO.COLL.DATE=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitValueDate)
        Y.PO.AC=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAcctNo)
        Y.PO.NO=EB.SystemTables.getRNew(FT.Contract.FundsTransfer.StockNumber)
        Y.PURCH.NAME= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
        Y.ISSUE.CHQ.TYP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.FT.LOC.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.STATUS = Y.FT.LOC.REF<1,LT.TT.PO.CANCEL.POS>

        Y.PO.COLL.REF=EB.SystemTables.getIdNew()
        Y.PO.COLL.CO=EB.SystemTables.getIdCompany()

* Y.ID='PO.':Y.PO.AC:".":Y.PO.NO
        Y.ID=Y.ISSUE.CHQ.TYP:'.':Y.PO.AC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
 
        Y.CQ.TEMP = EB.SystemTables.getRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef)
        Y.CQ.TEMP<1,Y.CRS.COLL.DAT.POS> = Y.PO.COLL.DATE
        Y.CQ.TEMP<1,Y.CRS.COLL.REF.POS> = Y.PO.COLL.REF
        Y.CQ.TEMP<1,Y.CRS.COLL.CO.POS> = Y.PO.COLL.CO
        Y.CQ.TEMP<1,Y.CRS.PUR.NAME.POS> = Y.PURCH.NAME
        Y.CQ.TEMP<1,Y.NEW.STATUS.POS> = Y.STATUS
  
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.CQ.TEMP
    
        !EB.SystemTables.setRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef, Y.CQ.TEMP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.ID
    END


*** </region>
    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.PO.CAN.DATE = EB.SystemTables.getRNew(TT.Contract.Teller.TeValueDateTwo)
        Y.PO.AC = EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
        Y.PO.NO = EB.SystemTables.getRNew(TT.Contract.Teller.TeStockNumber)
        Y.TT.ISS.CHQ = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.PO.COLL.REF.TT = EB.SystemTables.getIdNew()
        Y.PO.COLL.CO.CODE = EB.SystemTables.getIdCompany()
        
*--------------------------------PUR NAME FROM TT APPLICATION ------------------------------
        Y.TT.LOC.REF= EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.TT.PUR.NAME = Y.TT.LOC.REF<1,Y.LT.TT.PUR.NAME.POS>
        Y.TT.PO.STATUS = Y.TT.LOC.REF<1,Y.LT.TT.POS.STATUS.POS>
*------------------------------------------------------------------------
*  Y.PO.ID = 'PO.':Y.PO.AC:'.':Y.PO.NO
        Y.PO.ID = Y.TT.ISS.CHQ:'.':Y.PO.AC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.PO.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
 
        Y.CQ.TEMP = EB.SystemTables.getRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef)
        Y.CQ.TEMP<1,Y.CRS.COLL.DAT.POS> = Y.PO.CAN.DATE
        Y.CQ.TEMP<1,Y.CRS.COLL.REF.POS> = Y.PO.COLL.REF.TT
        Y.CQ.TEMP<1,Y.CRS.COLL.CO.POS> = Y.PO.COLL.CO.CODE
        Y.CQ.TEMP<1,Y.CRS.PUR.NAME.POS> = Y.TT.PUR.NAME
        Y.CQ.TEMP<1,Y.NEW.STATUS.POS> = Y.TT.PO.STATUS
  
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.CQ.TEMP
    
        !EB.SystemTables.setRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef, Y.CQ.TEMP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.PO.ID
* EB.DataAccess.FLiveWrite(F.CHQ.REG.SUP, Y.PO.ID, Rec.CHQ.REG.SUP)
    END
RETURN

END
