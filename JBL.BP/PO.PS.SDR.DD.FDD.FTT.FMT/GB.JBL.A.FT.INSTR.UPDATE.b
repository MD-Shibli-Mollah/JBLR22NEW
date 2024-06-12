
SUBROUTINE GB.JBL.A.FT.INSTR.UPDATE

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENTS.INFO Template
* Attach To: VERSION(FUNDS.TRANSFER,JBL.PO.ISSUE.2)
* Attach As: AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
* 08/05/2024 -                             MODIIFY -  MD SHIBLI MOLLAH
*                                                     NITSL Limited
* LT.TT.FT.REF.NO is discouraged, DEBIT.THEIR.REF will be considered to keep it.
*
* NEW CONSIDERATION FOR FTT --- PAYEE NAME AND INSTRUMENT TYPE MUST FROM LOCAL FIELD
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
    
    Y.FT.REC.STATUS = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.RecordStatus)
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
    REC.INSTR<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.AmountDebited)
    REC.INSTR<EB.JBL37.PURCHASER.NAME>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
    REC.INSTR<EB.JBL37.PAYEE.NAME> = Y.PAYEE.NAME
    REC.INSTR<EB.JBL37.ISSUED.BRANCH>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
    REC.INSTR<EB.JBL37.PAYEE.BRANCH>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.CoCode)
    REC.INSTR<EB.JBL37.STATUS>= "LEAF ISSUED"
    
*******--------------------------TRACER------------------------------------------------------------------------------
    WriteData = "Y.INSTR.ID: ": Y.INSTR.ID :" REC.INSTR: ": REC.INSTR
    FileName = 'SHIBLI_INSTR.INFO.FT.txt'
* FilePath = 'DL.BP'
    FilePath = 'D:\Temenos\t24home\default\SHIBLI.BP'
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

