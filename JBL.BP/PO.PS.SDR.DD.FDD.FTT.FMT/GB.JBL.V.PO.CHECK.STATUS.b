SUBROUTINE GB.JBL.V.PO.CHECK.STATUS
*-----------------------------------------------------------------------------
*
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
    $USING EB.Foundation
    $USING EB.Updates
    
    GOSUB PROCESS
RETURN

PROCESS:
    FN.CHQ.REG.SUP = 'F.CHEQUE.REGISTER.SUPPLEMENT'
    F.CHQ.REG.SUP = ''
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    FN.TEL = 'F.TELLER' ; F.TEL =''
 

    EB.DataAccess.Opf(FN.CHQ.REG.SUP, F.CHQ.REG.SUP)
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.TEL, F.TEL)
*  EB.DataAccess.Opf(FN.FT.HIS, F.FT.HIS)

    Y.APP.NAME ='CHEQUE.REGISTER.SUPPLEMENT':@FM:'TELLER':@FM:'FUNDS.TRANSFER'
    LOCAL.FIELDS = 'NEW.STATUS':@FM:'LT.PUR.NAME':@VM:'LT.ISS.OLD.CHQ':@FM:'LT.ISS.OLD.CHQ'
    FLD.POS = ""
    
    EB.Updates.MultiGetLocRef(Y.APP.NAME, LOCAL.FIELDS, FLD.POS)
    Y.NEW.STATUS.POS = FLD.POS<1,1>
    Y.LT.PUR.NAME.POS = FLD.POS<2,1>
    Y.LT.TT.ISS.OLD.CHQ.POS = FLD.POS<2,2>
    Y.LT.ISS.OLD.CHQ.POS = FLD.POS<3,1>
    
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.TEMP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
        Y.OLD.ISS.CHQ.TYP = Y.TEMP<1,Y.LT.ISS.OLD.CHQ.POS>
    END
    ELSE
        Y.TEMP = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.OLD.ISS.CHQ.TYP = Y.TEMP<1,Y.LT.TT.ISS.OLD.CHQ.POS>
    END
*********************GET OLD PO/STOCK REGISTER NUMBER***************************
    Y.PO.LEF = EB.SystemTables.getComi()
*******************************************************************************
    Y.PO.ID = Y.OLD.ISS.CHQ.TYP:'.':'BDT1770600010001':'.': Y.PO.LEF
    
    EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.PO.ID, Rec.PO, F.CHQ.REG.SUP, Y.Err)
    IF Rec.PO EQ '' THEN
        EB.SystemTables.setEtext('Wrong Pay Order Number')
        EB.ErrorProcessing.StoreEndError()
        !RETURN
    END
   
    Y.PO.STATUS = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsStatus>
*Y.FT.ID=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
*    EB.DataAccess.FRead(FN.FT, Y.FT.ID, Rec.FT, F.FT, Y.Err)
*    FT.REC.STATUS = Rec.FT<FT.Contract.FundsTransfer.RecordStatus>
    IF Y.PO.STATUS EQ 'ISSUED' OR Y.PO.STATUS EQ 'CANCELLED' THEN
        EB.SystemTables.setEtext('PayOrder Leaf is Not Cleared')
        EB.ErrorProcessing.StoreEndError()
        !RETURN
    END
* Y.CQ.TEMP = EB.SystemTables.getRNew(CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef)
    Y.LOC.CHQ = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
    Y.NEW.STATUS = Y.LOC.CHQ<1,Y.NEW.STATUS.POS>
    
    IF Y.NEW.STATUS EQ 'CANCELLED' THEN
        EB.SystemTables.setEtext('PayOrder Status is Cancelled')
        EB.ErrorProcessing.StoreEndError()
        !RETURN
    END
     
  
    Y.PO.ORGIN = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOrigin>
    IF  Y.PO.ORGIN EQ 'TELLER' THEN
        Y.TT.PO.ORGIN.REF = Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
        EB.DataAccess.FRead(FN.TEL,Y.TT.PO.ORGIN.REF, R.TT, F.TEL, Y.TT.ERR)
        Y.TT.PO.PAY.NAME = R.TT<TT.Contract.Teller.TePayeeName>
        Y.TT.LOC.REF= R.TT<TT.Contract.Teller.TeLocalRef>
        Y.TT.PUR.NAME = Y.TT.LOC.REF<1,Y.LT.PUR.NAME.POS>
        Y.TT.AMT = R.TT<TT.Contract.Teller.TeAmountLocalOne>
*-------------------------------------------------------------------------
        IF (EB.SystemTables.getPgmVersion() EQ ',JBL.PO.DUP.SELL.CASH') THEN
            EB.SystemTables.setRNew(TT.Contract.Teller.TePayeeName,Y.TT.PO.PAY.NAME)
            Y.TEMP = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
            Y.TEMP<1,Y.LT.PUR.NAME.POS> = Y.TT.PUR.NAME
            EB.SystemTables.setRNew(TT.Contract.Teller.TeLocalRef,Y.TEMP)
            EB.SystemTables.setRNew(TT.Contract.Teller.TeAmountLocalOne,Y.TT.AMT)
        END
    END
* Y.PO.ORGIN.FT = Y.PO.ORGIN.REF:';1'
*------------------------------ Purchaser name ---------------------------
    IF  Y.PO.ORGIN EQ 'FUNDS.TRANSFER' THEN
*----------------------------------purchaser name-----------------------
        Y.PO.ORGIN.REF=Rec.PO<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsOriginRef>
        EB.DataAccess.FRead(FN.FT, Y.PO.ORGIN.REF, R.FT, F.FT, Y.FT.Err)
        Y.PO.PAY.NAME=R.FT<FT.Contract.FundsTransfer.PayeeName>
        Y.PUR.NAME= R.FT<FT.Contract.FundsTransfer.PaymentDetails>
        Y.PO.AC.NO= R.FT<FT.Contract.FundsTransfer.DebitAcctNo>
        Y.PO.AC.CR= R.FT<FT.Contract.FundsTransfer.CreditAcctNo>
        Y.PO.CR.AMOUNT = R.FT<FT.Contract.FundsTransfer.CreditAmount>
*-------------------------------------------------------------------------
*IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        IF (EB.SystemTables.getPgmVersion() EQ ',JBL.DUP.PO.ISSUE') THEN
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PayeeName, Y.PO.PAY.NAME)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.PaymentDetails, Y.PUR.NAME)
            EB.SystemTables.setRNew(FT.Contract.FundsTransfer.CreditAmount, Y.PO.CR.AMOUNT)
        END
    END
RETURN
END

