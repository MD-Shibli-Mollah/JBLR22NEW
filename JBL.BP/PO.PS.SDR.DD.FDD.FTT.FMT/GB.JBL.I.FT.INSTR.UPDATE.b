
SUBROUTINE GB.JBL.I.FT.INSTR.UPDATE

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENTS.INFO Template
* Attach To: VERSION(FUNDS.TRANSFER,JBL.PO.ISSUE.2 & ALL FOREIGN & LOCAL Remittance (Double Phase)
* Attach As: INPUT ROUTINE
*-----------------------------------------------------------------------------

* Modification History :
* 21/08/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited

* LT.TT.FT.REF.NO is discouraged, DEBIT.THEIR.REF will be considered to keep it.
*
* NEW CONSIDERATION FOR FTT --- PAYEE NAME AND INSTRUMENT TYPE MUST FROM LOCAL FIELD

* After input the status of the version the record the in the template (EB.JBL.INSTRUMENTS.INFO) will be "PENDING"

* If the USER DELETE the Rec then the status will be back to "CASH DEPOSITED"
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.INSTRUMENTS.INFO
    
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
* $USING EB.Updates
    $USING EB.Foundation
    
    Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.VER = EB.SystemTables.getPgmVersion()
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.INSTRUMENT.INFO = 'F.EB.JBL.INSTRUMENTS.INFO'
    F.INSTRUMENT.INFO = ''
    
    FLD.POS = ""
    LOCAL.FIELDS = ""
    LOCAL.FIELDS = "LT.PAYEE.NAME":@VM:"LT.ISS.OLD.CHQ":@VM:"LT.BRANCH":@VM:"LT.ADV.REF.NO"
    EB.Foundation.MapLocalFields("FUNDS.TRANSFER", LOCAL.FIELDS, FLD.POS)
    Y.LT.PAYEE.NAME.POS= FLD.POS<1,1>
    Y.LT.ISS.OLD.CHQ.POS = FLD.POS<1,2>
    Y.LT.BRANCH.POS = FLD.POS<1,3>
    Y.LT.ADV.REF.NO.POS = FLD.POS<1,4>
    Y.TOTAL.LT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LT.PAYEE.NAME = Y.TOTAL.LT<1,Y.LT.PAYEE.NAME.POS>
    Y.LT.ISS.OLD.CHQ = Y.TOTAL.LT<1,Y.LT.ISS.OLD.CHQ.POS>
    Y.LT.BRANCH = Y.TOTAL.LT<1,Y.LT.BRANCH.POS>
    Y.ADV.REF.NO = Y.TOTAL.LT<1,Y.LT.ADV.REF.NO.POS>
    
*--- Generate ID--------*
    Y.INSTR.ID.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitTheirRef)
* Y.INSTR.ID.REF = "REFTT21105W5VDG"
    Y.INSTR.ID = Y.INSTR.ID.REF[4,13]
     
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.INSTRUMENT.INFO, F.INSTRUMENT.INFO)
RETURN

*-------
PROCESS:
*-------
    
    Y.ISSUE.CHEQUE.TYPE = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
    Y.PAYEE.NAME = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PayeeName)
    
    IF Y.ISSUE.CHEQUE.TYPE EQ "" THEN
        Y.ISSUE.CHEQUE.TYPE = Y.LT.ISS.OLD.CHQ
    END
    
    IF Y.PAYEE.NAME EQ "" THEN
        Y.PAYEE.NAME = Y.LT.PAYEE.NAME
    END
    
    REC.INSTR<EB.JBL37.INSTRUMENT.TYPE>= Y.ISSUE.CHEQUE.TYPE
    REC.INSTR<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
    REC.INSTR<EB.JBL37.PURCHASER.NAME>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
    REC.INSTR<EB.JBL37.PAYEE.NAME> = Y.PAYEE.NAME
    REC.INSTR<EB.JBL37.ISSUED.BRANCH>= EB.SystemTables.getIdCompany()
    REC.INSTR<EB.JBL37.STATUS>= "PENDING"
    
    IF Y.VFUNCTION EQ "D" THEN
        REC.INSTR<EB.JBL37.STATUS>= "CASH DEPOSITED"
        IF (Y.VER EQ ",JBL.TT.ISSUE.2") OR (Y.VER EQ ",JBL.MT.ISSUE.2") THEN
            REC.INSTR<EB.JBL37.RESERVED.1> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAcctNo)
            REC.INSTR<EB.JBL37.STATUS>= "LEAF ISSUED"
        END
        WRITE REC.INSTR TO F.INSTRUMENT.INFO, Y.INSTR.ID
        RETURN
    END
    
    WRITE REC.INSTR TO F.INSTRUMENT.INFO, Y.INSTR.ID
    
RETURN
END

