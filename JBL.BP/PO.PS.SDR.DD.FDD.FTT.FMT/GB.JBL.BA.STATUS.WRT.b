
SUBROUTINE GB.JBL.BA.STATUS.WRT
*-----------------------------------------------------------------------------
* Develop by NILOY SARKAR ; NITSL
* Description: This routine is written to read data from Funds Transfer and Write in to cheque register supplyment
* Written in (FUNDS.TRANSFER,JBL.DUP.PO.ISSUE) and (TELLER,JBL.PO.DUP.SELL.CASH) Version as a before auth routine.
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
* 09/03/2024 - UPDATED BY                         UPDATE - MD SHIBLI MOLLAH
*                                                 NITSL
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
    
    GOSUB INITIALISE ; *
    GOSUB OPENFILE ; *
    GOSUB PROCESS ; *
RETURN
  
*---------------------
INITIALISE:
*---------------------
    FN.CHQ.REG.SUP = 'F.CHEQUE.REGISTER.SUPPLEMENT'
    F.CHQ.REG.SUP = ''
    FN.FT = 'F.FUNDS.TRANSFER'
    F.FT = ''
    FN.TEL = 'F.TELLER'
    F.TEL = ''
    
    Y.APP.NAME = 'CHEQUE.REGISTER.SUPPLEMENT':@FM:'FUNDS.TRANSFER':@FM:'TELLER'
    LOCAL.FIELDS = 'NEW.STATUS':@VM:'LT.CRS.OLD.PO':@VM:'LT.CRS.ALL.COM':@FM:'LT.TT.PO.CANCEL':@VM:'LT.OLD.PO.NO':@VM:'LT.ISS.OLD.CHQ':@VM:'LT.ALLOW.PO.COM':@FM:'LT.TT.PO.CANCEL':@VM:'LT.OLD.PO.NO':@VM:'LT.ISS.OLD.CHQ':@VM:'LT.ALLOW.PO.COM'
    FLD.POS = ""
    
    EB.Updates.MultiGetLocRef(Y.APP.NAME,LOCAL.FIELDS,FLD.POS)
    Y.NEW.STATUS.POS = FLD.POS<1,1>
    Y.LT.CRS.OLD.PO.POS = FLD.POS<1,2>
    Y.LT.CRS.ALL.COM.POS = FLD.POS<1,3>
    LT.TT.PO.CANCEL.POS = FLD.POS<2,1>
    LT.OLD.PO.NO.POS = FLD.POS<2,2>
    Y.LT.FT.ISS.OLD.CHQ.POS = FLD.POS<2,3>
    Y.LT.ALLOW.PO.COM.POS = FLD.POS<2,4>
    Y.LT.TT.PO.CANCEL.POS = FLD.POS<3,1>
    Y.LT.TT.OLD.PO.NO.POS = FLD.POS<3,2>
    Y.LT.TT.ISS.OLD.CHQ.POS = FLD.POS<3,3>
    Y.LT.TT.ALLOW.PO.COM.POS = FLD.POS<3,4>
    Y.FT.LOC.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.TT.LOC.REF = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
RETURN
*----------------
OPENFILE:
*-----------------
    EB.DataAccess.Opf(FN.CHQ.REG.SUP, F.CHQ.REG.SUP)
    EB.DataAccess.Opf(FN.FT, F.FT)
    EB.DataAccess.Opf(FN.TEL, F.TEL)
RETURN

*-------------
PROCESS:
*--------------
    IF EB.SystemTables.getApplication() EQ 'FUNDS.TRANSFER' THEN
        Y.PO.AC = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
        Y.PO.NO = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.StockNumber)
        Y.FT.ISS.CHQ.TYP = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
        Y.STATUS = Y.FT.LOC.REF<1,LT.TT.PO.CANCEL.POS>
        Y.OLD.PO.NO = Y.FT.LOC.REF<1,LT.OLD.PO.NO.POS>
        Y.OLD.FT.ISS.TYP = Y.FT.LOC.REF<1,Y.LT.FT.ISS.OLD.CHQ.POS>
        Y.FT.ALLOW.COM = Y.FT.LOC.REF<1,Y.LT.ALLOW.PO.COM.POS>
        Y.PO.COLL.REF = EB.SystemTables.getIdNew()
        Y.PO.COLL.CO = EB.SystemTables.getIdCompany()

