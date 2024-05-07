
SUBROUTINE GB.JBL.A.FT.INSTR.UPDATE

* Subroutine Description:
* THIS ROUTINE is used to UPDATE the EB.JBL.INSTRUMENTS.INFO Template
* Attach To: VERSION(FUNDS.TRANSFER,JBL.PO.ISSUE.2)
* Attach As: AUTH ROUTINE
*-----------------------------------------------------------------------------
* Modification History :
* 06/05/2024 -                             NEW -  MD SHIBLI MOLLAH
*                                                 NITSL Limited
*
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.JBL.INSTRUMENTS.INFO
    
    $USING FT.Contract
    $USING TT.Contract
    $USING EB.SystemTables
    $USING EB.DataAccess
    $USING EB.Updates
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
    
    EB.Foundation.MapLocalFields("FUNDS.TRANSFER", "LT.TT.FT.REF.NO", FLD.POS)
    Y.LT.TT.REF.NO.POS = FLD.POS<1,1>
    Y.TOTAL.LT = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.LocalRef)
    Y.LT.TT.REF.NO = Y.TOTAL.LT<1, Y.LT.TT.REF.NO.POS>
    
    Y.INSTR.ID = Y.LT.TT.REF.NO
     
RETURN

*---------
OPENFILES:
*---------
    EB.DataAccess.Opf(FN.INSTRUMENT.INFO, F.INSTRUMENT.INFO)
RETURN

*-------
PROCESS:
*-------
    REC.INSTR<EB.JBL37.INSTRUMENT.TYPE>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.IssueChequeType)
    REC.INSTR<EB.JBL37.AMOUNT> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.DebitAmount)
* Purchaser -- LT.PUR.NAME
    REC.INSTR<EB.JBL37.PURCHASER.NAME>= EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PaymentDetails)
* PAYEE.NAME is Beneficiary
    REC.INSTR<EB.JBL37.PAYEE.NAME> = EB.SystemTables.getRNew(FT.Contract.FundsTransfer.PayeeName)
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

