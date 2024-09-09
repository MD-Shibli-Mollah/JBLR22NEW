
SUBROUTINE GB.JBL.A.CASH.INSTR.INFO

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENTS.INFO Template
* Attach To: VERSION(TELLER,JBL.PO.LCY.CASHIN, TELLER,JBL.INS.PAY.CASH.FOREIGN)
* Attach As: AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* Modification History : *LT.PAYEE.NAME & LT.ISS.OLD.CHQ is required to avoid CORE Validation in FT...
*
*
* 08/05/2024 -                             MODIIFY -  MD SHIBLI MOLLAH
*                                                     NITSL Limited

*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.INSTRUMENTS.INFO
    
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Foundation
    
* Y.FT.REC.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
* Y.TT.REC.STATUS = EB.SystemTables.getRNew(TT.Contract.Teller.TeRecordStatus)
* Y.VFUNCTION = EB.SystemTables.getVFunction()
    Y.INSTR.ID = EB.SystemTables.getIdNew()
    Y.APPLICATION = EB.SystemTables.getApplication()
    Y.VER = EB.SystemTables.getPgmVersion()
*    IF Y.VFUNCTION EQ 'R' OR Y.FT.REC.STATUS EQ 'RNAU' OR Y.TT.REC.STATUS EQ 'RNAU' THEN
*        RETURN
*    END
    
    GOSUB INIT
    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*----
INIT:
*----
    FN.INSTRUMENT.INFO = 'F.EB.JBL.INSTRUMENTS.INFO'
    F.INSTRUMENT.INFO = ''

RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.INSTRUMENT.INFO, F.INSTRUMENT.INFO)
RETURN

*-------
PROCESS:
*-------

    IF Y.APPLICATION EQ 'TELLER' THEN
        FLD.POS = ""
        EB.Foundation.MapLocalFields("TELLER", "LT.PUR.NAME", FLD.POS)
        Y.LT.PUR.NAME.POS = FLD.POS<1,1>
        Y.TOTAL.LT = EB.SystemTables.getRNew(TT.Contract.Teller.TeLocalRef)
        Y.LT.PUR.NAME = Y.TOTAL.LT<1, Y.LT.PUR.NAME.POS>
        
        REC.INSTR<EB.JBL37.INSTRUMENT.TYPE>= EB.SystemTables.getRNew(TT.Contract.Teller.TeIssueChequeType)
        REC.INSTR<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountLocalTwo)
        
* Check for Foreign Currency
        IF Y.VER EQ ",JBL.INS.PAY.CASH.FOREIGN" THEN
            REC.INSTR<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(TT.Contract.Teller.TeAmountFcyOne)
        END
        
* Purchaser -- LT.PUR.NAME
        REC.INSTR<EB.JBL37.PURCHASER.NAME>= Y.LT.PUR.NAME
* PAYEE.NAME is Beneficiary
        REC.INSTR<EB.JBL37.PAYEE.NAME> = EB.SystemTables.getRNew(TT.Contract.Teller.TePayeeName)
        REC.INSTR<EB.JBL37.ISSUED.BRANCH>= EB.SystemTables.getRNew(TT.Contract.Teller.TeCoCode)
        REC.INSTR<EB.JBL37.STATUS>= "CASH DEPOSITED"
    END

    IF Y.APPLICATION EQ 'FUNDS.TRANSFER' THEN
* LT.PAYEE.NAME(PAYEE.NAME) & LT.ISS.OLD.CHQ(ISSUE.CHEQUE.TYPE) is required to avoid CORE Validation...
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
                
        REC.INSTR<EB.JBL37.INSTRUMENT.TYPE> = Y.LT.ISS.OLD.CHQ
        REC.INSTR<EB.JBL37.PAYEE.NAME> = Y.LT.PAYEE.NAME
        
        Y.CR.AMOUNT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CreditAmount)
        
*--- CreditAmount is used for PO/PS/SDR but AMOUNT.CREDITED is used for FDD/FTT/FMT
        Y.AMOUNT = Y.CR.AMOUNT
        IF Y.AMOUNT EQ "" THEN
            Y.AMOUNT.CREDITED = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AmountCredited)
            Y.LEN = LEN(Y.AMOUNT.CREDITED)
            Y.CREDITED.AMOUNT = Y.AMOUNT.CREDITED[4,Y.LEN]
            Y.AMOUNT = Y.CREDITED.AMOUNT
        END
        
        REC.INSTR<EB.JBL37.AMOUNT> = Y.AMOUNT
        REC.INSTR<EB.JBL37.PURCHASER.NAME> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
        REC.INSTR<EB.JBL37.ISSUED.BRANCH> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
        REC.INSTR<EB.JBL37.STATUS> = "CASH DEPOSITED"
        
        IF Y.VER EQ ",JBL.2ND.PHASE.TT.MT" THEN
*--- Generate ID--------*
            Y.INSTR.ID.REF = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitTheirRef)
*       Y.INSTR.ID.REF = "REFTT21105W5VDG"
            Y.INSTR.ID = Y.INSTR.ID.REF[4,13]
            REC.INSTR<EB.JBL37.RESERVED.1> = Y.ADV.REF.NO
        END
        
*--- For TT,MT it will work like single shot issue so here local template will be updated with leaf issued.
        IF (Y.LT.ISS.OLD.CHQ EQ "TT") OR (Y.LT.ISS.OLD.CHQ EQ "MT") THEN
            REC.INSTR<EB.JBL37.ISSUED.BRANCH>= Y.LT.BRANCH
            REC.INSTR<EB.JBL37.STATUS>= "LEAF ISSUED"
        END
    END
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.AMOUNT: ":Y.AMOUNT:" Y.VER: ":Y.VER:" Y.AMOUNT.CREDITED: ": Y.AMOUNT.CREDITED :" REC.INSTR: ": REC.INSTR
    FileName = 'SHIBLI_INSTR.INFO.TT.MT.AMOUNT.txt'
* FilePath = 'DL.BP'
    FilePath = 'DL.BP'
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
    
    WRITE REC.INSTR TO F.INSTRUMENT.INFO, Y.INSTR.ID
* EB.DataAccess.FLiveWrite(F.INSTRUMENT.INFO, Y.INSTR.ID, REC.INSTR)
    
RETURN
END