*-----------------------------OLD PO NUMBER---------------------
        Y.OLD.ID = Y.OLD.FT.ISS.TYP:'.':Y.PO.AC:'.':Y.OLD.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.OLD.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.LOC.CHQ<1,Y.NEW.STATUS.POS> = 'DUPLICATE.MARK'
**-----------------------------WRITE DATA--------------------------
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.LOC.CHQ
*    EB.DataAccess.FLiveWrite(F.CHQ.REG.SUP, Y.OLD.ID, Rec.CHQ.REG.SUP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.OLD.ID
*----------------------------------------------------------------
        Y.ID = Y.FT.ISS.CHQ.TYP:'.':Y.PO.AC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.LOC.CHQ<1,Y.NEW.STATUS.POS> = Y.STATUS
        Y.LOC.CHQ<1,Y.LT.CRS.OLD.PO.POS> = Y.OLD.PO.NO
        Y.LOC.CHQ<1,Y.LT.CRS.ALL.COM.POS> = Y.FT.ALLOW.COM
*-----------------------------WRITE DATA--------------------------
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.LOC.CHQ
*
* EB.DataAccess.FLiveWrite(F.CHQ.REG.SUP, Y.ID, Rec.CHQ.REG.SUP)
        WRITE Rec.CHQ.REG.SUP ON F.CHQ.REG.SUP, Y.ID
*-----------------------------------------------------------------
    END
   

    IF EB.SystemTables.getApplication() EQ 'TELLER' THEN
        Y.PO.COLL.DATE=EB.SystemTables.getRNew(TT.Contract.Teller.TeValueDateTwo)
        Y.PO.AC=EB.SystemTables.getRNew(TT.Contract.Teller.TeAccountOne)
        Y.PO.NO=EB.SystemTables.getRNew(TT.Contract.Teller.TeStockNumber)
        Y.TT.ISS.TYP = EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        Y.TT.PO.STATUS = Y.TT.LOC.REF<1,Y.LT.TT.PO.CANCEL.POS>
        Y.TT.OLD.PO.NO = Y.TT.LOC.REF<1,Y.LT.TT.OLD.PO.NO.POS>
        Y.TT.OLD.ISS.TYP = Y.TT.LOC.REF<1,Y.LT.TT.ISS.OLD.CHQ.POS>
        Y.TT.ALLOW.COM = Y.TT.LOC.REF<1,Y.LT.TT.ALLOW.PO.COM.POS>
        Y.PO.COLL.REF=EB.SystemTables.getIdNew()
        Y.PO.COLL.CO=EB.SystemTables.getIdCompany()
*-----------------------------OLD PO NUMBER-------------------------------
        Y.OLD.ID = Y.TT.OLD.ISS.TYP:'.':Y.PO.AC:'.':Y.TT.OLD.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.OLD.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.LOC.CHQ<1,Y.NEW.STATUS.POS> = 'DUPLICATE.MARK'
*-----------------------------WRITE DATA-----------------------------------
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.LOC.CHQ
        EB.DataAccess.FLiveWrite(F.CHQ.REG.SUP, Y.OLD.ID, Rec.CHQ.REG.SUP)
*---------------------------------------------------------------- ----------
        Y.PO.ID=Y.TT.ISS.TYP:'.':Y.PO.AC:'.':Y.PO.NO
        EB.DataAccess.FRead(FN.CHQ.REG.SUP, Y.PO.ID, Rec.CHQ.REG.SUP, F.CHQ.REG.SUP, Y.Err)
        Y.LOC.CHQ = Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef>
        Y.LOC.CHQ<1,Y.NEW.STATUS.POS> = Y.TT.PO.STATUS
        Y.LOC.CHQ<1,Y.LT.CRS.OLD.PO.POS> = Y.TT.OLD.PO.NO
        Y.LOC.CHQ<1,Y.LT.CRS.ALL.COM.POS> = Y.TT.ALLOW.COM
*-----------------------------TELLER WRITE DATA IN CHQ REG SUPPLIMENT--------------------------
        Rec.CHQ.REG.SUP<CQ.ChqSubmit.ChequeRegisterSupplement.CcCrsLocalRef> = Y.LOC.CHQ
*-----------------------------------------------------------------
        EB.DataAccess.FLiveWrite(F.CHQ.REG.SUP, Y.PO.ID, Rec.CHQ.REG.SUP)
    END
RETURN
        
END
