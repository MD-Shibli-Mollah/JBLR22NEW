
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
    LOCAL.FIELDS = "LT.ISS.OLD.CHQ":@VM:"LT.PAYEE.NAME"
    EB.Foundation.MapLocalFields("FUNDS.TRANSFER", LOCAL.FIELDS, FLD.POS)
    Y.ISS.OLD.CHQ.POS = FLD.POS<1,1>
    Y.PAYEE.NAME.POS = FLD.POS<1,2>
    Y.TOTAL.LT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LT.ISS.OLD.CHQ = Y.TOTAL.LT<1, Y.ISS.OLD.CHQ.POS>
    Y.LT.PAYEE.NAME = Y.TOTAL.LT<1, Y.PAYEE.NAME.POS>
    
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
*******--------------------------TRACER------------------------------------------------------------------------------
        WriteData = "Y.VFUNCTION: ":Y.VFUNCTION:" Y.INSTR.ID: ": Y.INSTR.ID :" REC.INSTR: ": REC.INSTR
        FileName = 'SHIBLI_INSTR.INFO.D.FT.update.txt'
        FilePath = 'DL.BP'
* FilePath = 'D:\Temenos\t24home\default\SHIBLI.BP'
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
        RETURN
    END
    WRITE REC.INSTR TO F.INSTRUMENT.INFO, Y.INSTR.ID
    
RETURN
END

